import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SceneKitPuzzleViewModel()

    var body: some View {
        SceneKitCubeView(viewModel: viewModel)
            .ignoresSafeArea()
    }
}
