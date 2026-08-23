private let gameStore = GameStore()

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
