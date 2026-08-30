private let gameScene: GameScene

init() {
    let scene = GameScene(size: CGSize(width: 700, height: 900))
    scene.scaleMode = .resizeFill
    gameScene = scene
}
