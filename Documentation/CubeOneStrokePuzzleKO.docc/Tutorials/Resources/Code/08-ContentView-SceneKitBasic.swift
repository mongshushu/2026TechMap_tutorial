import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SceneKitPuzzleViewModel()
    @State private var isRotationEnabled = false

    var body: some View {
        VStack(spacing: 12) {
            Toggle("큐브 회전", isOn: $isRotationEnabled)

            SceneKitCubeView(
                viewModel: viewModel,
                isRotationEnabled: isRotationEnabled
            )
                .ignoresSafeArea()
        }
    }
}
