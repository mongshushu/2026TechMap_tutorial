private var currentTileID = TileID(row: 0, column: 0)
private var pathTileIDs: [TileID] = [currentTileID]
private var isStageComplete = false

private func selectTile(_ tileID: TileID, textureCoordinate: CGPoint) {
    if isStageComplete {
        debugText = "이 퍼즐은 완료했어요."
        return
    }

    let visitedTileIDs = Set(pathTileIDs)

    if visitedTileIDs.contains(tileID) {
        debugText = "이미 지나온 tile입니다."
        return
    }
}
