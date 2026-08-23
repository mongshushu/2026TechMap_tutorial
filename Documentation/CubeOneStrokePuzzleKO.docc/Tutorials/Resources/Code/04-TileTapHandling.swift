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
            print("Tapped tile: \(nodeName)")
            return
        }
    }
}
