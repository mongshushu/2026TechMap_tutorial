final class GameStore {
    private let board: BoardModel = .twoByTwo

    private(set) var visitedTileIDs: Set<String> = ["tile_0_0"]
    private(set) var currentTileID: String = "tile_0_0"
    private(set) var pathTileIDs: [String] = ["tile_0_0"]

    func canSelectTile(id tileID: String) -> Bool {
        if board.tileIDs.contains(tileID) == false {
            return false
        }

        if visitedTileIDs.contains(tileID) {
            return false
        }

        return board.isNeighbor(from: currentTileID, to: tileID)
    }

    func selectTile(id tileID: String) -> Bool {
        if canSelectTile(id: tileID) == false {
            return false
        }

        visitedTileIDs.insert(tileID)
        currentTileID = tileID
        pathTileIDs.append(tileID)
        return true
    }

    func reset() {
        visitedTileIDs = ["tile_0_0"]
        currentTileID = "tile_0_0"
        pathTileIDs = ["tile_0_0"]
    }
}
