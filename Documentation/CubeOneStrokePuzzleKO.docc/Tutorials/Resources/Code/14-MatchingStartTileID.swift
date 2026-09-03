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
