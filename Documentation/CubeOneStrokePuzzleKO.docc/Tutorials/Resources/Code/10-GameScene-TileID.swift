import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    private let tileLayer = SKNode()
    private let gameStore = GameStore()
    private var tileNodesByID: [TileID: SKShapeNode] = [:]
    private var hasSetUpPuzzleScene = false

    override func didMove(to view: SKView) {
        setUpPuzzleScene()
    }

    func setUpPuzzleScene() {
        guard hasSetUpPuzzleScene == false else {
            return
        }

        hasSetUpPuzzleScene = true
        backgroundColor = .systemGray6
        addChild(tileLayer)
        buildTwoByTwoBoard()
    }

    private func buildTwoByTwoBoard() {
        let boardSide = min(size.width, size.height)
        let tileSide = boardSide / 2
        let boardOrigin = CGPoint(
            x: (size.width - boardSide) / 2,
            y: (size.height - boardSide) / 2
        )

        for row in 0..<2 {
            for column in 0..<2 {
                let tileID = TileID(row: row, column: column)
                let tile = SKShapeNode(
                    rectOf: CGSize(width: tileSide, height: tileSide)
                )

                tile.name = tileID.name
                tile.position = CGPoint(
                    x: boardOrigin.x + CGFloat(column) * tileSide + tileSide / 2,
                    y: boardOrigin.y + CGFloat(row) * tileSide + tileSide / 2
                )
                tile.fillColor = fillColor(for: tileID)
                tile.strokeColor = .black
                tile.lineWidth = 3

                tileLayer.addChild(tile)
                tileNodesByID[tileID] = tile
            }
        }
    }

    private func fillColor(for tileID: TileID) -> UIColor {
        if gameStore.currentTileID == tileID {
            return .systemBlue
        }

        if gameStore.visitedTileIDs.contains(tileID) {
            return .systemTeal
        }

        return .white
    }

    private func syncFromStore() {
        for (tileID, tileNode) in tileNodesByID {
            tileNode.fillColor = fillColor(for: tileID)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }

        let touchLocation = firstTouch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        for touchedNode in touchedNodes {
            guard let tileNode = touchedNode as? SKShapeNode,
                  let tileID = tileNodesByID.first(where: { $0.value === tileNode })?.key else {
                continue
            }

            if gameStore.selectTile(id: tileID) {
                syncFromStore()
            }

            return
        }
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
