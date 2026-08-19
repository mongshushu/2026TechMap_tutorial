enum StageCatalog {
    static func makeStages() -> [BoardPlan] {
        let firstStage = BoardPlan(
            title: "1단계: 앞면 3x3에서 오른쪽 모서리로",
            boardSize: 3,
            cubeFace: .front,
            coordinateLayout: .standard,
            labelCorrection: .normal,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 2, column: 2),
            entryEdge: nil,
            exitEdge: .right,
            blockedTileIDs: []
        )

        let secondStage = BoardPlan(
            title: "2단계: 오른쪽 면 3x3에서 윗면 모서리로",
            boardSize: 3,
            cubeFace: .right,
            coordinateLayout: .flipColumns,
            labelCorrection: .mirrorX,
            startTileID: TileID(row: 0, column: 0),
            goalTileID: TileID(row: 0, column: 2),
            entryEdge: .left,
            exitEdge: .top,
            blockedTileIDs: []
        )

        let thirdStage = BoardPlan(
            title: "3단계: 윗면 3x3 확장판",
            boardSize: 3,
            cubeFace: .top,
            coordinateLayout: .flipRows,
            labelCorrection: .mirrorY,
            startTileID: TileID(row: 0, column: 2),
            goalTileID: TileID(row: 2, column: 2),
            entryEdge: .right,
            exitEdge: nil,
            blockedTileIDs: []
        )

        return [
            firstStage,
            secondStage,
            thirdStage
        ]
    }
}
