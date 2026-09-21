import SceneKit
import SwiftUI

@MainActor
struct SceneKitPreview: View {
    @StateObject private var viewModel = SceneKitPuzzleViewModel()

    var body: some View {
        SceneView(scene: viewModel.scene, options: [])
            .background(Color(uiColor: .systemBackground))
    }
}

#Preview("SceneKit 장면") {
    SceneKitPreview()
}
