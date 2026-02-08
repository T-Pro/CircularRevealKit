# CircularRevealKit - Code Review Findings

## Summary

Overall, CircularRevealKit is a focused, lightweight library that achieves its goal well. The code is readable and the public API is clean. However, there are several issues ranging from typos to potential bugs and modernization opportunities.

---

## Bugs and Potential Issues

### ~~1. Typo in class name: `CicularTransactionDirector`~~ (FIXED)

**File:** `CicularTransactionDirector.swift`
**Severity:** Medium (public API)

The class name is misspelled -- it reads "Cicular" instead of "Circular", and "Transaction" instead of "Transition". The correct name should be `CircularTransitionDirector`. Since this is a `public class`, renaming it is a breaking change, but it should be addressed in the next major version.

```
Current:  CicularTransactionDirector
Expected: CircularTransitionDirector
```

### ~~2. Unused `MetalKit` import~~ (FIXED)

**File:** `UIViewRadial.swift` (line 26)
**Severity:** Low

`import MetalKit` is present but nothing from MetalKit is used. This adds an unnecessary framework dependency and may increase launch time marginally.

### ~~3. Force-unwrap crash on missing snapshot (modal path)~~ (FIXED)

**File:** `UICircularViewControllerExtension.swift` (lines 294-297, 319)
**Severity:** High

In the modal `.reveal` path, if `snapshotView(afterScreenUpdates:)` returns `nil`, the code calls `fatalError`. While this is unlikely in normal use, it can happen if the view hierarchy is not yet laid out. A graceful fallback would be safer:

```swift
guard let fromViewControllerSnapshot = self.view.snapshotView(afterScreenUpdates: true),
      let toViewControllerSnapshot = viewController?.view.snapshotView(afterScreenUpdates: true) else {
    fatalError("Error to take snapshots")  // <-- crash
}
```

Additionally, on line 319:
```swift
self.present(viewController!, animated: false, ...)  // <-- force unwrap
```
The `viewController` parameter comes from `push(_ viewController: UIViewController?, ...)` where it is optional.

### ~~4. Silent failure in navigation controller reveal path~~ (FIXED)

**File:** `UICircularViewControllerExtension.swift` (lines 139-142)
**Severity:** Medium

When the snapshot calls inside `DispatchQueue.main.asyncAfter` return `nil`, the `guard` simply `return`s without calling the transition completion. This leaves the transition context in an incomplete state, potentially freezing the navigation controller.

```swift
guard let toViewSnapshot = toView.snapshotView(afterScreenUpdates: true),
      let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: true) else {
    return  // transition never completes
}
```

### ~~5. `animatorDirector` can be deallocated prematurely~~ (FIXED)

**File:** `UICircularViewControllerExtension.swift` (line 112)
**Severity:** Medium

`animatorDirector` is created as a local variable. It is then assigned as `navigationController.delegate`, which is a `weak` reference. If `animatorDirector` is not retained elsewhere, it may be deallocated before the animation completes, causing the animation block to never fire. The `animationBlock` closure captures `self` (the view controller), but nothing strongly retains the director itself.

### ~~6. `needsUnreveal` is declared but never used~~ (FIXED)

**File:** `Example/CircularRevealKit/FirstViewController.swift` (line 32)
**Severity:** Low (example code)

```swift
internal var needsUnreveal = true  // never read
```

---

## Code Quality Issues

### ~~7. Inconsistent naming conventions~~ (FIXED)

All constants have been renamed from `SCREAMING_SNAKE_CASE` to Swift's `lowerCamelCase` convention:

| Old Name | New Name |
|---|---|
| `DEFAULT_CIRCULAR_ANIMATION_DURATION` | `defaultCircularAnimationDuration` |
| `ANIMATION_KEY_PATH` | `animationKeyPath` |
| `CIRCULAR_ANIMATION_CELL` | `circularAnimationCell` |
| `CIRCULAR_ANIMATION_DELAY` | `circularAnimationDelay` |

A deprecated alias is provided for `DEFAULT_CIRCULAR_ANIMATION_DURATION` to maintain backward compatibility.

### ~~8. Redundant `break` statements in `switch`~~ (FIXED)

**File:** `UIViewRadial.swift` (lines 57, 68)

In Swift, `switch` cases do not fall through by default. The `break` statements are unnecessary.

### ~~9. Typo: "contraints" instead of "constraints"~~ (FIXED)

**Files:** `FirstViewControllerContraints.swift`, `CircularViewCell.swift`

The variable name `contraints` is misspelled throughout the example code. The filename itself (`FirstViewControllerContraints.swift`) also contains the typo.

### ~~10. Legacy constraint API~~ (FIXED)

**Files:** `FirstViewControllerContraints.swift`, `SecondViewController.swift`, `CircularViewCell.swift`

