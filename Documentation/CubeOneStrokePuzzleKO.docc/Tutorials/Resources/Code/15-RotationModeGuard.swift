private var rotationModeBinding: Binding<Bool> {
    Binding {
        viewModel.isRotationModeEnabled
    } set: { newValue in
        viewModel.setRotationModeEnabled(newValue)
    }
}

Toggle(isOn: rotationModeBinding) {
    Label("회전 모드", systemImage: "rotate.left.and.right")
}
.toggleStyle(.switch)
