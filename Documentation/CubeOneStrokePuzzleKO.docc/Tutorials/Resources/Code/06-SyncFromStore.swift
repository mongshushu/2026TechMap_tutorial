private func syncFromStore() {
    for (tileID, tileNode) in tileNodesByID {
        tileNode.fillColor = fillColor(for: tileID)
    }
}

private func fillColor(for tileID: String) -> UIColor {
    if gameStore.currentTileID == tileID {
        return .systemBlue
    }

    if gameStore.visitedTileIDs.contains(tileID) {
        return .systemTeal
    }

    return .white
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
            syncFromStore()
            return
        }
    }
}
