//
// Copyright (c) 2019 T-Pro
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

  func drawAnimatedCircularMask(
    startFrame: CGRect,
    duration: TimeInterval,
    revealType: RevealType,
    _ completeBlock: (() -> Void)? = nil) {

    let maskLayer: CAShapeLayer = CAShapeLayer()
    let radius: CGFloat = sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2)) * 2

    let originRect: CGRect
    let newRect: CGRect
    let timingFunction: String

    switch revealType {
      case RevealType.reveal:
        originRect = startFrame
        newRect = CGRect(
          origin: CGPoint(
            x: frame.size.width/2-radius/2,
            y: frame.size.height/2-radius/2),
          size: CGSize(
            width: radius,
            height: radius))
        timingFunction = CAMediaTimingFunctionName.easeIn.rawValue
        break
      case RevealType.unreveal:
        originRect = CGRect(
          origin: CGPoint(
            x: frame.size.width/2-radius/2,
            y: frame.size.height/2-radius/2),
          size: CGSize(
            width: radius,
            height: radius))
        newRect = startFrame
        timingFunction = CAMediaTimingFunctionName.easeOut.rawValue
        break
    }

    let originPath: CGPath = CGPath(ellipseIn: originRect, transform: nil)
    maskLayer.path = originPath

    let oldPath: CGPath? = maskLayer.path
    let newPath = CGPath(ellipseIn: newRect, transform: nil)

    layer.mask = maskLayer

    let revealAnimation: CABasicAnimation = CABasicAnimation(keyPath: ANIMATION_KEY_PATH)
    revealAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: timingFunction))
    revealAnimation.fromValue = oldPath
    revealAnimation.toValue = newPath
    revealAnimation.duration = duration

    maskLayer.path = newPath

    LayerAnimator(layer: maskLayer, animation: revealAnimation)
      .startAnimationWithBlock(block: completeBlock)

  }

}
