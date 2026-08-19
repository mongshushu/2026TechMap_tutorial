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

enum CubeFace: Int, CaseIterable, Hashable, CustomStringConvertible {
    case front = 0
    case right = 1
    case back = 2
    case left = 3
    case top = 4
    case bottom = 5

    var description: String {
        switch self {
        case .front:
            return "front"
        case .right:
            return "right"
        case .back:
            return "back"
        case .left:
            return "left"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        }
    }

    var koreanName: String {
        switch self {
        case .front:
            return "앞면"
        case .right:
            return "오른쪽 면"
        case .back:
            return "뒷면"
        case .left:
            return "왼쪽 면"
        case .top:
            return "윗면"
        case .bottom:
            return "아랫면"
        }
    }
}
