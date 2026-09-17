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
