struct BoardPlan {
    let title: String
    let boardSize: Int
    let cubeFace: CubeFace
    let coordinateLayout: TileCoordinateLayout
    let labelCorrection: LabelCorrection
    let startTileID: TileID
    let goalTileID: TileID
    let blockedTileIDs: Set<TileID>

    func tileID(forRawRow rawRow: Int, rawColumn: Int) -> TileID {
        coordinateLayout.tileID(
            forRawRow: rawRow,
            rawColumn: rawColumn,
            boardSize: boardSize
        )
    }
}
