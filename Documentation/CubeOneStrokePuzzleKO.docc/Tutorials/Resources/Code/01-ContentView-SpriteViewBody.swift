import SwiftUI
import SpriteKit

struct ContentView: View {
    private let gameScene: GameScene

    init() {
        let scene = GameScene(size: CGSize(width: 700, height: 900))
        scene.scaleMode = .resizeFill
        gameScene = scene
    }

    var body: some View {
        SpriteView(scene: gameScene)
            .ignoresSafeArea()
    }
}
