import Combine
import SceneKit
import UIKit

@MainActor
final class SceneKitPuzzleViewModel: ObservableObject {
    let scene = SCNScene()

    init() {
        configureScene()
    }

    private func configureScene() {
        scene.background.contents = UIColor.systemBackground
    }
}
