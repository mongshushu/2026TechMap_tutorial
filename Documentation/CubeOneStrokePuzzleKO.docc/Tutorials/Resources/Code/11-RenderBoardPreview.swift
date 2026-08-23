func show(
    board: BoardPlan,
    pathTileIDs: [TileID],
    currentTileID: TileID?
) {
    removeAllChildren()

    let tileLayer = SKNode()
    let labelLayer = SKNode()
    tileLayer.zPosition = 0
    labelLayer.zPosition = 1

    addChild(tileLayer)
    addChild(labelLayer)

    let tileSize = min(size.width, size.height) / CGFloat(board.boardSize)

    for row in 0..<board.boardSize {
        for column in 0..<board.boardSize {
            let tileID = TileID(row: row, column: column)
            let tile = SKShapeNode(
                rectOf: CGSize(width: tileSize, height: tileSize)
            )
            tile.position = CGPoint(
                x: CGFloat(column) * tileSize + tileSize / 2,
                y: CGFloat(row) * tileSize + tileSize / 2
            )

            tileLayer.addChild(tile)

            let label = SKLabelNode(text: "(\(row),\(column))")
            label.position = tile.position
            labelLayer.addChild(label)
        }
    }
}
