# 08 Complete Files

8장까지 튜토리얼을 따라갔을 때의 파일별 최종 완성본입니다.
중간 Step별 snippet이 아니라, 실제 프로젝트 파일 기준으로 빠르게 확인하기 위한 묶음입니다.

## BoardModel.swift

```swift
import Foundation

struct BoardModel {
    let tileIDs: Set<String>
    let neighbors: [String: Set<String>]

    static let twoByTwo = BoardModel(
        tileIDs: [
            "tile_0_0", "tile_0_1",
            "tile_1_0", "tile_1_1"
        ],
        neighbors: [
            "tile_0_0": ["tile_0_1", "tile_1_0"],
            "tile_0_1": ["tile_0_0", "tile_1_1"],
            "tile_1_0": ["tile_0_0", "tile_1_1"],
            "tile_1_1": ["tile_0_1", "tile_1_0"]
        ]
    )

    func isNeighbor(from currentTileID: String, to nextTileID: String) -> Bool {
        guard let nextTileIDs = neighbors[currentTileID] else {
            return false
        }

        return nextTileIDs.contains(nextTileID)
    }
}
```

## ContentView.swift

```swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SceneKitPuzzleViewModel()

    var body: some View {
        VStack(spacing: 12) {
            SceneKitCubeView(viewModel: viewModel)
                .ignoresSafeArea()

            Text(viewModel.debugText)
                .font(.footnote.monospaced())
                .foregroundStyle(.secondary)
                .frame(minHeight: 32)
        }
    }
}
```

## GameScene.swift

```swift
import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    private let hudLayer = SKNode()
    private let tileLayer = SKNode()
    private let gameStore = GameStore()
    private var tileNodesByID: [String: SKShapeNode] = [:]
    private var hasSetUpPuzzleScene = false

    override func didMove(to view: SKView) {
        setUpPuzzleScene()
    }

    func setUpPuzzleScene() {
        guard hasSetUpPuzzleScene == false else {
            return
        }

        hasSetUpPuzzleScene = true
        backgroundColor = .systemGray6
        addChild(hudLayer)
        addChild(tileLayer)

        buildTitle()
        buildTwoByTwoBoard()
    }

    private func buildTitle() {
        let titleLabel = SKLabelNode(text: "Hello SpriteKit")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 34
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 120)

        hudLayer.addChild(titleLabel)
    }

    private func buildTwoByTwoBoard() {
        let tileSize = CGSize(width: 130, height: 130)
        let gap: CGFloat = 16
        let boardWidth = tileSize.width * 2 + gap
        let startX = size.width / 2 - boardWidth / 2 + tileSize.width / 2
        let startY = size.height / 2 - boardWidth / 2 + tileSize.height / 2

        for row in 0..<2 {
            for column in 0..<2 {
                let tileID = "tile_\(row)_\(column)"
                let tile = SKShapeNode(rectOf: tileSize, cornerRadius: 12)
                tile.name = tileID
                tile.fillColor = fillColor(for: tileID)
                tile.strokeColor = .black
                tile.lineWidth = 4
                tile.position = CGPoint(
                    x: startX + CGFloat(column) * (tileSize.width + gap),
                    y: startY + CGFloat(row) * (tileSize.height + gap)
                )

                tileNodesByID[tileID] = tile
                tileLayer.addChild(tile)
            }
        }
    }

    private func fillColor(for tileID: String) -> UIColor {
        if gameStore.currentTileID == tileID {
            return .systemBlue
        }

        if gameStore.visitedTileIDs.contains(tileID) {
            return .systemTeal
        }

        return .white
    }

    private func syncFromStore() {
        for (tileID, tileNode) in tileNodesByID {
            tileNode.fillColor = fillColor(for: tileID)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }

        let touchLocation = firstTouch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        for touchedNode in touchedNodes {
            guard let nodeName = touchedNode.name else {
                continue
            }

            if nodeName.hasPrefix("tile_") {
                if gameStore.selectTile(id: nodeName) {
                    syncFromStore()
                }

                return
            }
        }
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
```

## GameStore.swift

```swift
import Foundation

final class GameStore {
    private let board: BoardModel = .twoByTwo

    private(set) var currentTileID: String = "tile_0_0"
    private(set) var visitedTileIDs: Set<String> = ["tile_0_0"]
    private(set) var pathTileIDs: [String] = ["tile_0_0"]

    func canSelectTile(id tileID: String) -> Bool {
        if board.tileIDs.contains(tileID) == false {
            return false
        }

        if visitedTileIDs.contains(tileID) {
            return false
        }

        return board.isNeighbor(from: currentTileID, to: tileID)
    }

    func selectTile(id tileID: String) -> Bool {
        if canSelectTile(id: tileID) == false {
            return false
        }

        currentTileID = tileID
        visitedTileIDs.insert(tileID)
        pathTileIDs.append(tileID)
        return true
    }
}
```

## SceneKitCubeView.swift

```swift
import SceneKit
import SwiftUI
import UIKit

struct SceneKitCubeView: UIViewRepresentable {
    @ObservedObject var viewModel: SceneKitPuzzleViewModel

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = viewModel.scene
        sceneView.backgroundColor = .systemBackground

        let tapRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        sceneView.addGestureRecognizer(tapRecognizer)

        return sceneView
    }

    func updateUIView(_ sceneView: SCNView, context: Context) {
        sceneView.scene = viewModel.scene
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    final class Coordinator: NSObject {
        let viewModel: SceneKitPuzzleViewModel

        init(viewModel: SceneKitPuzzleViewModel) {
            self.viewModel = viewModel
        }

        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let sceneView = recognizer.view as? SCNView else {
                return
            }

            let point = recognizer.location(in: sceneView)
            viewModel.handleTap(at: point, in: sceneView)
        }
    }
}
```

## SceneKitPuzzleViewModel.swift

```swift
import Combine
import SceneKit
import SpriteKit
import UIKit

@MainActor
final class SceneKitPuzzleViewModel: ObservableObject {
    let scene = SCNScene()

    @Published private(set) var debugText = ""

    private let cameraNode = SCNNode()
    private let cubeNode = SCNNode()
    private let faceScene = GameScene(size: CGSize(width: 700, height: 900))

    init() {
        faceScene.setUpPuzzleScene()
        configureScene()
    }

    private func configureScene() {
        scene.background.contents = UIColor.systemBackground

        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)

        cubeNode.name = "interactiveCube"
        cubeNode.geometry = makeCubeGeometry()
        scene.rootNode.addChildNode(cubeNode)
    }

    private func makeCubeGeometry() -> SCNBox {
        let box = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0)

        let puzzleMaterial = SCNMaterial()
        puzzleMaterial.diffuse.contents = faceScene
        puzzleMaterial.lightingModel = .constant

        let plainMaterial = SCNMaterial()
        plainMaterial.diffuse.contents = UIColor.systemGray5

        box.materials = [
            plainMaterial,
            plainMaterial,
            puzzleMaterial,
            plainMaterial,
            plainMaterial,
            plainMaterial
        ]

        return box
    }

    func handleTap(at point: CGPoint, in sceneView: SCNView) {
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

        debugText = "터치한 cube material index: \(hitResult.geometryIndex)"
    }
}
```
