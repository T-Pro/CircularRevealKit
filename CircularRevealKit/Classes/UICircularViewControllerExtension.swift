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

import Foundation
import UIKit

public extension UIViewController {

  func radialPresent(
    viewController: UIViewController,
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
    _ completion: (() -> Void)? = nil) {
    self.push(viewController, duration, startFrame, revealType: .reveal, completion)
  }

  func radialDismiss(
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
    _ completion: (() -> Void)? = nil) {
    self.push(nil, duration, startFrame, revealType: .unreveal, completion)
  }
  
  private func push(
    _ viewController: UIViewController?,
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
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
    
      let animatorDirector = CicularTransactionDirector()
      animatorDirector.duration = duration
      (self.parent as? UINavigationController)?.delegate = animatorDirector
      animatorDirector.animationBlock = { (transactionContext, animationTime, completion) in
        
        let toViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.to)
        let fromViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.from)
        
        if let toView: UIView = toViewController?.view,
          let fromView: UIView = fromViewController?.view {
          
          switch revealType {
            
          case RevealType.reveal:
            transactionContext.containerView.insertSubview(
              toView, aboveSubview: fromView)
            toView.drawAnimatedCircularMask(
              startFrame: rect,
              duration: animationTime,
              revealType: revealType) { () -> Void in
                completion()
                transitionCompletion?()
            }
            
          case RevealType.unreveal:
            transactionContext.containerView.insertSubview(
              toView, belowSubview: fromView)
            fromView.drawAnimatedCircularMask(
              startFrame: rect,
              duration: animationTime,
              revealType: revealType) { () -> Void in
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
        
        self.view?.addSubview(fromViewControllerSnapshot)
        self.view?.addSubview(toViewControllerSnapshot)
        
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
