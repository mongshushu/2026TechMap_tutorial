import Foundation

final class GameStore {
    private let board = BoardModel.twoByTwo

    private(set) var currentTileID = TileID(row: 0, column: 0)
    private(set) var visitedTileIDs: Set<TileID> = [TileID(row: 0, column: 0)]
    private(set) var pathTileIDs: [TileID] = [TileID(row: 0, column: 0)]

    func canSelectTile(id tileID: TileID) -> Bool {
        if board.tileIDs.contains(tileID) == false {
            return false
        }

        if visitedTileIDs.contains(tileID) {
            return false
        }

        return board.isNeighbor(from: currentTileID, to: tileID)
    }

    func selectTile(id tileID: TileID) -> Bool {
        if canSelectTile(id: tileID) == false {
            return false
        }

        currentTileID = tileID
        visitedTileIDs.insert(tileID)
        pathTileIDs.append(tileID)
        return true
    }
}
