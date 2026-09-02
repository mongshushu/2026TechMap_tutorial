import Foundation

final class GameStore {
    private(set) var currentTileID: String = "tile_0_0"
    private(set) var visitedTileIDs: Set<String> = ["tile_0_0"]
    private(set) var pathTileIDs: [String] = ["tile_0_0"]
}
