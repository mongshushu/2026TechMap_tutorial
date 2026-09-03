import Foundation

struct BoardModel {
    let tileIDs: Set<String>
    let neighbors: [String: Set<String>]

    static let twoByTwo = BoardModel(
        tileIDs: [
            "tile_0_0", "tile_0_1",
            "tile_1_0", "tile_1_1"
        ],
        neighbors: [
            "tile_0_0": ["tile_0_1", "tile_1_0"],
            "tile_0_1": ["tile_0_0", "tile_1_1"],
            "tile_1_0": ["tile_0_0", "tile_1_1"],
            "tile_1_1": ["tile_0_1", "tile_1_0"]
        ]
    )

    func isNeighbor(from currentTileID: String, to nextTileID: String) -> Bool {
        guard let nextTileIDs = neighbors[currentTileID] else {
            return false
        }

        return nextTileIDs.contains(nextTileID)
    }
}
