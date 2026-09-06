import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    private let tileLayer = SKNode()
    private let gameStore = GameStore()
    private var tileNodesByID: [String: SKShapeNode] = [:]

    override func didMove(to view: SKView) {
        backgroundColor = .systemGray6
        addChild(tileLayer)
        buildTwoByTwoBoard()
    }

    private func buildTwoByTwoBoard() {
        let tileSize = CGSize(width: 130, height: 130)
        let gap: CGFloat = 0
        let boardWidth = tileSize.width * 2 + gap
        let startX = size.width / 2 - boardWidth / 2 + tileSize.width / 2
        let startY = size.height / 2 - boardWidth / 2 + tileSize.height / 2

        for row in 0..<2 {
            for column in 0..<2 {
                let tileID = "tile_\(row)_\(column)"
                let tile = SKShapeNode(rectOf: tileSize, cornerRadius: 0)
                tile.name = tileID
                tile.fillColor = fillColor(for: tileID)
                tile.strokeColor = .black
                tile.lineWidth = 4
                tile.position = CGPoint(
                    x: startX + CGFloat(column) * (tileSize.width + gap),
                    y: startY + CGFloat(row) * (tileSize.height + gap)
                )

                tileNodesByID[tileID] = tile
                tileLayer.addChild(tile)
            }
        }
    }

    private func fillColor(for tileID: String) -> UIColor {
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
            guard let nodeName = touchedNode.name else {
                continue
            }

            if nodeName.hasPrefix("tile_") {
                gameStore.selectTile(id: nodeName)
                syncFromStore()
                return
            }
        }
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
