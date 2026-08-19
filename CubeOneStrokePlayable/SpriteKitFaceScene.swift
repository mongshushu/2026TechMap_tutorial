import SpriteKit
import UIKit

enum BoardRenderMode {
    case active
    case completed
    case future
}

final class SpriteKitFaceScene: SKScene {
    private struct TileGroups {
        let empty: SKTileGroup
        let blocked: SKTileGroup
        let visited: SKTileGroup
        let current: SKTileGroup
        let completed: SKTileGroup

        var tileSet: SKTileSet {
            SKTileSet(tileGroups: [
                empty,
                blocked,
                visited,
                current,
                completed
            ])
        }
    }

    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        scaleMode = .resizeFill
        backgroundColor = .clear
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

    private func makeTileGroups(tileSize: CGFloat) -> TileGroups {
        TileGroups(
            empty: makeTileGroup(name: "empty", color: .white, tileSize: tileSize),
            blocked: makeTileGroup(name: "blocked", color: .systemGray2, tileSize: tileSize),
            visited: makeTileGroup(name: "visited", color: .systemTeal, tileSize: tileSize),
            current: makeTileGroup(name: "current", color: .blue, tileSize: tileSize),
            completed: makeTileGroup(name: "completed", color: .systemTeal, tileSize: tileSize)
        )
    }

    private func makeTileGroup(name: String, color: UIColor, tileSize: CGFloat) -> SKTileGroup {
        let image = tileImage(color: color, tileSize: tileSize)
        let texture = SKTexture(image: image)

        texture.filteringMode = .nearest

        let definition = SKTileDefinition(texture: texture, size: image.size)
        let group = SKTileGroup(tileDefinition: definition)

        group.name = name

        return group
    }

    private func tileImage(color: UIColor, tileSize: CGFloat) -> UIImage {
        let imageSize = CGSize(width: tileSize, height: tileSize)
        let renderer = UIGraphicsImageRenderer(size: imageSize)

        return renderer.image { _ in
            let fillRect = CGRect(origin: .zero, size: imageSize)
            let borderRect = fillRect.insetBy(dx: 1.5, dy: 1.5)
            let path = UIBezierPath(rect: borderRect)

            color.setFill()
            UIRectFill(fillRect)

            UIColor.black.withAlphaComponent(0.72).setStroke()
            path.lineWidth = 3
            path.stroke()
        }
    }
}
