import Foundation

struct BoardModel {
    let tileIDs: Set<String>

    static let twoByTwo = BoardModel(
        tileIDs: [
            "tile_0_0", "tile_0_1",
            "tile_1_0", "tile_1_1"
        ]
    )
}
