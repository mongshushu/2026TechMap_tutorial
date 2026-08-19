enum BoardRenderMode {
    case active
    case completed
    case future
}

func show(
    board: BoardPlan,
    pathTileIDs: [TileID],
    currentTileID: TileID?,
    mode: BoardRenderMode
) {
    removeAllChildren()

    let tileLayer = SKNode()
    let labelLayer = SKNode()

    tileLayer.name = "tileLayer"
    labelLayer.name = "labelLayer"
    tileLayer.zPosition = 0
    labelLayer.zPosition = 1

    addChild(tileLayer)
    addChild(labelLayer)

    let metrics = boardMetrics(for: board)
    let visitedTileIDs = Set(pathTileIDs)
    let tileGroups = makeTileGroups(tileSize: metrics.tileSize)

    drawTileMap(
        board: board,
        visitedTileIDs: visitedTileIDs,
        currentTileID: currentTileID,
        mode: mode,
        in: tileLayer,
        tileSize: metrics.tileSize,
        origin: metrics.origin,
        tileGroups: tileGroups
    )
    drawTileLabels(
        board: board,
        in: labelLayer,
        tileSize: metrics.tileSize,
        origin: metrics.origin,
        currentTileID: currentTileID,
        mode: mode
    )
}
