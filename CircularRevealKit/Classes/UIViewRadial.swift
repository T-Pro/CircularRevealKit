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
