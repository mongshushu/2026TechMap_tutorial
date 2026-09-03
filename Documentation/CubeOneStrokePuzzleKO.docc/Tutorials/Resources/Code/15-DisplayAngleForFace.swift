private func displayAngle(for face: CubeFace) -> SCNVector3 {
    if face == .front {
        return SCNVector3(x: -0.24, y: -0.34, z: 0)
    }

    if face == .right {
        return SCNVector3(x: -0.24, y: -.pi / 2, z: 0)
    }

    if face == .top {
        return SCNVector3(x: .pi / 2, y: -0.34, z: 0)
    }

    return SCNVector3(x: -0.24, y: -0.34, z: 0)
}
