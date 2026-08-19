func tileID(fromTextureCoordinate textureCoordinate: CGPoint) -> TileID? {
    let safeX = min(max(textureCoordinate.x, CGFloat(0)), CGFloat(0.999))
    let safeY = min(max(textureCoordinate.y, CGFloat(0)), CGFloat(0.999))
    let rawColumn = Int(safeX * CGFloat(boardSize))
    let rawRow = Int(safeY * CGFloat(boardSize))
    let tileID = tileID(forRawRow: rawRow, rawColumn: rawColumn)

    if contains(tileID) {
        return tileID
    }

    return nil
}
