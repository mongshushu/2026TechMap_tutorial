enum LabelCorrection {
    case normal
    case mirrorX
    case mirrorY

    var xScale: CGFloat {
        if self == .mirrorX {
            return -1
        }

        return 1
    }

    var yScale: CGFloat {
        if self == .mirrorY {
            return -1
        }

        return 1
    }
}
