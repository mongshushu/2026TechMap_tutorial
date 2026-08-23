private var tileNodesByID: [String: SKShapeNode] = [:]

private func buildTwoByTwoBoard() {
    let tileSize = CGSize(width: 130, height: 130)
    let gap: CGFloat = 16
    let boardWidth = tileSize.width * 2 + gap
    let startX = size.width / 2 - boardWidth / 2 + tileSize.width / 2
    let startY = size.height / 2 - boardWidth / 2 + tileSize.height / 2

    for row in 0..<2 {
        for column in 0..<2 {
            let tileID = "tile_\(row)_\(column)"
            let tile = SKShapeNode(rectOf: tileSize, cornerRadius: 12)
            tile.name = tileID
            tile.fillColor = tileID == "tile_0_0" ? .systemBlue : .white
            tile.strokeColor = .black
            tile.lineWidth = 4
            tile.position = CGPoint(
                x: startX + CGFloat(column) * (tileSize.width + gap),
                y: startY + CGFloat(row) * (tileSize.height + gap)
            )

            tileNodesByID[tileID] = tile
            tileLayer.addChild(tile)
        }
    }
}
