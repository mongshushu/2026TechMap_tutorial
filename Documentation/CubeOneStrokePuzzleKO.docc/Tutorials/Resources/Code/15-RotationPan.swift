if isRotationModeEnabled == false {
    return
}

let xRotation = Float(translation.y) * 0.008
let yRotation = Float(translation.x) * 0.008

cubeNode.eulerAngles.x += xRotation
cubeNode.eulerAngles.y += yRotation
