private let brushNode = SCNNode()

private func configureBrushNode() {
    let plane = SCNPlane(width: 0.18, height: 0.18)
    plane.firstMaterial?.diffuse.contents = UIImage(named: "BrushMarker")
    plane.firstMaterial?.isDoubleSided = true

    brushNode.geometry = plane
    brushNode.isHidden = true

    let billboard = SCNBillboardConstraint()
    brushNode.constraints = [billboard]

    scene.rootNode.addChildNode(brushNode)
}

private func moveBrush(to tileID: TileID, on face: CubeFace) {
    guard let position = brushPosition(for: tileID, on: face) else {
        brushNode.isHidden = true
        return
    }

    brushNode.position = position
    brushNode.isHidden = false
}

let didSelectTile = gameStore.selectTile(id: tileID)

if didSelectTile {
    moveBrush(to: tileID, on: currentBoard.cubeFace)
}
