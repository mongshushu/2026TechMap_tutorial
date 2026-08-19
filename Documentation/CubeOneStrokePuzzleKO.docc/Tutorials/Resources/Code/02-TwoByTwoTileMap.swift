private func boardMetrics(for board: BoardPlan) -> (tileSize: CGFloat, origin: CGPoint) {
    let shortSide = min(size.width, size.height)
    let boardSide = shortSide
    let tileSize = boardSide / CGFloat(board.boardSize)
    let originX = (size.width - boardSide) / 2
    let originY = (size.height - boardSide) / 2

    return (
        tileSize: tileSize,
        origin: CGPoint(x: originX, y: originY)
    )
}

private func drawTileMap(
    board: BoardPlan,
    visitedTileIDs: Set<TileID>,
    currentTileID: TileID?,
    mode: BoardRenderMode,
    in tileLayer: SKNode,
    tileSize: CGFloat,
    origin: CGPoint,
    tileGroups: TileGroups
) {
    let tileMap = SKTileMapNode(
        tileSet: tileGroups.tileSet,
        columns: board.boardSize,
        rows: board.boardSize,
        tileSize: CGSize(width: tileSize, height: tileSize)
    )

    tileMap.name = "puzzleTileMapNode"
    tileMap.anchorPoint = CGPoint(x: 0, y: 0)
    tileMap.position = origin
    tileMap.enableAutomapping = false

    for rawRow in 0..<board.boardSize {
        for rawColumn in 0..<board.boardSize {
            let tileID = board.tileID(forRawRow: rawRow, rawColumn: rawColumn)
            let tileGroup = tileGroup(
                for: tileID,
                board: board,
                visitedTileIDs: visitedTileIDs,
                currentTileID: currentTileID,
                mode: mode,
                tileGroups: tileGroups
            )

            tileMap.setTileGroup(tileGroup, forColumn: rawColumn, row: rawRow)
        }
    }

    tileLayer.addChild(tileMap)
}

private func drawTileLabels(
    board: BoardPlan,
    in labelLayer: SKNode,
    tileSize: CGFloat,
    origin: CGPoint,
    currentTileID: TileID?,
    mode: BoardRenderMode
) {
    for rawRow in 0..<board.boardSize {
        for rawColumn in 0..<board.boardSize {
            let tileID = board.tileID(forRawRow: rawRow, rawColumn: rawColumn)
            let label = SKLabelNode(text: "(\(tileID.row),\(tileID.column))")

            label.fontName = "HelveticaNeue-Bold"
            label.fontSize = tileSize * 0.13
            label.fontColor = labelColor(
                for: tileID,
                board: board,
                currentTileID: currentTileID,
                mode: mode
            )
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = tileCenter(
                rawRow: rawRow,
                rawColumn: rawColumn,
                tileSize: tileSize,
                origin: origin
            )
            label.xScale = board.labelCorrection.xScale
            label.yScale = board.labelCorrection.yScale
            label.zPosition = 1
            labelLayer.addChild(label)
        }
    }
}

private func tileCenter(
    rawRow: Int,
    rawColumn: Int,
    tileSize: CGFloat,
    origin: CGPoint
) -> CGPoint {
    let x = origin.x + CGFloat(rawColumn) * tileSize + tileSize / 2
    let y = origin.y + CGFloat(rawRow) * tileSize + tileSize / 2

    return CGPoint(x: x, y: y)
}

private func tileGroup(
    for tileID: TileID,
    board: BoardPlan,
    visitedTileIDs: Set<TileID>,
    currentTileID: TileID?,
    mode: BoardRenderMode,
    tileGroups: TileGroups
) -> SKTileGroup {
    if mode == .completed {
        return tileGroups.completed
    }

    if board.isPlayable(tileID) == false {
        return tileGroups.blocked
    }

    if mode == .future {
        return tileGroups.empty
    }

    if tileID == currentTileID {
        return tileGroups.current
    }

    if visitedTileIDs.contains(tileID) {
        return tileGroups.visited
    }

    return tileGroups.empty
}

private func labelColor(
    for tileID: TileID,
    board: BoardPlan,
    currentTileID: TileID?,
    mode: BoardRenderMode
) -> UIColor {
    if mode == .completed {
        return .black
    }

    if mode == .active && tileID == currentTileID {
        return .white
    }

    if board.isPlayable(tileID) == false {
        return .darkGray
    }

    return .black
}
