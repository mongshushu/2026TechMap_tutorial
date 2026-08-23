import SceneKit
import SwiftUI

struct SceneKitCubeView: UIViewRepresentable {
    let viewModel: SceneKitPuzzleViewModel

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
