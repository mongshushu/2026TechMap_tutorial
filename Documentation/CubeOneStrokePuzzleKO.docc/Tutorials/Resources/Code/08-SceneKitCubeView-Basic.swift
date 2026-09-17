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

        return sceneView
    }

    func updateUIView(_ sceneView: SCNView, context: Context) {
        sceneView.scene = viewModel.scene
        sceneView.allowsCameraControl = isRotationEnabled
    }
}
