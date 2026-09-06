import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SceneKitPuzzleViewModel()

    var body: some View {
        VStack(spacing: 12) {
            SceneKitCubeView(viewModel: viewModel)
                .ignoresSafeArea()

            Text(viewModel.debugText)
                .font(.footnote.monospaced())
                .foregroundStyle(.secondary)
                .frame(minHeight: 32)
        }
    }
}
