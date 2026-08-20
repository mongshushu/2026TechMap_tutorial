func setRotationModeEnabled(_ enabled: Bool) {
    if isRotationModeEnabled == enabled {
        return
    }

    isRotationModeEnabled = enabled

    let targetScale: CGFloat = enabled ? 0.82 : 1.0
    let scaleAction = SCNAction.scale(to: targetScale, duration: 0.18)

    cubeNode.removeAction(forKey: "rotationModeScale")
    cubeNode.runAction(scaleAction, forKey: "rotationModeScale")

    if enabled {
        debugText = "회전 모드 ON: 드래그로 큐브를 돌려 다음 stage 면을 확인하세요."
    } else {
        debugText = "회전 모드 OFF: 현재 stage 면을 터치해 경로를 이어갑니다."
    }
}

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
