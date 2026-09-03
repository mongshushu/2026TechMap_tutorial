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

private func rotateCube(to face: CubeFace) {
    let angle = displayAngle(for: face)
    let action = SCNAction.rotateTo(
        x: CGFloat(angle.x),
        y: CGFloat(angle.y),
        z: CGFloat(angle.z),
        duration: 0.35,
        usesShortestUnitArc: true
    )

    cubeNode.removeAction(forKey: "stageTurn")
    cubeNode.runAction(action, forKey: "stageTurn")
}
