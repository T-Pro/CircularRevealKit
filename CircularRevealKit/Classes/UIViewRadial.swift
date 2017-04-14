//
// Copyright (c) 2017 T-Pro
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

public extension  UIView {
  
  func drawAnimatedCircularMask(
    startFrame: CGRect,
    duration: TimeInterval,
    _ completeBlock: @escaping () -> ()) {

    let maskRect: CGRect = startFrame
    let maskLayer = CAShapeLayer()
    maskLayer.path = CGPath(ellipseIn: maskRect, transform: nil)
    let radius = sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2)) * 2
    
    let newRect = CGRect(
      origin: CGPoint(
        x: frame.size.width/2-radius/2,
        y: maskRect.origin.y-radius/2),
      size: CGSize(
        width: radius,
        height: radius))
    
    let newPath = CGPath(ellipseIn: newRect, transform: nil)
    
    self.layer.mask = maskLayer
    
    let revealAnimation = CABasicAnimation(keyPath: "path")
    revealAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    revealAnimation.fromValue = maskLayer.path
    revealAnimation.toValue = newPath
    
    revealAnimation.duration = CFTimeInterval(duration)
    
    maskLayer.path = newPath
    
    let animator = LayerAnimator(layer: maskLayer, animation: revealAnimation)
    
    animator.startAnimationWithBlock { () -> Void in
      completeBlock()
    }

  }

}
