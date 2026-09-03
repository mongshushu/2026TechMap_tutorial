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
}

enum CubeFace: Int, CaseIterable {
    case front = 0
    case right = 1
    case back = 2
    case left = 3
    case top = 4
    case bottom = 5
}

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

enum LabelCorrection {
    case normal
    case mirrorX
    case mirrorY

    var xScale: CGFloat {
        if self == .mirrorX {
            return -1
        }

        return 1
    }

    var yScale: CGFloat {
        if self == .mirrorY {
            return -1
        }

        return 1
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
    let blockedTileIDs: Set<TileID>

    func tileID(forRawRow rawRow: Int, rawColumn: Int) -> TileID {
        coordinateLayout.tileID(
            forRawRow: rawRow,
            rawColumn: rawColumn,
            boardSize: boardSize
        )
    }
}
