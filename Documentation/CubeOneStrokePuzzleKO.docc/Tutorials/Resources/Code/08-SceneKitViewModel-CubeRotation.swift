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
        cameraNode.position = SCNVector3(x: 2.0, y: 1.4, z: 5.5)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
        scene.rootNode.addChildNode(cameraNode)

        cubeNode.geometry = makeCubeGeometry()
        cubeNode.eulerAngles = SCNVector3(x: -0.12, y: 0.16, z: 0)
        scene.rootNode.addChildNode(cubeNode)
    }

    private func makeCubeGeometry() -> SCNBox {
        let box = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0)

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGray5

        box.materials = [material]

        return box
    }
}