The example app uses the verbose `NSLayoutConstraint(item:attribute:relatedBy:toItem:attribute:multiplier:constant:)` initializer instead of the modern anchor-based API or `NSLayoutConstraint.activate()`. While functional, this is harder to read and maintain.

### ~~11. `@UIApplicationMain` is deprecated~~ (FIXED)

**File:** `Example/CircularRevealKit/AppDelegate.swift` (line 25)

Starting with Swift 5.3, `@main` is the preferred attribute. `@UIApplicationMain` still works but is deprecated.

### ~~12. Empty test file~~ (FIXED)

**File:** `Example/Tests/Tests.swift`

The test file is empty -- no tests exist. This means there is zero automated test coverage.

---

## Modernization Recommendations

### ~~13. Minimum deployment target is iOS 9~~ (FIXED)

**File:** `Package.swift`, `CircularRevealKit.podspec`

iOS 9 reached end-of-life years ago. Raising the minimum to iOS 13+ would allow:
- Removing `topLayoutGuide` / `bottomLayoutGuide` workarounds in the example.
- Using `UIWindowScene` and `@main`.
- Leveraging modern UIKit APIs.

### ~~14. No `async/await` support~~ (FIXED)

The completion-handler API now offers `async` alternatives for Swift concurrency using `withCheckedContinuation`. The existing closure-based implementation is unchanged; the async methods are thin wrappers marked `@MainActor` and `@available(iOS 13.0, *)`:

```swift
await radialPresent(viewController: detailVC, fadeColor: .blue)
await radialDismiss(fadeColor: .blue)
await view.drawAnimatedCircularMask(startFrame: rect, duration: 0.5, revealType: .reveal)
```

### 15. No SwiftUI integration

There is no SwiftUI wrapper. A `ViewModifier` or `UIViewControllerRepresentable` bridge would make the library usable in SwiftUI projects.

### ~~16. Hardcoded `UIColor.black` backgrounds~~ (FIXED)

**File:** `UICircularViewControllerExtension.swift` (lines 116-117, 144-147)

The container view and snapshots are hardcoded to `UIColor.black`. This does not respect Dark Mode and may cause visual artifacts on devices where the user expects a different background.

---

## Security and Best Practices

### ~~17. No access control on `LayerAnimator`~~ (FIXED)

**File:** `LayerAnimator.swift`

`LayerAnimator` has no explicit access modifier, defaulting to `internal`. This is correct for the library's use case, but the properties (`animationStarted`, `completionBlock`, `animLayer`, `caAnimation`) should be `private` to enforce encapsulation.

### ~~18. Potential retain cycles~~ (FIXED)

In `UICircularViewControllerExtension.swift`, the `animationBlock` closure captures `self` (the presenting view controller) strongly. While the block is nilled out in `deinit` of the director, if the director is retained in an unexpected way, this could cause a retain cycle. Using `[weak self]` in the closure would be safer.

---

## Summary Table

| # | Severity | Category | Description | Status |
|---|---|---|---|---|
| 1 | Medium | Bug/Naming | ~~Class name typo: `CicularTransactionDirector`~~ | FIXED |
| 2 | Low | Cleanup | ~~Unused `MetalKit` import~~ | FIXED |
| 3 | High | Bug | ~~`fatalError` and force-unwrap on snapshot failure~~ | FIXED |
| 4 | Medium | Bug | ~~Silent transition failure on nil snapshots~~ | FIXED |
| 5 | Medium | Bug | ~~Transition director may deallocate prematurely~~ | FIXED |
| 6 | Low | Cleanup | ~~Unused `needsUnreveal` property~~ | FIXED |
| 7 | Low | Style | ~~Non-Swift naming conventions for constants~~ | FIXED |
| 8 | Low | Style | ~~Redundant `break` in switch cases~~ | FIXED |
| 9 | Low | Style | ~~Typo "contraints" in variable/file names~~ | FIXED |
| 10 | Low | Style | ~~Legacy constraint API in example~~ | FIXED |
| 11 | Low | Style | ~~Deprecated `@UIApplicationMain`~~ | FIXED |
| 12 | Medium | Testing | ~~Empty test file, no test coverage~~ | FIXED |
| 13 | Medium | Modernization | ~~iOS 9 minimum deployment target~~ | FIXED |
| 14 | Low | Modernization | ~~No async/await API~~ | FIXED |
| 15 | Low | Modernization | No SwiftUI support | Open |
| 16 | Low | Bug | ~~Hardcoded black backgrounds ignore Dark Mode~~ | FIXED |
| 17 | Low | Best Practice | ~~Properties on `LayerAnimator` should be private~~ | FIXED |
| 18 | Medium | Best Practice | ~~Potential retain cycles in animation closures~~ | FIXED |
