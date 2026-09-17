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

    let rowGap = abs(currentTileID.row - tileID.row)
    let columnGap = abs(currentTileID.column - tileID.column)

    if rowGap + columnGap != 1 {
        debugText = "현재 tile에서 한 칸 이동할 수 없는 위치입니다."
        return
    }
}
