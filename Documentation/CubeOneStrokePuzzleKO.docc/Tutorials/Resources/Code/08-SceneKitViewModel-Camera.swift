import Combine
import SceneKit
import UIKit

@MainActor
final class SceneKitPuzzleViewModel: ObservableObject {
    let scene = SCNScene()

    private let cameraNode = SCNNode()

    init() {
        configureScene()
    }

    private func configureScene() {
        scene.background.contents = UIColor.systemBackground

        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
    }
}
