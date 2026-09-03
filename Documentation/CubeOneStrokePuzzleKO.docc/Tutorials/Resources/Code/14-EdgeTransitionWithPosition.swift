private func currentStageSharesEdgeWithNextStage() -> Bool {
    if stageIndex + 1 >= stages.count {
        return false
    }

    let currentStage = stages[stageIndex]
    let nextStage = stages[stageIndex + 1]

    guard let exitEdge = currentStage.exitEdge,
          let entryEdge = nextStage.entryEdge else {
        return false
    }

    guard let lastTileID = pathTileIDs.last,
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
