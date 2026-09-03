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

struct BoardPlan {
    let title: String
    let boardSize: Int
    let cubeFace: CubeFace
    let startTileID: TileID
    let goalTileID: TileID
    let blockedTileIDs: Set<TileID>
}

enum StageCatalog {
    static func makeStages() -> [BoardPlan] {
        let firstStage = BoardPlan(
            title: "1단계: 앞면 3x3",
            boardSize: 3,
            cubeFace: .front,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 2, column: 2),
            blockedTileIDs: []
        )

        return [
            firstStage
        ]
    }
}
