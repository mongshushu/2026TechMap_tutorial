func undoLastStep() {
    if pathTileIDs.count <= 1 {
        debugText = "시작 칸은 취소할 수 없어요."
        return
    }

    let removedTileID = pathTileIDs.removeLast()
    currentTileID = pathTileIDs.last ?? currentBoard.startTileID
    isStageComplete = false
    renderBoards()
    debugText = "\(removedTileID.name)을 취소했어요. 현재 칸: \(currentTileID.name)"
}
