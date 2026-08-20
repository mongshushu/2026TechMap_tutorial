private func configureBrushNode() {
    let plane = SCNPlane(width: 0.18, height: 0.18)
    plane.firstMaterial?.diffuse.contents = UIImage(named: "BrushMarker")
    plane.firstMaterial?.isDoubleSided = true

    brushNode.geometry = plane
    brushNode.isHidden = true

    scene.rootNode.addChildNode(brushNode)
}
