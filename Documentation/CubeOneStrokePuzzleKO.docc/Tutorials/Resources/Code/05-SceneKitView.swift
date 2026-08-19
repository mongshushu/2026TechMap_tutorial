SceneKitCubeView(viewModel: viewModel)
    .aspectRatio(0.72, contentMode: .fit)
    .frame(maxWidth: .infinity)
    .background(Color(uiColor: .secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 8))

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
