private struct TileGroups {
    let empty: SKTileGroup
    let blocked: SKTileGroup
    let visited: SKTileGroup
    let current: SKTileGroup
    let completed: SKTileGroup

    var tileSet: SKTileSet {
        SKTileSet(tileGroups: [
            empty,
            blocked,
            visited,
            current,
            completed
        ])
    }
}

private func makeTileGroups(tileSize: CGFloat) -> TileGroups {
    TileGroups(
        empty: makeTileGroup(name: "empty", color: .white, tileSize: tileSize),
        blocked: makeTileGroup(name: "blocked", color: .systemGray2, tileSize: tileSize),
        visited: makeTileGroup(name: "visited", color: .systemTeal, tileSize: tileSize),
        current: makeTileGroup(name: "current", color: .blue, tileSize: tileSize),
        completed: makeTileGroup(name: "completed", color: .systemTeal, tileSize: tileSize)
    )
}

private func makeTileGroup(name: String, color: UIColor, tileSize: CGFloat) -> SKTileGroup {
    let image = tileImage(color: color, tileSize: tileSize)
    let texture = SKTexture(image: image)

    texture.filteringMode = .nearest

    let definition = SKTileDefinition(texture: texture, size: image.size)
    let group = SKTileGroup(tileDefinition: definition)

    group.name = name

    return group
}

private func tileImage(color: UIColor, tileSize: CGFloat) -> UIImage {
    let imageSize = CGSize(width: tileSize, height: tileSize)
    let renderer = UIGraphicsImageRenderer(size: imageSize)

    return renderer.image { _ in
        let fillRect = CGRect(origin: .zero, size: imageSize)
        let borderRect = fillRect.insetBy(dx: 1.5, dy: 1.5)
        let path = UIBezierPath(rect: borderRect)

        color.setFill()
        UIRectFill(fillRect)

        UIColor.black.withAlphaComponent(0.72).setStroke()
        path.lineWidth = 3
        path.stroke()
    }
}
