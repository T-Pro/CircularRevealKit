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

/// An animatable shape that draws an elliptical clipping path expanding from
/// an origin point.
///
/// `progress` ranges from `0` (fully collapsed at `origin`) to `1`
/// (fully expanded, covering the entire bounding rect). The maximum radius
/// is calculated as the distance from `origin` to the farthest corner,
/// guaranteeing full coverage at `progress = 1`.
///
/// ```swift
/// CircularRevealShape(progress: 0.5, origin: CGPoint(x: 100, y: 200))
/// ```
@available(iOS 13.0, *)
public struct CircularRevealShape: Shape {

  /// The animation progress from `0` (collapsed) to `1` (fully revealed).
  public var progress: CGFloat

  /// The center point from which the circle expands.
  public var origin: CGPoint

  /// Allows SwiftUI to interpolate `progress` between animation keyframes.
  public var animatableData: CGFloat {
    get { progress }
    set { progress = newValue }
  }

  /// Creates a circular reveal shape.
  ///
  /// - Parameters:
  ///   - progress: A value from `0` to `1` controlling the circle's size.
  ///   - origin: The point from which the circle expands.
  public init(progress: CGFloat, origin: CGPoint) {
    self.progress = progress
    self.origin = origin
  }

  public func path(in rect: CGRect) -> Path {
    guard progress > 0 else { return Path() }

    // Calculate the maximum distance from the origin to any corner
    // to ensure full coverage when progress reaches 1.
    let maxDistance = [
      CGPoint(x: rect.minX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.minY),
      CGPoint(x: rect.minX, y: rect.maxY),
      CGPoint(x: rect.maxX, y: rect.maxY)
    ].map { corner in
      sqrt(pow(corner.x - origin.x, 2) + pow(corner.y - origin.y, 2))
    }.max() ?? 0

    let currentRadius = maxDistance * progress

    let ellipseRect = CGRect(
      x: origin.x - currentRadius,
      y: origin.y - currentRadius,
      width: currentRadius * 2,
      height: currentRadius * 2
    )

    return Path(ellipseIn: ellipseRect)
  }

}
