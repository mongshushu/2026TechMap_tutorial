func position(on edge: TileEdge, boardSize: Int) -> Int? {
    if isOnEdge(edge, boardSize: boardSize) == false {
        return nil
    }

    if edge == .top || edge == .bottom {
        return column
    }

    return row
}

func tileID(at position: Int, boardSize: Int) -> TileID? {
    if position < 0 || position >= boardSize {
        return nil
    }

    if self == .top {
        return TileID(row: 0, column: position)
    } else if self == .right {
        return TileID(row: position, column: boardSize - 1)
    } else if self == .bottom {
        return TileID(row: boardSize - 1, column: position)
    } else {
        return TileID(row: position, column: 0)
    }
}
