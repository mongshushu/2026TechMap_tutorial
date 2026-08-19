func isNeighbor(from currentTileID: TileID, to nextTileID: TileID) -> Bool {
    let rowGap = abs(currentTileID.row - nextTileID.row)
    let columnGap = abs(currentTileID.column - nextTileID.column)

    if rowGap == 1 && columnGap == 0 {
        return true
    }

    if rowGap == 0 && columnGap == 1 {
        return true
    }

    return false
}
