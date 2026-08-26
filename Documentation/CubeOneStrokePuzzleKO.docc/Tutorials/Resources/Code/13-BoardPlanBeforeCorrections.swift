struct BoardPlan {
    let title: String
    let boardSize: Int
    let cubeFace: CubeFace
    let startTileID: TileID
    let goalTileID: TileID
    let blockedTileIDs: Set<TileID>
}
