let didSelectTile = gameStore.selectTile(id: tileID)

if didSelectTile {
    moveBrush(to: tileID, on: currentBoard.cubeFace)
}
