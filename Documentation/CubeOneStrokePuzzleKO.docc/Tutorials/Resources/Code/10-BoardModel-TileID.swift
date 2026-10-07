import Foundation

struct BoardModel {
    let tileIDs: Set<TileID>
    let neighbors: [TileID: Set<TileID>]

    static let twoByTwo = BoardModel(
        tileIDs: [
            TileID(row: 0, column: 0),
            TileID(row: 0, column: 1),
            TileID(row: 1, column: 0),
            TileID(row: 1, column: 1)
        ],
        neighbors: [
            TileID(row: 0, column: 0): [
                TileID(row: 0, column: 1),
                TileID(row: 1, column: 0)
            ],
            TileID(row: 0, column: 1): [
                TileID(row: 0, column: 0),
                TileID(row: 1, column: 1)
            ],
            TileID(row: 1, column: 0): [
                TileID(row: 0, column: 0),
                TileID(row: 1, column: 1)
            ],
            TileID(row: 1, column: 1): [
                TileID(row: 0, column: 1),
                TileID(row: 1, column: 0)
            ]
        ]
    )

    func isNeighbor(from currentTileID: TileID, to nextTileID: TileID) -> Bool {
        neighbors[currentTileID]?.contains(nextTileID) == true
    }
}
