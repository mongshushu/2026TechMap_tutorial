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
    private let faceScene = GameScene(size: CGSize(width: 700, height: 700))

    init() {
        faceScene.setUpPuzzleScene()
        configureScene()
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

        let puzzleMaterial = SCNMaterial()
        puzzleMaterial.diffuse.contents = faceScene
        puzzleMaterial.lightingModel = .constant

        let plainMaterial = SCNMaterial()
        plainMaterial.diffuse.contents = UIColor.systemGray5

        box.materials = [
            puzzleMaterial,
            plainMaterial,
            plainMaterial,
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

        let textureCoordinate = hitResult.textureCoordinates(withMappingChannel: 0)
        let boardPosition = boardPosition(from: textureCoordinate)

        debugText = "board 위치 row: \(boardPosition.row), column: \(boardPosition.column)"
    }

    private func boardPosition(from textureCoordinate: CGPoint) -> (row: Int, column: Int) {
        let boardSize = 2
        let column = min(
            max(Int(textureCoordinate.x * CGFloat(boardSize)), 0),
            boardSize - 1
        )
        let row = min(
            max(Int(textureCoordinate.y * CGFloat(boardSize)), 0),
            boardSize - 1
        )

        return (row, column)
    }
}
