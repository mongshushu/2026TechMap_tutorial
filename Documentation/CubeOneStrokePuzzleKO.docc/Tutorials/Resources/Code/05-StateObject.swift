@StateObject private var viewModel = SceneKitPuzzleViewModel()

Text(viewModel.stageTitle)
    .font(.subheadline)
    .foregroundStyle(.secondary)

Text(viewModel.debugText)
    .font(.footnote.monospaced())
    .foregroundStyle(.secondary)
    .multilineTextAlignment(.center)
    .frame(maxWidth: .infinity, minHeight: 44)
