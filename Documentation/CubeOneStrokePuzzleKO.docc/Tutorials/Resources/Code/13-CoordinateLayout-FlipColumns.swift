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

    func tileID(forRawRow rawRow: Int, rawColumn: Int, boardSize: Int) -> TileID {
        if self == .flipColumns {
            return TileID(row: rawRow, column: boardSize - 1 - rawColumn)
        }

        return TileID(row: rawRow, column: rawColumn)
    }
}

struct BoardPlan {
    let title: String
    let boardSize: Int
    let cubeFace: CubeFace
    let startTileID: TileID
    let goalTileID: TileID
    let blockedTileIDs: Set<TileID>
}
