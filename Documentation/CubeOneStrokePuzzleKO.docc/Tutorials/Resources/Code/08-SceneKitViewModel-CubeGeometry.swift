import Combine
import SceneKit
import UIKit

@MainActor
final class SceneKitPuzzleViewModel: ObservableObject {
    let scene = SCNScene()

    private let cameraNode = SCNNode()
    private let cubeNode = SCNNode()

    init() {
        configureScene()
    }

    private func configureScene() {
        scene.background.contents = UIColor.systemBackground

        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
    }

    private func makeCubeGeometry() -> SCNBox {
        let box = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0)

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGray5

        box.materials = [material]

        return box
    }
}
