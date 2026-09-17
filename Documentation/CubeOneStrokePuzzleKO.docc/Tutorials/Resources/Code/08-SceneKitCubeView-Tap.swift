import SceneKit
import SwiftUI
import UIKit

struct SceneKitCubeView: UIViewRepresentable {
    @ObservedObject var viewModel: SceneKitPuzzleViewModel
    var isRotationEnabled: Bool

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = viewModel.scene
        sceneView.backgroundColor = .systemBackground
        sceneView.allowsCameraControl = isRotationEnabled

        let tapRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        tapRecognizer.isEnabled = !isRotationEnabled
        sceneView.addGestureRecognizer(tapRecognizer)
        context.coordinator.tapRecognizer = tapRecognizer

        return sceneView
    }

    func updateUIView(_ sceneView: SCNView, context: Context) {
        sceneView.scene = viewModel.scene
        sceneView.allowsCameraControl = isRotationEnabled
        context.coordinator.tapRecognizer?.isEnabled = !isRotationEnabled
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    final class Coordinator: NSObject {
        let viewModel: SceneKitPuzzleViewModel
        var tapRecognizer: UITapGestureRecognizer?

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
