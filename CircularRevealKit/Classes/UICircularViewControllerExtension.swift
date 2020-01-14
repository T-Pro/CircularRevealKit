//
// Copyright (c) 2020 T-Pro
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

import Foundation
import UIKit

public extension UIViewController {

  func radialPresent(
    viewController: UIViewController,
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
    _ fadeColor: UIColor? = nil,
    _ completion: (() -> Void)? = nil) {
    self.push(viewController, duration, startFrame, fadeColor, revealType: .reveal, completion)
  }

  func radialDismiss(
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
    _ fadeColor: UIColor?,
    _ completion: (() -> Void)? = nil) {
    self.push(nil, duration, startFrame, fadeColor, revealType: .unreveal, completion)
  }
  
  private func push(
    _ viewController: UIViewController?,
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
    _ fadeColor: UIColor?,
    revealType: RevealType = .reveal,
    _ transitionCompletion: (() -> Void)? = nil) {
    
    let rect: CGRect
    
    var isNavigationController: Bool = false
    
    if self.presentingViewController != nil {
      isNavigationController = self.presentingViewController is UINavigationController
    }
    
    if !isNavigationController && self.parent != nil {
      isNavigationController = self.parent is UINavigationController
    }
    
    if !isNavigationController {
      isNavigationController = self is UINavigationController
    }
    
    if startFrame == CGRect.zero {
      
      let viewControllerSize: CGSize?
      
      if isNavigationController {
        viewControllerSize = (self.parent as? UINavigationController)?.view.frame.size
      } else {
        viewControllerSize = self.view.frame.size
      }
      rect = CGRect(
        origin: CGPoint(
          x: (viewControllerSize?.width ?? 0)/2,
          y: (viewControllerSize?.height ?? 0)/2),
        size: CGSize(
          width: 0,
          height: 0))
    } else {
      rect = startFrame
    }
    
    if isNavigationController {
    
      let animatorDirector: CicularTransactionDirector = CicularTransactionDirector()
      animatorDirector.duration = duration
      (self.parent as? UINavigationController)?.delegate = animatorDirector
      animatorDirector.animationBlock = { (transactionContext, animationTime, completion) in
        
        let toViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.to)

        let fromViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.from)

        if let toView: UIView = toViewController?.view,
          let fromView: UIView = fromViewController?.view,
          let toViewSnapshot: UIView = toView.snapshotView(afterScreenUpdates: true),
          let fromViewSnapshot: UIView = fromView.snapshotView(afterScreenUpdates: true) {

          let fadeView: UIView = UIView(frame: fromView.frame)
          fadeView.backgroundColor = fadeColor
          
          switch revealType {
            
          case RevealType.reveal:

            transactionContext.containerView.insertSubview(
              toView,
              aboveSubview: fromView)

            fromViewSnapshot.isOpaque = true
            transactionContext.containerView.addSubview(fromViewSnapshot)

            fadeView.alpha = 0.01
            transactionContext.containerView.addSubview(fadeView)

            transactionContext.containerView.addSubview(toViewSnapshot)

            UIView.animate(withDuration: animationTime) {
              fadeView.alpha = 1.0
            }

            toViewSnapshot.drawAnimatedCircularMask(
              startFrame: rect,
              duration: animationTime,
              revealType: revealType) { () -> Void in
                fromViewSnapshot.removeFromSuperview()
                fadeView.removeFromSuperview()
                toViewSnapshot.removeFromSuperview()
                completion()
                transitionCompletion?()
            }
            
          case RevealType.unreveal:

            transactionContext.containerView.insertSubview(
              toView,
              belowSubview: fromView)

            toViewSnapshot.isOpaque = true
            transactionContext.containerView.addSubview(toViewSnapshot)

            fadeView.alpha = 0.0
            transactionContext.containerView.addSubview(fadeView)

            transactionContext.containerView.addSubview(fromViewSnapshot)

            UIView.animate(withDuration: animationTime) {
              fadeView.alpha = 0.01
            }

            fromViewSnapshot.drawAnimatedCircularMask(
              startFrame: rect,
              duration: animationTime,
              revealType: revealType) { () -> Void in
                fromViewSnapshot.removeFromSuperview()
                fadeView.removeFromSuperview()
                toViewSnapshot.removeFromSuperview()
                completion()
                transitionCompletion?()
            }
            
          }
          
        }
        
      }
      
      switch revealType {
      case RevealType.reveal:
        if let viewController: UIViewController = viewController {
          (self.parent as? UINavigationController)?.pushViewController(viewController, animated: true)
          return
        }
        fatalError("ViewController is nil")
      case RevealType.unreveal:
        (self.parent as? UINavigationController)?.popViewController(animated: true)
      }
      
    } else {
      
      switch revealType {
        
      case RevealType.reveal:
        
        guard let fromViewControllerSnapshot: UIView = self.view.snapshotView(afterScreenUpdates: true),
          let toViewControllerSnapshot: UIView = viewController?.view.snapshotView(afterScreenUpdates: true) else {
            fatalError("Error to take snapshots")
        }

        let fadeView: UIView = UIView(frame: fromViewControllerSnapshot.frame)
        fadeView.backgroundColor = fadeColor
        fadeView.alpha = 0.0

        fromViewControllerSnapshot.isOpaque = true
        toViewControllerSnapshot.isOpaque = true

        fromViewControllerSnapshot.layer.shouldRasterize = true
        toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale

        fromViewControllerSnapshot.layer.shouldRasterize = true
        toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale
        
        self.view?.addSubview(fromViewControllerSnapshot)
        self.view?.addSubview(fadeView)
        self.view?.addSubview(toViewControllerSnapshot)

        UIView.animate(withDuration: duration) {
          fadeView.alpha = 1.0
        }
        
        toViewControllerSnapshot.drawAnimatedCircularMask(
          startFrame: rect,
          duration: duration,
          revealType: revealType) { () -> Void in
            self.present(viewController!, animated: false, completion: {
              fromViewControllerSnapshot.removeFromSuperview()
              toViewControllerSnapshot.removeFromSuperview()
              transitionCompletion?()
            })
        }
        
      case RevealType.unreveal:
        
        guard let fromViewControllerSnapshot: UIView =
          self.view.snapshotView(afterScreenUpdates: true) else {
          fatalError("Error to take sel snapshot")
        }
        
        guard let toViewControllerSnapshot: UIView = self.presentingViewController?.view.snapshotView(afterScreenUpdates: true) else {
          fatalError("Error to take snapshot of presentingViewController")
        }

        fromViewControllerSnapshot.isOpaque = true
        toViewControllerSnapshot.isOpaque = true

        fromViewControllerSnapshot.layer.shouldRasterize = true
        toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale

        fromViewControllerSnapshot.layer.shouldRasterize = true
        toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale
        
        self.view?.addSubview(toViewControllerSnapshot)
        self.view?.addSubview(fromViewControllerSnapshot)
        
        fromViewControllerSnapshot.drawAnimatedCircularMask(
          startFrame: rect,
          duration: duration,
          revealType: revealType) { () -> Void in
            self.dismiss(animated: false, completion: {
              toViewControllerSnapshot.removeFromSuperview()
              fromViewControllerSnapshot.removeFromSuperview()
              transitionCompletion?()
            })
        }
        
      }
          
      
    }
    
  }

}
