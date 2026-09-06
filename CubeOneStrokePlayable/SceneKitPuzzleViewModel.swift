import Combine
import SceneKit
import UIKit

@MainActor
final class SceneKitPuzzleViewModel: ObservableObject {
    let scene = SCNScene()

    @Published private(set) var stageTitle = ""
    @Published private(set) var debugText = ""
    @Published private(set) var canUndo = false
    @Published private(set) var canAdvanceStage = false
    @Published private(set) var isRotationModeEnabled = false

    private let cameraNode = SCNNode()
    private let cubeNode = SCNNode()
    private let stages = StageCatalog.makeStages()
    private let faceScenes: [CubeFace: SpriteKitFaceScene]

    private var stageIndex = 0
    private var currentTileID = TileID(row: 0, column: 0)
    private var pathTileIDs: [TileID] = []
    private var completedStageIndexes: Set<Int> = []
    private var completedStagePaths: [Int: [TileID]] = [:]
    private var isStageComplete = false

    private var currentBoard: BoardPlan {
        stages[stageIndex]
    }

    init() {
        var scenes: [CubeFace: SpriteKitFaceScene] = [:]

        for face in CubeFace.allCases {
            scenes[face] = SpriteKitFaceScene(size: CGSize(width: 768, height: 768))
        }

        faceScenes = scenes
        configureScene()
        loadStage(at: 0)
    }

    func handleTap(at point: CGPoint, in sceneView: SCNView) {
        if isRotationModeEnabled {
            debugText = "회전 모드가 켜져 있어요. 퍼즐 선택은 잠시 막혀 있습니다."
            return
        }

        let hitResults = sceneView.hitTest(
            point,
            options: [
                SCNHitTestOption.firstFoundOnly: true
            ]
        )

        guard let hitResult = hitResults.first else {
            debugText = "큐브를 터치하지 않았어요."
            return
        }

        if hitResult.node !== cubeNode {
            debugText = "퍼즐 큐브가 아닌 곳을 터치했어요."
            return
        }

        guard let tappedFace = CubeFace(rawValue: hitResult.geometryIndex) else {
            debugText = "어느 cube face인지 확인하지 못했어요."
            return
        }

        if tappedFace != currentBoard.cubeFace {
            debugText = "\(tappedFace.koreanName)은 지금 stage의 면이 아니에요. \(currentBoard.cubeFace.koreanName)을 터치하세요."
            return
        }

        let textureCoordinate = hitResult.textureCoordinates(withMappingChannel: 0)

        guard let tileID = currentBoard.tileID(fromTextureCoordinate: textureCoordinate) else {
            debugText = "터치 좌표를 타일로 바꾸지 못했어요."
            return
        }

        selectTile(tileID, textureCoordinate: textureCoordinate)
    }

    func handlePan(translation: CGPoint) {
        if isRotationModeEnabled == false {
            return
        }

        let xRotation = Float(translation.y) * 0.008
        let yRotation = Float(translation.x) * 0.008

        cubeNode.eulerAngles.x += xRotation
        cubeNode.eulerAngles.y += yRotation
    }

    func setRotationModeEnabled(_ enabled: Bool) {
        if isRotationModeEnabled == enabled {
            return
        }

        isRotationModeEnabled = enabled

        let targetScale: CGFloat = enabled ? 0.82 : 1.0
        let scaleAction = SCNAction.scale(to: targetScale, duration: 0.18)

        cubeNode.removeAction(forKey: "rotationModeScale")
        cubeNode.runAction(scaleAction, forKey: "rotationModeScale")

        if enabled {
            debugText = "회전 모드 ON: 드래그로 큐브를 돌려 다음 stage 면을 확인하세요."
        } else {
            debugText = "회전 모드 OFF: 현재 stage 면을 터치해 경로를 이어갑니다."
        }
    }

    func resetCurrentStage() {
        loadStage(at: stageIndex)
    }

    func undoLastStep() {
        if pathTileIDs.count <= 1 {
            debugText = "시작 칸은 취소할 수 없어요."
            return
        }

        let removedTileID = pathTileIDs.removeLast()
        currentTileID = pathTileIDs.last ?? currentBoard.startTileID
        isStageComplete = false
        renderBoards()
        debugText = "\(removedTileID.name)을 취소했어요. 현재 칸: \(currentTileID.name)"
    }

