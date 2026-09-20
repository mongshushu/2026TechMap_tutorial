import Combine
import SceneKit
import SpriteKit
import UIKit

@MainActor
final class SceneKitPuzzleViewModel: ObservableObject {
    let scene = SCNScene()

    @Published private(set) var debugText = ""

    private let board = BoardModel.twoByTwo
    private let cameraNode = SCNNode()
    private let cubeNode = SCNNode()
    private let faceScene = GameScene(size: CGSize(width: 700, height: 700))

    private var currentTileID = TileID(row: 0, column: 0)
    private var pathTileIDs = [TileID(row: 0, column: 0)]
    private var isStageComplete = false

    init() {
        faceScene.setUpPuzzleScene()
        configureScene()
    }

    func handleTap(at point: CGPoint, in sceneView: SCNView) {
        let hitResults = sceneView.hitTest(
            point,
            options: [SCNHitTestOption.firstFoundOnly: true]
        )

        guard let hitResult = hitResults.first else {
            debugText = "큐브를 터치하지 않았어요."
            return
        }

        guard hitResult.node === cubeNode else {
            debugText = "퍼즐 큐브가 아닌 곳을 터치했어요."
            return
        }

        guard hitResult.geometryIndex == 0 else {
            debugText = "SpriteKit board가 붙은 앞면을 터치하세요."
            return
        }

        let textureCoordinate = hitResult.textureCoordinates(withMappingChannel: 0)

        guard let tileID = board.tileID(from: textureCoordinate) else {
            debugText = "터치 위치를 tile로 바꾸지 못했어요."
            return
        }

        selectTile(tileID, textureCoordinate: textureCoordinate)
    }

    private func configureScene() {
        scene.background.contents = UIColor.systemBackground

        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 2.0, y: 1.4, z: 5.5)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
        scene.rootNode.addChildNode(cameraNode)

        cubeNode.name = "interactiveCube"
        cubeNode.geometry = makeCubeGeometry()
        cubeNode.eulerAngles = SCNVector3(x: -0.12, y: 0.16, z: 0)
        scene.rootNode.addChildNode(cubeNode)
    }

    private func makeCubeGeometry() -> SCNBox {
        let box = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0)

        let boardMaterial = SCNMaterial()
        boardMaterial.diffuse.contents = faceScene
        boardMaterial.lightingModel = .constant

        let grayMaterial = SCNMaterial()
        grayMaterial.diffuse.contents = UIColor.systemGray5
        grayMaterial.lightingModel = .constant

        box.materials = [
            boardMaterial,
            grayMaterial,
            grayMaterial,
            grayMaterial,
            grayMaterial,
            grayMaterial
        ]

        return box
    }

    private func selectTile(_ tileID: TileID, textureCoordinate: CGPoint) {
        guard isStageComplete == false else {
            debugText = "한붓그리기를 완료했어요."
            return
        }

        guard pathTileIDs.contains(tileID) == false else {
            debugText = "이미 지나온 tile입니다."
            return
        }

        guard board.isNeighbor(from: currentTileID, to: tileID) else {
            debugText = "현재 tile에서 한 칸 이동할 수 없는 위치입니다."
            return
        }

    }
}
