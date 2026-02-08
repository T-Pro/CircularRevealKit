//
// Copyright (c) 2026 T-Pro
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

// MARK: - Async/Await API

@available(iOS 13.0, *)
public extension UIViewController {

  /// Presents a view controller with a circular reveal animation.
  ///
  /// Async/await wrapper around the closure-based `radialPresent`. Suspends
  /// until the circular transition animation completes.
  ///
  /// ```swift
  /// await radialPresent(viewController: detailVC, fadeColor: .blue)
  /// ```
  ///
  /// - Parameters:
  ///   - viewController: The view controller to present.
  ///   - duration: The duration of the circular reveal animation in seconds.
  ///     Defaults to `defaultCircularAnimationDuration` (0.5s).
  ///   - startFrame: The rectangle from which the circle expands. When `CGRect.zero`
  ///     (the default), the animation originates from the center of the screen.
  ///   - fadeColor: An optional overlay color that fades in during the transition.
  ///     Pass `nil` (the default) for no overlay.
  ///   - delay: A delay in seconds before the animation begins. Defaults to `0`.
  @MainActor
  func radialPresent(
    viewController: UIViewController,
    duration: TimeInterval = defaultCircularAnimationDuration,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero
  ) async {
    await withCheckedContinuation { continuation in
      radialPresent(
        viewController: viewController,
        duration: duration,
        startFrame: startFrame,
        fadeColor: fadeColor,
        delay: delay) {
          continuation.resume()
        }
    }
  }

  /// Dismisses the current view controller with a circular unreveal animation.
  ///
  /// Async/await wrapper around the closure-based `radialDismiss`. Suspends
  /// until the circular transition animation completes.
  ///
  /// ```swift
  /// await radialDismiss(fadeColor: .blue, delay: 0.5)
  /// ```
  ///
  /// - Parameters:
  ///   - duration: The duration of the circular unreveal animation in seconds.
  ///     Defaults to `defaultCircularAnimationDuration` (0.5s).
  ///   - startFrame: The rectangle toward which the circle contracts. When `CGRect.zero`
  ///     (the default), the animation contracts toward the center of the screen.
  ///   - fadeColor: An optional overlay color that fades out during the transition.
  ///     Pass `nil` (the default) for no overlay.
  ///   - delay: A delay in seconds before the animation begins. Defaults to `0`.
  @MainActor
  func radialDismiss(
    duration: TimeInterval = defaultCircularAnimationDuration,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero
  ) async {
    await withCheckedContinuation { continuation in
      radialDismiss(
        duration: duration,
        startFrame: startFrame,
        fadeColor: fadeColor,
        delay: delay) {
          continuation.resume()
        }
    }
  }

}
