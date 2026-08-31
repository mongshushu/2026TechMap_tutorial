import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    private let hudLayer = SKNode()
    private let tileLayer = SKNode()
    private let gameStore = GameStore()

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

        let startTile = SKShapeNode(rectOf: tileSize, cornerRadius: 12)
        startTile.name = "tile_0_0"
        startTile.fillColor = .systemBlue
        startTile.strokeColor = .black
        startTile.lineWidth = 4
        startTile.position = CGPoint(x: size.width / 2 - 80, y: centerY)

        let nextTile = SKShapeNode(rectOf: tileSize, cornerRadius: 12)
        nextTile.name = "tile_0_1"
        nextTile.fillColor = .white
        nextTile.strokeColor = .black
        nextTile.lineWidth = 4
        nextTile.position = CGPoint(x: size.width / 2 + 80, y: centerY)

        tileLayer.addChild(startTile)
        tileLayer.addChild(nextTile)
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
                print("Current tile: \(gameStore.currentTileID)")
                print("Path: \(gameStore.pathTileIDs)")
                return
            }
        }
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
