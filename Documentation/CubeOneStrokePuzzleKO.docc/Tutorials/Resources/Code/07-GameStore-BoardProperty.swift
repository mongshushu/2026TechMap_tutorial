import Foundation

final class GameStore {
    private let board: BoardModel = .twoByTwo

    private(set) var currentTileID: String = "tile_0_0"
    private(set) var visitedTileIDs: Set<String> = ["tile_0_0"]
    private(set) var pathTileIDs: [String] = ["tile_0_0"]

    func selectTile(id tileID: String) {
        currentTileID = tileID
        visitedTileIDs.insert(tileID)
        pathTileIDs.append(tileID)
    }
}
