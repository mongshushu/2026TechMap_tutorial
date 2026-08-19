import CoreGraphics

enum TileCoordinateLayout {
    case standard
    case flipColumns
    case flipRows
    case rotateClockwise
    case rotateCounterClockwise

    func tileID(forRawRow rawRow: Int, rawColumn: Int, boardSize: Int) -> TileID {
        switch self {
        case .standard:
            return TileID(row: rawRow, column: rawColumn)
        case .flipColumns:
            return TileID(row: rawRow, column: boardSize - 1 - rawColumn)
        case .flipRows:
            return TileID(row: boardSize - 1 - rawRow, column: rawColumn)
        case .rotateClockwise:
            return TileID(row: rawColumn, column: boardSize - 1 - rawRow)
        case .rotateCounterClockwise:
            return TileID(row: boardSize - 1 - rawColumn, column: rawRow)
        }
    }
}

enum LabelCorrection {
    case normal
    case mirrorX
    case mirrorY
    case mirrorXY

    var xScale: CGFloat {
        switch self {
        case .normal, .mirrorY:
            return 1
        case .mirrorX, .mirrorXY:
            return -1
        }
    }

    var yScale: CGFloat {
        switch self {
        case .normal, .mirrorX:
            return 1
        case .mirrorY, .mirrorXY:
            return -1
        }
    }
}

enum TileEdge {
    case top
    case right
    case bottom
    case left

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
}

struct BoardPlan {
    let title: String
    let boardSize: Int
    let cubeFace: CubeFace
    let coordinateLayout: TileCoordinateLayout
    let labelCorrection: LabelCorrection
    let startTileID: TileID
    let goalTileID: TileID
    let entryEdge: TileEdge?
    let exitEdge: TileEdge?
    let blockedTileIDs: Set<TileID>

    var playableTileCount: Int {
        var count = 0

        for row in 0..<boardSize {
            for column in 0..<boardSize {
                let tileID = TileID(row: row, column: column)

                if isPlayable(tileID) {
                    count += 1
                }
            }
        }

        return count
    }

    func contains(_ tileID: TileID) -> Bool {
        if tileID.row < 0 {
            return false
        }

        if tileID.column < 0 {
            return false
        }

        if tileID.row >= boardSize {
            return false
        }

        if tileID.column >= boardSize {
            return false
        }

        return true
    }

    func isPlayable(_ tileID: TileID) -> Bool {
        if contains(tileID) == false {
            return false
        }

        if blockedTileIDs.contains(tileID) {
            return false
        }

        return true
    }
}
