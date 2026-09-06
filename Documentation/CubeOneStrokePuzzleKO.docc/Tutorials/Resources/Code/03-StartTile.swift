import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    private let hudLayer = SKNode()
    private let tileLayer = SKNode()

    override func didMove(to view: SKView) {
        backgroundColor = .systemGray6
        addChild(hudLayer)
        addChild(tileLayer)

        buildTitle()
        buildTwoTileBoard()
    }

    private func buildTitle() {
        let titleLabel = SKLabelNode(text: "Hello SpriteKit")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 34
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 120)

        hudLayer.addChild(titleLabel)
    }

    private func buildTwoTileBoard() {
        let tileSize = CGSize(width: 140, height: 140)
        let centerY = size.height / 2

        let startTile = SKShapeNode(rectOf: tileSize, cornerRadius: 0)
        startTile.fillColor = .systemBlue
        startTile.strokeColor = .black
        startTile.lineWidth = 4
        startTile.position = CGPoint(x: size.width / 2 - 70, y: centerY)

        tileLayer.addChild(startTile)
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
