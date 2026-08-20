private func moveBrush(to tileID: TileID, on face: CubeFace) {
    guard let position = brushPosition(for: tileID, on: face) else {
        brushNode.isHidden = true
        return
    }

    brushNode.position = position
    brushNode.isHidden = false
}
