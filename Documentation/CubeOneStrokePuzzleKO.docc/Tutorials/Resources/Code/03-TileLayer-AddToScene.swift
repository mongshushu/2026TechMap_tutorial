import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    private let hudLayer = SKNode()
    private let tileLayer = SKNode()

    override func didMove(to view: SKView) {
        backgroundColor = .systemGray6
        addChild(hudLayer)
        addChild(tileLayer)

        let titleLabel = SKLabelNode(text: "Hello SpriteKit")
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontSize = 34
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)

        hudLayer.addChild(titleLabel)
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
