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

import SwiftUI

// MARK: - View Modifier

@available(iOS 13.0, *)
private struct CircularRevealModifier: ViewModifier {

  let progress: CGFloat
  let origin: CGPoint

  func body(content: Content) -> some View {
    content.mask(
      CircularRevealShape(progress: progress, origin: origin)
        .fill(Color.white)
        .ignoresSafeArea()
    )
  }

}

// MARK: - View Extension

@available(iOS 13.0, *)
public extension View {

  /// Applies a circular reveal clip that animates between hidden and revealed states.
  ///
  /// When `isRevealed` changes, the view smoothly expands from or contracts
  /// toward `origin` using a circular mask animation.
  ///
  /// ```swift
  /// Image("photo")
  ///     .circularReveal(isRevealed: showPhoto, origin: buttonCenter)
  /// ```
  ///
  /// - Parameters:
  ///   - isRevealed: When `true`, the view is fully visible; when `false`,
  ///     it collapses to a zero-size circle at `origin`.
  ///   - origin: The point from which the circle expands or toward which it contracts.
  ///   - duration: The animation duration in seconds. Defaults to
  ///     `defaultCircularAnimationDuration` (0.5s).
  func circularReveal(
    isRevealed: Bool,
    origin: CGPoint,
    duration: Double = defaultCircularAnimationDuration
  ) -> some View {
    self
      .mask(
        CircularRevealShape(
          progress: isRevealed ? 1 : 0,
          origin: origin
        )
        .fill(Color.white)
        .ignoresSafeArea()
      )
      .animation(.easeInOut(duration: duration), value: isRevealed)
  }

}

// MARK: - Transition

@available(iOS 13.0, *)
public extension AnyTransition {

  /// A circular reveal transition that expands from or contracts toward a given point.
  ///
  /// Use this with SwiftUI's conditional views to create circular reveal
  /// insertion and removal animations:
  ///
  /// ```swift
  /// if showDetail {
  ///     DetailView()
  ///         .transition(.circularReveal(from: buttonCenter))
  /// }
  /// ```
  ///
  /// - Parameter origin: The point from which the circle expands on insertion
  ///   and toward which it contracts on removal.
  /// - Returns: A transition that clips the view with an animated circular mask.
  static func circularReveal(from origin: CGPoint) -> AnyTransition {
    .modifier(
      active: CircularRevealModifier(progress: 0, origin: origin),
      identity: CircularRevealModifier(progress: 1, origin: origin)
    )
  }

}