    func goToNextStage() {
        if canAdvanceStage == false {
            debugText = "현재 퍼즐을 먼저 완료해야 다음으로 갈 수 있어요."
            return
        }

        completedStageIndexes.insert(stageIndex)
        completedStagePaths[stageIndex] = pathTileIDs
        loadStage(at: stageIndex + 1)
        rotateCube(to: currentBoard.cubeFace)
    }

    private func configureScene() {
        scene.background.contents = UIColor.systemBackground

        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5.4)
        scene.rootNode.addChildNode(cameraNode)

        cubeNode.name = "interactiveCube"
        cubeNode.geometry = makeCubeGeometry()
        cubeNode.eulerAngles = SCNVector3(x: -0.24, y: -0.34, z: 0)
        scene.rootNode.addChildNode(cubeNode)

        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 420

        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)

        let keyLight = SCNLight()
        keyLight.type = .directional
        keyLight.intensity = 760

        let keyLightNode = SCNNode()
        keyLightNode.light = keyLight
        keyLightNode.eulerAngles = SCNVector3(x: -0.7, y: 0.4, z: 0)
        scene.rootNode.addChildNode(keyLightNode)
    }

    private func makeCubeGeometry() -> SCNBox {
        let box = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0)
        var materials = Array(repeating: SCNMaterial(), count: CubeFace.allCases.count)

        for face in CubeFace.allCases {
            materials[face.rawValue] = material(for: face)
        }

        box.materials = materials

        return box
    }

    private func material(for face: CubeFace) -> SCNMaterial {
        let material = SCNMaterial()

        material.name = "\(face.description)Face"
        material.diffuse.contents = faceScenes[face]
        material.lightingModel = .constant
        material.isDoubleSided = false

        return material
    }

    private func displayAngle(for face: CubeFace) -> SCNVector3 {
        if face == .front {
            return SCNVector3(x: -0.24, y: -0.34, z: 0)
        }

        if face == .right {
            return SCNVector3(x: -0.24, y: -.pi / 2, z: 0)
        }

        if face == .top {
            return SCNVector3(x: .pi / 2, y: -0.34, z: 0)
        }

        return SCNVector3(x: -0.24, y: -0.34, z: 0)
    }

    private func rotateCube(to face: CubeFace) {
        let angle = displayAngle(for: face)
        let action = SCNAction.rotateTo(
            x: CGFloat(angle.x),
            y: CGFloat(angle.y),
            z: CGFloat(angle.z),
            duration: 0.35,
            usesShortestUnitArc: true
        )

        cubeNode.removeAction(forKey: "stageTurn")
        cubeNode.runAction(action, forKey: "stageTurn")
    }

    private func currentStageSharesEdgeWithNextStage() -> Bool {
        if stageIndex + 1 >= stages.count {
            return false
        }

        let currentStage = stages[stageIndex]
        let nextStage = stages[stageIndex + 1]

        guard let exitEdge = currentStage.exitEdge,
              let entryEdge = nextStage.entryEdge else {
            return false
        }

        guard let lastTileID = pathTileIDs.last,
              let expectedStartTileID = matchingStartTileID(
                from: lastTileID,
                exitEdge: exitEdge,
                currentStage: currentStage,
                nextStage: nextStage,
                entryEdge: entryEdge
              ) else {
            return false
        }

        return nextStage.startTileID == expectedStartTileID
    }

    private func matchingStartTileID(
        from lastTileID: TileID,
        exitEdge: TileEdge,
        currentStage: BoardPlan,
        nextStage: BoardPlan,
        entryEdge: TileEdge
    ) -> TileID? {
        if currentStage.boardSize != nextStage.boardSize {
            return nil
        }

        guard let position = lastTileID.position(
            on: exitEdge,
            boardSize: currentStage.boardSize
        ) else {
            return nil
        }

        let nextPosition = currentStage.boardSize - 1 - position

        if currentStage.cubeFace == .front &&
            exitEdge == .right &&
            nextStage.cubeFace == .right &&
            entryEdge == .left {
            return entryEdge.tileID(at: nextPosition, boardSize: nextStage.boardSize)
        }

        if currentStage.cubeFace == .right &&
            exitEdge == .top &&
            nextStage.cubeFace == .top &&
            entryEdge == .right {
            return entryEdge.tileID(at: nextPosition, boardSize: nextStage.boardSize)
        }

        return nil
    }

    private func loadStage(at newStageIndex: Int) {
        stageIndex = min(max(newStageIndex, 0), stages.count - 1)

        let board = currentBoard

        stageTitle = "\(board.title) · \(board.cubeFace.koreanName)"
        currentTileID = board.startTileID
        pathTileIDs = [board.startTileID]
        isStageComplete = false
        renderBoards()

        debugText = "\(board.cubeFace.koreanName)의 \(board.startTileID.name)에서 시작하세요. 목표는 \(board.goalTileID.name)입니다."
    }

    private func selectTile(_ tileID: TileID, textureCoordinate: CGPoint) {
        if isStageComplete {
            debugText = "이 퍼즐은 완료했어요. 다음 버튼으로 넘어가세요."
            return
        }

        let board = currentBoard
        let visitedTileIDs = Set(pathTileIDs)

        if board.isPlayable(tileID) == false {
            debugText = "\(tileID.name)은 지나갈 수 없는 칸입니다."
            return
        }

        if tileID == currentTileID {
            debugText = "\(tileID.name)은 이미 현재 칸입니다."
            return
        }

        if visitedTileIDs.contains(tileID) {
            debugText = "\(tileID.name)은 이미 지나온 칸입니다."
            return
        }

        if board.isNeighbor(from: currentTileID, to: tileID) == false {
            debugText = "\(currentTileID.name)에서 \(tileID.name)으로는 바로 이동할 수 없어요."
            return
        }

        currentTileID = tileID
        pathTileIDs.append(tileID)

        if pathTileIDs.count == board.playableTileCount && tileID == board.goalTileID {
            isStageComplete = true
        }

        renderBoards()

        let uvText = String(
            format: "u: %.2f, v: %.2f",
            textureCoordinate.x,
            textureCoordinate.y
        )

        if isStageComplete {
            if stageIndex == stages.count - 1 {
                completedStageIndexes.insert(stageIndex)
                completedStagePaths[stageIndex] = pathTileIDs
                renderBoards()
                debugText = "전체 완료! 마지막 선택: \(tileID.name) (\(uvText))"
            } else {
                debugText = "성공! 회전 모드로 다음 면을 확인한 뒤 다음 버튼으로 이어가세요. 마지막 선택: \(tileID.name) (\(uvText))"
            }
        } else {
            debugText = "선택: \(tileID.name) (\(uvText))"
        }
    }

    private func renderBoards() {
        for face in CubeFace.allCases {
            guard let faceScene = faceScenes[face] else {
                continue
            }

            guard let stageIndexForFace = stages.firstIndex(where: { $0.cubeFace == face }) else {
                faceScene.show(
                    board: blankBoard(for: face),
                    pathTileIDs: [],
                    currentTileID: nil,
                    mode: .completed
                )
                continue
            }

            let board = stages[stageIndexForFace]

            if stageIndexForFace == stageIndex {
                let mode: BoardRenderMode = isStageComplete ? .completed : .active

                faceScene.show(
                    board: board,
                    pathTileIDs: pathTileIDs,
                    currentTileID: isStageComplete ? nil : currentTileID,
                    mode: mode
                )
            } else if completedStageIndexes.contains(stageIndexForFace) {
                faceScene.show(
                    board: board,
                    pathTileIDs: completedStagePaths[stageIndexForFace] ?? [],
                    currentTileID: nil,
                    mode: .completed
                )
            } else {
                faceScene.show(
                    board: board,
                    pathTileIDs: [],
                    currentTileID: nil,
                    mode: .future
                )
            }
        }

        canUndo = pathTileIDs.count > 1 && isStageComplete == false
        canAdvanceStage = isStageComplete && currentStageSharesEdgeWithNextStage()
    }

    private func blankBoard(for face: CubeFace) -> BoardPlan {
        BoardPlan(
            title: "\(face.koreanName) 빈 면",
            boardSize: 3,
            cubeFace: face,
            coordinateLayout: .standard,
            labelCorrection: .normal,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 2, column: 2),
            entryEdge: nil,
            exitEdge: nil,
            blockedTileIDs: []
        )
    }
}
