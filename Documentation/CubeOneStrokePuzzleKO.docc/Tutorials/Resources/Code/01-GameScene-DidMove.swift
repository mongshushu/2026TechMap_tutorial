import SwiftUI
import SpriteKit

final class GameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .systemGray6
    }
}

#Preview {
    SpriteView(scene: GameScene(size: CGSize(width: 700, height: 900)))
}
