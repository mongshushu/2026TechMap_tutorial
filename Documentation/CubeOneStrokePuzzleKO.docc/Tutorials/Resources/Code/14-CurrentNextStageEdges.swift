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

    return true
}
