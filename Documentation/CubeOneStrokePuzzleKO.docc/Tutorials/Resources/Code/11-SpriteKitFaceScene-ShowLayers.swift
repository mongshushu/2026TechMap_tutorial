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
    }
}
