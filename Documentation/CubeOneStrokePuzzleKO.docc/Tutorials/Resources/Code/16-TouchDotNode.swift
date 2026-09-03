private func showTouchDot(at position: SCNVector3) {
    let sphere = SCNSphere(radius: 0.025)
    sphere.firstMaterial?.diffuse.contents = UIColor.systemGray

    let dotNode = SCNNode(geometry: sphere)
    dotNode.position = position

    scene.rootNode.addChildNode(dotNode)
}
