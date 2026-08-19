private func selectTile(_ tileID: TileID, textureCoordinate: CGPoint) {
    if isStageComplete {
        debugText = "이 퍼즐은 완료했어요. 다음 버튼으로 넘어가세요."
        return
    }

    let board = currentBoard
    let visitedTileIDs = Set(pathTileIDs)

    if board.isPlayable(tileID) == false {
        debugText = "\(tileID.name)은 지나갈 수 없는 칸입니다."
        return
    }

    if tileID == currentTileID {
        debugText = "\(tileID.name)은 이미 현재 칸입니다."
        return
    }

if visitedTileIDs.contains(tileID) {
        debugText = "\(tileID.name)은 이미 지나온 칸입니다."
        return
}

if board.isNeighbor(from: currentTileID, to: tileID) == false {
        debugText = "\(currentTileID.name)에서 \(tileID.name)으로는 바로 이동할 수 없어요."
        return
}

    currentTileID = tileID
    pathTileIDs.append(tileID)

    if pathTileIDs.count == board.playableTileCount && tileID == board.goalTileID {
        isStageComplete = true
    }

    renderBoards()
}
