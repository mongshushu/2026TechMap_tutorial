import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SceneKitPuzzleViewModel()

    var body: some View {
        VStack(spacing: 14) {
            VStack(spacing: 4) {
                Text("Cube One-Stroke Puzzle")
                    .font(.title2.bold())

                Text(viewModel.stageTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)

            SceneKitCubeView(viewModel: viewModel)
                .aspectRatio(0.72, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Toggle(isOn: rotationModeBinding) {
                Label("회전 모드", systemImage: "rotate.left.and.right")
            }
            .toggleStyle(.switch)
            .padding(.horizontal, 4)

            HStack(spacing: 10) {
                Button {
                    viewModel.resetCurrentStage()
                } label: {
                    Label("다시", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)

                Button {
                    viewModel.undoLastStep()
                } label: {
                    Label("취소", systemImage: "arrow.uturn.backward")
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.canUndo == false || viewModel.isRotationModeEnabled)

                Button {
                    viewModel.goToNextStage()
                } label: {
                    Label("다음", systemImage: "chevron.right")
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.canAdvanceStage == false || viewModel.isRotationModeEnabled)
            }

            Text(viewModel.debugText)
                .font(.footnote.monospaced())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .padding(18)
        .background(Color(uiColor: .systemBackground))
    }

    private var rotationModeBinding: Binding<Bool> {
        Binding {
            viewModel.isRotationModeEnabled
        } set: { newValue in
            viewModel.setRotationModeEnabled(newValue)
        }
    }
}

#Preview {
    ContentView()
}
