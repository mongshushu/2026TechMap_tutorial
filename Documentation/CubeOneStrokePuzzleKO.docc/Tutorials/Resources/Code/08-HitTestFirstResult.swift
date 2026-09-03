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

        debugText = "hit node: \(hitResult.node.name ?? "이름 없음")"
    }
}
