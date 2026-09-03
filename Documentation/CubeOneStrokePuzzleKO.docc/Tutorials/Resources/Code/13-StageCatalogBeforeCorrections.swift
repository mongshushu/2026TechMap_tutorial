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

        let secondStage = BoardPlan(
            title: "2단계: 오른쪽 면 3x3",
            boardSize: 3,
            cubeFace: .right,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 0, column: 2),
            blockedTileIDs: []
        )

        let thirdStage = BoardPlan(
            title: "3단계: 윗면 3x3",
            boardSize: 3,
            cubeFace: .top,
            startTileID: TileID(row: 0, column: 2),
            goalTileID: TileID(row: 2, column: 2),
            blockedTileIDs: []
        )

        return [
            firstStage,
            secondStage,
            thirdStage
        ]
    }
}
