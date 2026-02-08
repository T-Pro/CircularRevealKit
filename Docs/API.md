# CircularRevealKit - API Reference

## Import

```swift
import CircularRevealKit
```

---

## UIViewController Extension

### `radialPresent(viewController:duration:startFrame:fadeColor:delay:completion:)`

Presents a view controller with a circular reveal animation.

```swift
func radialPresent(
    viewController: UIViewController,
    duration: TimeInterval = 0.5,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero,
    _ completion: (() -> Void)? = nil
)
```

**Parameters:**

| Parameter | Type | Default | Description |
|---|---|---|---|
| `viewController` | `UIViewController` | (required) | The view controller to present. |
| `duration` | `TimeInterval` | `0.5` | Duration of the circular reveal animation in seconds. |
| `startFrame` | `CGRect` | `CGRect.zero` | The origin rectangle from which the circle expands. When `.zero`, defaults to the center of the screen. |
| `fadeColor` | `UIColor?` | `nil` | Optional color overlay that fades in during the transition. |
| `delay` | `TimeInterval` | `.zero` | Delay before the animation begins. |
| `completion` | `(() -> Void)?` | `nil` | Closure called when the transition completes. |

**Behavior:**
- If the current view controller is inside a `UINavigationController`, uses push navigation with a custom transition.
- Otherwise, presents modally using `present(_:animated:completion:)` with `animated: false` (the circular mask provides the visual transition).

---

### `radialDismiss(duration:startFrame:fadeColor:delay:completion:)`

Dismisses the current view controller with a circular unreveal animation.

```swift
func radialDismiss(
    duration: TimeInterval = 0.5,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero,
    _ completion: (() -> Void)? = nil
)
```

**Parameters:**

| Parameter | Type | Default | Description |
|---|---|---|---|
| `duration` | `TimeInterval` | `0.5` | Duration of the circular unreveal animation in seconds. |
| `startFrame` | `CGRect` | `CGRect.zero` | The destination rectangle to which the circle contracts. When `.zero`, defaults to the center of the screen. |
| `fadeColor` | `UIColor?` | `nil` | Optional color overlay that fades out during the transition. |
| `delay` | `TimeInterval` | `.zero` | Delay before the animation begins. |
| `completion` | `(() -> Void)?` | `nil` | Closure called when the transition completes. |

**Behavior:**
- If inside a `UINavigationController`, uses pop navigation with a custom transition.
- Otherwise, dismisses modally.

---

## UIView Extension

### `drawAnimatedCircularMask(startFrame:duration:revealType:startBlock:completeBlock:)`

Applies an animated circular mask directly to a `UIView`.

```swift
func drawAnimatedCircularMask(
    startFrame: CGRect,
    duration: TimeInterval,
    revealType: RevealType,
    startBlock: (() -> Void)? = nil,
    _ completeBlock: (() -> Void)? = nil
)
```

**Parameters:**

| Parameter | Type | Default | Description |
|---|---|---|---|
| `startFrame` | `CGRect` | (required) | The rectangle defining the circle's origin (for reveal) or destination (for unreveal). |
| `duration` | `TimeInterval` | (required) | Duration of the animation in seconds. |
| `revealType` | `RevealType` | (required) | `.reveal` to expand outward, `.unreveal` to contract inward. |
| `startBlock` | `(() -> Void)?` | `nil` | Closure called when the animation starts (via `CAAnimationDelegate`). |
| `completeBlock` | `(() -> Void)?` | `nil` | Closure called when the animation completes. |

**Notes:**
- The radius is calculated as `sqrt(width^2 + height^2) * 2` to ensure full coverage.
- Uses `easeIn` timing for `.reveal` and `easeOut` for `.unreveal`.
- The mask is a `CAShapeLayer` with an elliptical `CGPath`.

---

## Types

### `RevealType`

```swift
public enum RevealType {
    case reveal    // Expanding circle (present)
    case unreveal  // Contracting circle (dismiss)
}
```

### `AnimationBlock`

```swift
public typealias AnimationBlock = ((
    _ transactionContext: UIViewControllerContextTransitioning,
    _ animationTime: TimeInterval,
    _ transitionCompletion: @escaping (_ didComplete: Bool) -> Void
) -> Void)
```

A closure type used internally by `CicularTransactionDirector` to inject the animation logic into the transition protocol methods.

---

## `CicularTransactionDirector`

A `public class` that coordinates `UINavigationController` transitions. Typically you do not need to use this directly -- it is created internally by `radialPresent` and `radialDismiss`.

```swift
public class CicularTransactionDirector: NSObject {
    public var duration: TimeInterval
    public var transitionContext: UIViewControllerContextTransitioning?
    public var animationBlock: AnimationBlock?
}
```

**Conforms to:**
- `UIViewControllerAnimatedTransitioning`
- `UIViewControllerInteractiveTransitioning`
- `UINavigationControllerDelegate`

---

## Constants

| Constant | Type | Value | Access |
|---|---|---|---|
| `DEFAULT_CIRCULAR_ANIMATION_DURATION` | `TimeInterval` | `0.5` | `public` |
| `ANIMATION_KEY_PATH` | `String` | `"path"` | `internal` |
