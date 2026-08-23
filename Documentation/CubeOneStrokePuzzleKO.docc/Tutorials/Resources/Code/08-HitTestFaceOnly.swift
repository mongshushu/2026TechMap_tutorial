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

    debugText = "터치한 cube material index: \(hitResult.geometryIndex)"
}
