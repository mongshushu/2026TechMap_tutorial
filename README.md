# CubeOneStrokePlayable

This is a fresh Xcode project for the Cube One-Stroke Puzzle curriculum.

## What To Open

- App project: `CubeOneStrokePlayable.xcodeproj`
- DocC catalog: `CubeOneStrokePlayable/CubeOneStrokePuzzle.docc`
- Korean DocC catalog: `Documentation/CubeOneStrokePuzzleKO.docc`
- Learning notebook: `LearningNotebook.md`

## Scope

- SwiftUI hosts the app screen.
- SceneKit renders an `SCNBox` cube.
- SpriteKit draws puzzle grids on cube faces with `SKTileMapNode`.
- The first playable stages are 2x2 so `SKTileMapNode`, `SKTileSet`, and `SKTileGroup` are easy to inspect before the tutorial expands to 3x3.
- `SCNHitTestResult.textureCoordinates(withMappingChannel:)` converts a 3D surface tap into a 2D tile coordinate.
- Completed cube faces remain tile maps; every completed tile becomes `systemTeal` while tile borders stay visible.
- The current tile is `.blue`; visited tiles are `.systemTeal`.
- Rotation mode is a toggle. When it is on, the cube becomes smaller and tile selection is blocked.

## GitHub Pages DocC Hosting

Build the English and Korean catalogs into `docs/`, then publish `main` branch
`/docs` with GitHub Pages. The repository name is part of the Pages URL, so the
DocC hosting base paths include `2026TechMap_tutorial`.

```bash
mkdir -p docs

xcrun docc convert CubeOneStrokePlayable/CubeOneStrokePuzzle.docc \
  --fallback-display-name "Cube One-Stroke Puzzle" \
  --fallback-bundle-identifier "com.example.CubeOneStrokePuzzle" \
  --fallback-bundle-version "1.0.0" \
  --transform-for-static-hosting \
  --hosting-base-path 2026TechMap_tutorial/CubeOneStrokePuzzle \
  --output-path docs/CubeOneStrokePuzzle
```

Korean version:

```bash
xcrun docc convert Documentation/CubeOneStrokePuzzleKO.docc \
  --fallback-display-name "Cube One-Stroke Puzzle KO" \
  --fallback-bundle-identifier "com.example.CubeOneStrokePuzzleKO" \
  --fallback-bundle-version "1.0.0" \
  --transform-for-static-hosting \
  --hosting-base-path 2026TechMap_tutorial/CubeOneStrokePuzzleKO \
  --output-path docs/CubeOneStrokePuzzleKO
```

After publishing, open:

- English: `https://<github-username>.github.io/2026TechMap_tutorial/CubeOneStrokePuzzle/tutorials/cubeonestrokepuzzle/`
- Korean: `https://<github-username>.github.io/2026TechMap_tutorial/CubeOneStrokePuzzleKO/tutorials/cubeonestrokepuzzleko/`

## Preview Images

Each code step has a temporary preview slot:

```swift
@Image(source: preview-placeholder.svg, alt: "Preview placeholder for the screen after adding this code.")
```

To add a real screenshot later:

1. Put the image in the catalog's `Resources` folder.
   - English: `CubeOneStrokePlayable/CubeOneStrokePuzzle.docc/Resources`
   - Korean: `Documentation/CubeOneStrokePuzzleKO.docc/Resources`
2. Use a clear file name, for example `preview-01-scene-init.png`.
3. Replace only that step's `source` value:

```swift
@Image(source: preview-01-scene-init.png, alt: "Screen after initializing the SpriteKit scene.")
```

For local review, open each language catalog directly. The in-page language
switch works only when both static DocC folders are published under the same
site root.
