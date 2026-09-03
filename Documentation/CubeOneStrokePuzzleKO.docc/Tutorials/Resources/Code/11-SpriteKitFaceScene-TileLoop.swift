import SpriteKit
import UIKit

final class SpriteKitFaceScene: SKScene {
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
        currentTileID: TileID?
    ) {
        removeAllChildren()

        let tileLayer = SKNode()
        let labelLayer = SKNode()
        tileLayer.zPosition = 0
        labelLayer.zPosition = 1

        addChild(tileLayer)
        addChild(labelLayer)

        let tileSize = min(size.width, size.height) / CGFloat(board.boardSize)

        for row in 0..<board.boardSize {
            for column in 0..<board.boardSize {
                let tile = SKShapeNode(
                    rectOf: CGSize(width: tileSize, height: tileSize)
                )
                tile.position = CGPoint(
                    x: CGFloat(column) * tileSize + tileSize / 2,
                    y: CGFloat(row) * tileSize + tileSize / 2
                )

                tileLayer.addChild(tile)
            }
        }
    }
}
