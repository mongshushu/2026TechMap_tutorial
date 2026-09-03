import SceneKit
import SwiftUI
import UIKit

struct SceneKitCubeView: UIViewRepresentable {
    @ObservedObject var viewModel: SceneKitPuzzleViewModel

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = viewModel.scene
        sceneView.backgroundColor = .systemBackground

        return sceneView
    }

    func updateUIView(_ sceneView: SCNView, context: Context) {
        sceneView.scene = viewModel.scene
    }
}
