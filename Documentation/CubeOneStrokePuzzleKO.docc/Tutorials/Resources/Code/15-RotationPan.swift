if viewModel.isRotationModeEnabled == false {
    return
}

let translation = recognizer.translation(in: sceneView)
viewModel.rotateCubeByDrag(translation: translation)
recognizer.setTranslation(.zero, in: sceneView)
