canUndo = pathTileIDs.count > 1 && isStageComplete == false

Button {
    viewModel.undoLastStep()
} label: {
    Label("취소", systemImage: "arrow.uturn.backward")
}
.buttonStyle(.bordered)
.disabled(viewModel.canUndo == false || viewModel.isRotationModeEnabled)
