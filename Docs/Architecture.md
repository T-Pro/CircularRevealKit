# CircularRevealKit - Architecture

## Class Diagram

```
┌─────────────────────────────────────┐
│          UIViewController           │
│          (extension)                │
│  ┌────────────────────────────────┐ │
│  │ + radialPresent(...)           │ │
│  │ + radialDismiss(...)           │ │
│  │ - push(...)                    │ │
│  │ - validateUINavigationController│ │
│  │ - buildStartRectIfNeeded(...)  │ │
│  │ - buildFadeView(...)           │ │
│  └──────────┬─────────────────────┘ │
└─────────────┼───────────────────────┘
              │ creates
              ▼
┌──────────────────────────────────────┐
│  CicularTransactionDirector          │
│  (NSObject)                          │
│  ─────────────────────────────────── │
│  + duration: TimeInterval            │
│  + transitionContext                 │
│  + animationBlock: AnimationBlock?   │
│  ─────────────────────────────────── │
│  Conforms to:                        │
│  • UIViewControllerAnimatedTransi... │
│  • UIViewControllerInteractiveTr...  │
│  • UINavigationControllerDelegate    │
└──────────────────────────────────────┘
              │ used by animation block
              ▼
┌──────────────────────────────────────┐
│          UIView (extension)          │
│  ┌─────────────────────────────────┐ │
│  │ + drawAnimatedCircularMask(...) │ │
│  └──────────┬──────────────────────┘ │
└─────────────┼────────────────────────┘
              │ creates
              ▼
┌──────────────────────────────────────┐
│         LayerAnimator                │
│         (NSObject, CAAnimationDel.)  │
│  ─────────────────────────────────── │
│  - animationStarted: (() -> Void)?   │
│  - completionBlock: (() -> Void)?    │
│  - animLayer: CALayer?               │
│  - caAnimation: CAAnimation?         │
│  ─────────────────────────────────── │
│  + addAnimationStartedBlock(...)     │
│  + startAnimationWithBlock(...)      │
│  + animationDidStart(...)            │
│  + animationDidStop(...)             │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│         RevealType (enum)            │
│  ─────────────────────────────────── │
│  case reveal                         │
│  case unreveal                       │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│   DefaultCircularAnimation           │
│   (constants)                        │
│  ─────────────────────────────────── │
│  + DEFAULT_CIRCULAR_ANIMATION_DURA.. │
│  ~ ANIMATION_KEY_PATH                │
└──────────────────────────────────────┘
```

## Source Files

### 1. `RevealType.swift`
A simple `public enum` with two cases: `.reveal` (expand outward) and `.unreveal` (contract inward). This is the single type that controls the direction of the animation.

### 2. `DefaultCircularAnimation.swift`
Contains two constants:
- `DEFAULT_CIRCULAR_ANIMATION_DURATION` (public): `0.5` seconds.
- `ANIMATION_KEY_PATH` (internal): `"path"` -- the `CABasicAnimation` key-path used to animate the mask shape.

### 3. `UIViewRadial.swift`
A `public extension` on `UIView` that adds `drawAnimatedCircularMask(startFrame:duration:revealType:startBlock:completeBlock:)`. This is the core animation engine:

1. Creates a `CAShapeLayer` mask.
2. Computes the radius as `sqrt(width^2 + height^2) * 2` to ensure the circle covers the entire view.
3. Builds origin and destination `CGPath` ellipses depending on `.reveal` vs `.unreveal`.
4. Selects `easeIn` timing for reveal and `easeOut` for unreveal.
5. Delegates the actual `CABasicAnimation` execution to `LayerAnimator`.

### 4. `LayerAnimator.swift`
An internal helper (`NSObject` + `CAAnimationDelegate`) that:
- Holds a reference to the `CALayer` and `CAAnimation`.
- Uses a builder pattern (`addAnimationStartedBlock` returns `self`).
- Fires `animationStarted` when `animationDidStart` is called by Core Animation.
- Fires `completionBlock` when `animationDidStop` is called.
- Cleans up all references in `deinit` and after animation stops.

### 5. `CicularTransactionDirector.swift`
The navigation-controller transition coordinator. It conforms to:
- `UIViewControllerAnimatedTransitioning` -- provides `transitionDuration` and `animateTransition`.
- `UIViewControllerInteractiveTransitioning` -- provides `startInteractiveTransition`.
- `UINavigationControllerDelegate` -- returns `self` as the animation controller for push/pop.

The actual animation logic is injected via `animationBlock: AnimationBlock?`, a closure typedef that receives the transition context, duration, and a completion handler.

### 6. `UICircularViewControllerExtension.swift`
The main public API surface -- a `public extension` on `UIViewController`. It provides:
- `radialPresent(viewController:duration:startFrame:fadeColor:delay:completion:)`
- `radialDismiss(duration:startFrame:fadeColor:delay:completion:)`

Both delegate to a `private func push(...)` that handles two code paths:

1. **UINavigationController path**: Creates a `CicularTransactionDirector`, sets its `animationBlock` with snapshot-based animation, assigns it as the navigation controller's delegate, and then calls `pushViewController` or `popViewController`.
2. **Modal presentation path**: Takes snapshots of both view controllers, adds them as subviews, animates the circular mask, and then calls `present`/`dismiss` with `animated: false`.

## Design Patterns

| Pattern | Usage |
|---|---|
| **Extension-based API** | The library extends `UIViewController` and `UIView` rather than requiring subclassing. |
| **Strategy / Closure injection** | `CicularTransactionDirector.animationBlock` decouples the transition protocol from the animation implementation. |
| **Builder** | `LayerAnimator.addAnimationStartedBlock()` returns `self` for fluent chaining. |
| **Snapshot-based transitions** | Uses `snapshotView(afterScreenUpdates:)` to avoid modifying the actual view hierarchy during animation. |

## Animation Flow (Reveal)

```
1. radialPresent() called on current VC
2. Detect if inside UINavigationController
   ├── YES: Create CicularTransactionDirector
   │        Set animationBlock closure
   │        Assign as navigationController.delegate
   │        Call pushViewController(animated: true)
   │        → UIKit calls animateTransition()
   │        → animationBlock fires
   │        → Snapshot both VCs
   │        → Add snapshots to container
   │        → Call drawAnimatedCircularMask on toViewSnapshot
   │        → On completion, clean up snapshots, call completeTransition
   │
   └── NO:  Snapshot both VCs
            Add snapshots to self.view
            Call drawAnimatedCircularMask on toViewControllerSnapshot
            On completion, call present(animated: false)
            Clean up snapshots
```

## Dependencies

The library has **zero third-party dependencies**. It only uses Apple frameworks:
- `Foundation`
- `UIKit`
- `QuartzCore` (Core Animation)
- `CoreGraphics`
- `MetalKit` (imported in `UIViewRadial.swift` but not actually used)
