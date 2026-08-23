import Foundation

final class GameStore {
    private(set) var visitedTileIDs: Set<String> = ["tile_0_0"]
    private(set) var currentTileID: String = "tile_0_0"
    private(set) var pathTileIDs: [String] = ["tile_0_0"]

    func selectTile(id tileID: String) {
        visitedTileIDs.insert(tileID)
        currentTileID = tileID
        pathTileIDs.append(tileID)
    }

    func reset() {
        visitedTileIDs = ["tile_0_0"]
        currentTileID = "tile_0_0"
        pathTileIDs = ["tile_0_0"]
    }
}
