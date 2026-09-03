private func drawTileLabels(
    board: BoardPlan,
    in labelLayer: SKNode,
    tileSize: CGFloat,
    origin: CGPoint
) {
    for rawRow in 0..<board.boardSize {
        for rawColumn in 0..<board.boardSize {
            let tileID = board.tileID(forRawRow: rawRow, rawColumn: rawColumn)
            let label = SKLabelNode(text: "(\(tileID.row),\(tileID.column))")

            label.fontName = "HelveticaNeue-Bold"
            label.fontSize = tileSize * 0.13
            label.fontColor = .black
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = tileCenter(
                rawRow: rawRow,
                rawColumn: rawColumn,
                tileSize: tileSize,
                origin: origin
            )
            label.zPosition = 1
            labelLayer.addChild(label)
        }
    }
}
