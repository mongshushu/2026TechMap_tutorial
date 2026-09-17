func handleTap(at point: CGPoint, in sceneView: SCNView) {
    let hitResults = sceneView.hitTest(
        point,
        options: [
            SCNHitTestOption.firstFoundOnly: true
        ]
    )

    guard let hitResult = hitResults.first else {
        debugText = "큐브를 터치하지 않았어요."
        return
    }

    if hitResult.node !== cubeNode {
        debugText = "퍼즐 큐브가 아닌 곳을 터치했어요."
        return
    }

    let textureCoordinate = hitResult.textureCoordinates(withMappingChannel: 0)

    let boardPosition = boardPosition(from: textureCoordinate)
    let tileID = tileID(row: boardPosition.row, column: boardPosition.column)

    selectTile(tileID, textureCoordinate: textureCoordinate)
}
