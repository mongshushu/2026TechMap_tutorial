private func makeCubeGeometry() -> SCNBox {
    let box = SCNBox(width: 2.3, height: 2.3, length: 2.3, chamferRadius: 0)

    box.materials = CubeFace.allCases.map { face in
        material(for: face)
    }

    return box
}

private func material(for face: CubeFace) -> SCNMaterial {
    let material = SCNMaterial()

    material.name = "\(face.description)Face"
    material.diffuse.contents = faceScenes[face]
    material.lightingModel = .constant
    material.isDoubleSided = false

    return material
}
