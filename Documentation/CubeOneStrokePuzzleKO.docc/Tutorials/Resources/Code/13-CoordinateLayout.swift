enum TileCoordinateLayout {
    case standard
    case flipColumns
    case flipRows

    func tileID(forRawRow rawRow: Int, rawColumn: Int, boardSize: Int) -> TileID {
        if self == .flipColumns {
            return TileID(row: rawRow, column: boardSize - 1 - rawColumn)
        }

        if self == .flipRows {
            return TileID(row: boardSize - 1 - rawRow, column: rawColumn)
        }

        return TileID(row: rawRow, column: rawColumn)
    }
}
