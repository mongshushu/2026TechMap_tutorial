private func showTouchDot(at position: SCNVector3) {
    let sphere = SCNSphere(radius: 0.025)
    sphere.firstMaterial?.diffuse.contents = UIColor.systemGray

    let dotNode = SCNNode(geometry: sphere)
    dotNode.position = position

    scene.rootNode.addChildNode(dotNode)

    let wait = SCNAction.wait(duration: 0.25)
    let fade = SCNAction.fadeOut(duration: 0.2)
    let remove = SCNAction.removeFromParentNode()
    dotNode.runAction(SCNAction.sequence([wait, fade, remove]))
}
