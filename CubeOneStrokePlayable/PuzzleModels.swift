import CoreGraphics
import Foundation

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

    func tileID(forRawRow rawRow: Int, rawColumn: Int) -> TileID {
        coordinateLayout.tileID(
            forRawRow: rawRow,
            rawColumn: rawColumn,
            boardSize: boardSize
        )
    }

    func tileID(fromTextureCoordinate textureCoordinate: CGPoint) -> TileID? {
        let safeX = min(max(textureCoordinate.x, CGFloat(0)), CGFloat(0.999))
        let safeY = min(max(textureCoordinate.y, CGFloat(0)), CGFloat(0.999))
        let rawColumn = Int(safeX * CGFloat(boardSize))
        let rawRow = Int(safeY * CGFloat(boardSize))
        let tileID = tileID(forRawRow: rawRow, rawColumn: rawColumn)

        if contains(tileID) {
            return tileID
        }

        return nil
    }
}

enum StageCatalog {
    static func makeStages() -> [BoardPlan] {
        let firstStage = BoardPlan(
            title: "1단계: 앞면 3x3에서 오른쪽 모서리로",
            boardSize: 3,
            cubeFace: .front,
            coordinateLayout: .standard,
            labelCorrection: .normal,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 2, column: 2),
            entryEdge: nil,
            exitEdge: .right,
            blockedTileIDs: []
        )

        let secondStage = BoardPlan(
            title: "2단계: 오른쪽 면 3x3에서 윗면 모서리로",
            boardSize: 3,
            cubeFace: .right,
            coordinateLayout: .flipColumns,
            labelCorrection: .mirrorX,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 0, column: 2),
            entryEdge: .left,
            exitEdge: .top,
            blockedTileIDs: []
        )

        let thirdStage = BoardPlan(
            title: "3단계: 윗면 3x3 확장판",
            boardSize: 3,
            cubeFace: .top,
            coordinateLayout: .flipRows,
            labelCorrection: .mirrorY,
            startTileID: TileID(row: 0, column: 2),
            goalTileID: TileID(row: 2, column: 2),
            entryEdge: .right,
            exitEdge: nil,
            blockedTileIDs: []
        )

        return [
            firstStage,
            secondStage,
            thirdStage
        ]
    }
}
