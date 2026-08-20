private func currentStageSharesEdgeWithNextStage() -> Bool {
    if stageIndex + 1 >= stages.count {
        return false
    }

    let currentStage = stages[stageIndex]
    let nextStage = stages[stageIndex + 1]

    guard let exitEdge = currentStage.exitEdge,
          let entryEdge = nextStage.entryEdge,
          let lastTileID = pathTileIDs.last,
          let expectedStartTileID = matchingStartTileID(
            from: lastTileID,
            exitEdge: exitEdge,
            currentStage: currentStage,
            nextStage: nextStage,
            entryEdge: entryEdge
          ) else {
        return false
    }

    return nextStage.startTileID == expectedStartTileID
}

private func matchingStartTileID(
    from lastTileID: TileID,
    exitEdge: TileEdge,
    currentStage: BoardPlan,
    nextStage: BoardPlan,
    entryEdge: TileEdge
) -> TileID? {
    if currentStage.boardSize != nextStage.boardSize {
        return nil
    }

    guard let position = lastTileID.position(
        on: exitEdge,
        boardSize: currentStage.boardSize
    ) else {
        return nil
    }

    let nextPosition = currentStage.boardSize - 1 - position

    if currentStage.cubeFace == .front &&
        exitEdge == .right &&
        nextStage.cubeFace == .right &&
        entryEdge == .left {
        return entryEdge.tileID(at: nextPosition, boardSize: nextStage.boardSize)
    }

    if currentStage.cubeFace == .right &&
        exitEdge == .top &&
        nextStage.cubeFace == .top &&
        entryEdge == .right {
        return entryEdge.tileID(at: nextPosition, boardSize: nextStage.boardSize)
    }

    return nil
}

canAdvanceStage = isStageComplete && currentStageSharesEdgeWithNextStage()
