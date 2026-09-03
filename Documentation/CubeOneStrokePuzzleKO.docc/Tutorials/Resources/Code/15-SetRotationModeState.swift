@Published private(set) var isRotationModeEnabled = false

func setRotationModeEnabled(_ enabled: Bool) {
    if isRotationModeEnabled == enabled {
        return
    }

    isRotationModeEnabled = enabled
}
