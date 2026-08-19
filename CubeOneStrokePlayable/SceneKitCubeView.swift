import SceneKit
import SwiftUI

struct SceneKitCubeView: UIViewRepresentable {
    @ObservedObject var viewModel: SceneKitPuzzleViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()

        sceneView.scene = viewModel.scene
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = false
        sceneView.isPlaying = true

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        sceneView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan(_:))
        )
        sceneView.addGestureRecognizer(panGesture)

        return sceneView
    }

    func updateUIView(_ sceneView: SCNView, context: Context) {
        sceneView.scene = viewModel.scene
        context.coordinator.viewModel = viewModel
    }

    @MainActor
    final class Coordinator: NSObject {
        var viewModel: SceneKitPuzzleViewModel

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

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: recognizer.view)

            viewModel.handlePan(translation: translation)
            recognizer.setTranslation(.zero, in: recognizer.view)
        }
    }
}
