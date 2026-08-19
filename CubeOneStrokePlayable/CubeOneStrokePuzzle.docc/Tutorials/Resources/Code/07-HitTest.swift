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

guard let tappedFace = CubeFace(rawValue: hitResult.geometryIndex) else {
    debugText = "어느 cube face인지 확인하지 못했어요."
    return
}

if tappedFace != currentBoard.cubeFace {
    debugText = "\(tappedFace.koreanName)은 지금 stage의 면이 아니에요. \(currentBoard.cubeFace.koreanName)을 터치하세요."
    return
}

let textureCoordinate = hitResult.textureCoordinates(withMappingChannel: 0)

guard let tileID = currentBoard.tileID(fromTextureCoordinate: textureCoordinate) else {
    debugText = "터치 좌표를 타일로 바꾸지 못했어요."
    return
}

selectTile(tileID, textureCoordinate: textureCoordinate)
