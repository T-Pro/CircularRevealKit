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
import QuartzCore
import CoreGraphics

public extension UIView {

  /// Applies an animated circular mask to this view, creating a reveal or unreveal effect.
  ///
  /// The animation uses a `CAShapeLayer` mask with an elliptical `CGPath` that expands
  /// or contracts between the `startFrame` and a circle large enough to cover the entire view.
  /// The radius is calculated as `sqrt(width² + height²) × 2` to guarantee full coverage.
  ///
  /// - Parameters:
  ///   - startFrame: The rectangle that defines the circle's origin (for `.reveal`) or
  ///     destination (for `.unreveal`). Typically a zero-size rect centered on the touch point.
  ///   - duration: The duration of the animation in seconds.
  ///   - revealType: The direction of the animation -- `.reveal` expands outward with ease-in
  ///     timing, `.unreveal` contracts inward with ease-out timing.
  ///   - startBlock: An optional closure invoked when the Core Animation begins
  ///     (via `CAAnimationDelegate.animationDidStart`). Defaults to `nil`.
  ///   - completeBlock: An optional closure invoked when the animation finishes. Defaults to `nil`.
  func drawAnimatedCircularMask(
    startFrame: CGRect,
    duration: TimeInterval,
    revealType: RevealType,
    startBlock: (() -> Void)? = nil,
    _ completeBlock: (() -> Void)? = nil) {

    self.isHidden = false

    let maskLayer: CAShapeLayer = CAShapeLayer()
    let radius: CGFloat = sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2)) * 2

    let fullRect = CGRect(
      origin: CGPoint(
        x: frame.size.width / 2 - radius / 2,
        y: frame.size.height / 2 - radius / 2),
      size: CGSize(width: radius, height: radius))

    let originRect: CGRect
    let newRect: CGRect
    let timingFunction: String

    switch revealType {
    case .reveal:
      originRect = startFrame
      newRect = fullRect
      timingFunction = CAMediaTimingFunctionName.easeIn.rawValue
    case .unreveal:
      originRect = fullRect
      newRect = startFrame
      timingFunction = CAMediaTimingFunctionName.easeOut.rawValue
    }

    let originPath: CGPath = CGPath(ellipseIn: originRect, transform: nil)
    maskLayer.path = originPath

    let oldPath: CGPath? = maskLayer.path
    let newPath = CGPath(ellipseIn: newRect, transform: nil)

    layer.mask = maskLayer

    let revealAnimation: CABasicAnimation = CABasicAnimation(keyPath: animationKeyPath)
    revealAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: timingFunction))
    revealAnimation.fromValue = oldPath
    revealAnimation.toValue = newPath
    revealAnimation.duration = duration

    maskLayer.path = newPath

    let completion: () -> Void = {
      completeBlock?()
    }

    LayerAnimator(layer: maskLayer, animation: revealAnimation)
      .addAnimationStartedBlock(block: startBlock)
      .startAnimationWithBlock(block: completion)

  }

}
