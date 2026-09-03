struct TileID: Hashable, CustomStringConvertible {
    let row: Int
    let column: Int

    var name: String {
        "tile_\(row)_\(column)"
    }

    var description: String {
        name
    }

    func isOnEdge(_ edge: TileEdge, boardSize: Int) -> Bool {
        if edge == .top {
            return row == 0
        } else if edge == .right {
            return column == boardSize - 1
        } else if edge == .bottom {
            return row == boardSize - 1
        } else {
            return column == 0
        }
    }

    func position(on edge: TileEdge, boardSize: Int) -> Int? {
        if isOnEdge(edge, boardSize: boardSize) == false {
            return nil
        }

        if edge == .top || edge == .bottom {
            return column
        }

        return row
    }
}
