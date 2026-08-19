# Cube One-Stroke Learning Notebook

이 파일은 튜토리얼을 따라가면서 사용자가 직접 채우는 학습 기록입니다.

## 현재 이해한 것

- [ ] 

## 아직 헷갈리는 것

- [ ] 

## 챕터별 체크리스트

### 01 SpriteKit Scene And Container Layers

- [ ] `SKScene`이 SpriteKit 화면의 바탕이라는 점을 설명할 수 있다.
- [ ] `hudLayer`가 보이는 사각형이 아니라 node를 담는 빈 그룹이라는 점을 설명할 수 있다.
- [ ] `zPosition`은 숫자가 클수록 앞에 보인다고 이해했다.

### 02 SpriteKit TileMap And Touch Coordinates

- [ ] `SKTileGroup`이 한 칸의 모양을 뜻한다는 점을 설명할 수 있다.
- [ ] `SKTileSet`이 tile group들을 모아둔 팔레트라는 점을 설명할 수 있다.
- [ ] `SKTileMapNode`가 2x2 격자를 관리하고, 각 칸이 하나의 `SKTileGroup`을 참조한다는 점을 이해했다.
- [ ] TileMap에서는 칸 하나하나가 별도 node가 아니라 row/column으로 `TileID`를 얻는다는 점을 설명할 수 있다.
- [ ] 현재 칸은 `.blue`, 지나간 칸과 완료된 face의 칸은 `.systemTeal`로 보인다는 규칙을 확인했다.

### 03-04 Foundation Board And Neighbor Rule

- [ ] `canSelectTile`, `selectTile`, `tileID`가 어떤 순서로 정보를 주고받는지 설명할 수 있다.
- [ ] `isNeighbor(from:to:)`가 상하좌우 한 칸 이동인지 검사한다는 점을 이해했다.

### 05 SwiftUI Scene Connection

- [ ] `@StateObject`가 SwiftUI 화면에서 store/view model을 한 번 만들고 유지하는 용도임을 설명할 수 있다.
- [ ] SwiftUI 화면이 `SceneKitCubeView(viewModel:)`로 같은 view model을 전달한다는 점을 이해했다.

### 06 Undo And Two By Two To Three By Three

- [ ] undo가 마지막 tile을 path에서 제거하고 현재 tile을 되돌린다는 점을 이해했다.
- [ ] 2x2 보드에서 row/column으로 tile을 구분하는 방식을 이해했다.
- [ ] `boardSize`가 2면 2x2, 3이면 3x3으로 같은 구조가 확장된다는 점을 이해했다.
- [ ] 필요할 때 코드를 나누고, 처음부터 과하게 나누지 않는 이유를 이해했다.

### 07 SceneKit Surface Touch

- [ ] SpriteKit 장면을 `SCNBox` 한 면의 material로 붙이는 흐름을 설명할 수 있다.
- [ ] `textureCoordinates`가 3D 표면 터치를 2D 좌표로 바꿔준다는 점을 설명할 수 있다.
- [ ] face 방향에 따라 좌표 label이 반전될 수 있고, `coordinateLayout`과 `labelCorrection`으로 보정한다는 점을 이해했다.

### 08 Rotation Mode And Finish

- [ ] 회전 모드 ON/OFF가 퍼즐 터치와 큐브 회전을 분리한다는 점을 설명할 수 있다.
- [ ] GitHub Pages 배포 때 catalog root와 base path가 `CubeOneStrokePuzzle`로 같아야 함을 확인했다.

## 질문 로그

- 

## 결정 로그

- 새 프로젝트 이름은 `CubeOneStrokePlayable`로 한다.
- DocC catalog root와 GitHub Pages base path는 `CubeOneStrokePuzzle`로 맞춘다.
- 1차 구현은 6면 전체 topology가 아니라 한 면 2x2 시작 퍼즐, 2x2 변형, 3x3 확장 stage 전환까지로 한다.
- SpriteKit 기본 구조 학습은 `SKTileMapNode` 격자, `SKTileSet` 팔레트, 각 칸의 `SKTileGroup` 참조 흐름을 반드시 포함한다.
- 완료된 cube face는 단색 material이 아니라 모든 타일이 `systemTeal`인 TileMap으로 남긴다.
- 현재 tile은 `.blue`, 지나간 tile은 `.systemTeal`로 고정한다.
- 큐브 face에는 HUD/상태 문구/path 선을 넣지 않고, 타일과 좌표 label만 남긴다.
- 회전 모드는 toggle로 분리하고, 회전 모드가 켜져 있을 때는 path 갱신을 막는다.

## 수정 요청 메모

- 
