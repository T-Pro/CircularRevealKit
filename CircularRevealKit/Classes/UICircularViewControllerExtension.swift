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
    duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero,
    _ completion: (() -> Void)? = nil) {
    self.push(viewController, duration, startFrame, fadeColor, delay, revealType: .reveal, completion)
  }

  func radialDismiss(
    duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero,
    _ completion: (() -> Void)? = nil) {
    self.push(nil, duration, startFrame, fadeColor, delay, revealType: .unreveal, completion)
  }

  private func validateUINavigationController() -> Bool {
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

    return isNavigationController
  }

  private func buildStartRectIfNeeded(
    _ startFrame: CGRect = CGRect.zero,
    _ isNavigationController: Bool) -> CGRect {
    if startFrame == CGRect.zero {

      let viewControllerSize: CGSize?

      if isNavigationController {
        viewControllerSize = (self.parent as? UINavigationController)?.view.frame.size
      } else {
        viewControllerSize = self.view.frame.size
      }
      return CGRect(
        origin: CGPoint(
          x: (viewControllerSize?.width ?? 0)/2,
          y: (viewControllerSize?.height ?? 0)/2),
        size: CGSize(
          width: 0,
          height: 0))
    }
    return startFrame
  }

  private func buildFadeView(_ fadeColor: UIColor?, _ frame: CGRect) -> UIView? {
    if let fadeColor: UIColor = fadeColor {
      let fadeView = UIView(frame: frame)
      fadeView.backgroundColor = fadeColor
      return fadeView
    }
    return nil
  }
  
  private func push(
    _ viewController: UIViewController?,
    _ duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    _ startFrame: CGRect = CGRect.zero,
    _ fadeColor: UIColor?,
    _ delay: TimeInterval,
    revealType: RevealType = .reveal,
    _ transitionCompletion: (() -> Void)? = nil) {
    
    let isNavigationController: Bool = validateUINavigationController()
    let rect: CGRect = buildStartRectIfNeeded(startFrame, isNavigationController)

    if isNavigationController {
    
      let animatorDirector: CicularTransactionDirector = CicularTransactionDirector()
      animatorDirector.duration = duration
      animatorDirector.animationBlock = { (transactionContext, animationTime, completion) in
        
        let toViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.to)

        let fromViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.from)

        guard let toView: UIView = toViewController?.view,
          let fromView: UIView = fromViewController?.view else {
            return
        }

        switch revealType {

        case RevealType.reveal:

          toView.isHidden = true
          transactionContext.containerView.insertSubview(
            toView,
            aboveSubview: fromView)
          toView.isHidden = false

          guard let toViewSnapshot: UIView = toView.snapshotView(afterScreenUpdates: true),
            let fromViewSnapshot: UIView = fromView.snapshotView(afterScreenUpdates: true) else {
              return
          }

          toView.isHidden = true

          let fadeView: UIView? = self.buildFadeView(fadeColor, fromView.frame)

          fromViewSnapshot.isOpaque = true
          transactionContext.containerView.addSubview(fromViewSnapshot)

          toView.isHidden = false

          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {

            if let fadeView: UIView = fadeView {
              fadeView.alpha = 0.01
              transactionContext.containerView.addSubview(fadeView)
            }

            toViewSnapshot.isHidden = true
            transactionContext.containerView.addSubview(toViewSnapshot)

            toViewSnapshot.layoutIfNeeded()
            fromViewSnapshot.layoutIfNeeded()

            UIView.animate(withDuration: animationTime) {
              fadeView?.alpha = 1.0
            }

            toViewSnapshot.drawAnimatedCircularMask(
              startFrame: rect,
              duration: animationTime,
              revealType: revealType) { () -> Void in

                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                  completion(true)
                  transitionCompletion?()
                  fromViewSnapshot.removeFromSuperview()
                  fadeView?.removeFromSuperview()
                  toViewSnapshot.removeFromSuperview()
                  toView.isHidden = false
                }

            }

            fromViewSnapshot.isHidden = false
            toViewSnapshot.isHidden = false
            fadeView?.isHidden = false

          }

        case RevealType.unreveal:

          guard let toViewSnapshot: UIView = toView.snapshotView(afterScreenUpdates: true),
            let fromViewSnapshot: UIView = fromView.snapshotView(afterScreenUpdates: true) else {
              return
          }

          toViewSnapshot.isHidden = true
          transactionContext.containerView.addSubview(toViewSnapshot)

          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {

            let fadeView: UIView? = self.buildFadeView(fadeColor, fromView.frame)

            if let fadeView: UIView = fadeView {
              fadeView.alpha = 1.0
              fadeView.isHidden = true
              transactionContext.containerView.addSubview(fadeView)
            }

            fromViewSnapshot.isHidden = true
            transactionContext.containerView.addSubview(fromViewSnapshot)

            transactionContext.containerView.insertSubview(
              toView,
              belowSubview: fromView)

            toViewSnapshot.layoutIfNeeded()
            fromViewSnapshot.layoutIfNeeded()

            UIView.animate(withDuration: animationTime) {
              fadeView?.alpha = 0.01
            }

            toViewSnapshot.isHidden = false

            fromViewSnapshot.drawAnimatedCircularMask(
              startFrame: rect,
              duration: animationTime,
              revealType: revealType) { () -> Void in

                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                  completion(true)
                  transitionCompletion?()
                  fromViewSnapshot.removeFromSuperview()
                  fadeView?.removeFromSuperview()
                  toViewSnapshot.removeFromSuperview()
                  fromViewController?.view.removeFromSuperview()
                  toView.alpha = 1.0
                  toView.isHidden = false
                }

            }

            fromViewSnapshot.isHidden = false
            toViewSnapshot.isHidden = false
            fadeView?.isHidden = false

          }
          
        }
        
      }

      guard let navigationController: UINavigationController = self.parent as? UINavigationController else {
        return
      }

      navigationController.delegate = animatorDirector
      
      switch revealType {
      case RevealType.reveal:
        if let viewController: UIViewController = viewController {
          navigationController.pushViewController(viewController, animated: true)
          return
        }
      case RevealType.unreveal:
        navigationController.popViewController(animated: true)
      }

      return
    }
      
    switch revealType {

    case RevealType.reveal:

      guard let fromViewControllerSnapshot: UIView = self.view.snapshotView(afterScreenUpdates: true),
        let toViewControllerSnapshot: UIView = viewController?.view.snapshotView(afterScreenUpdates: true) else {
          fatalError("Error to take snapshots")
      }

      let fadeView: UIView? = buildFadeView(fadeColor, fromViewControllerSnapshot.frame)
      fadeView?.alpha = 0.0

      fromViewControllerSnapshot.isOpaque = true
      toViewControllerSnapshot.isOpaque = true

      fromViewControllerSnapshot.layer.shouldRasterize = true
      toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale

      fromViewControllerSnapshot.layer.shouldRasterize = true
      toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale

      self.view?.addSubview(fromViewControllerSnapshot)
      if let fadeView: UIView = fadeView {
        self.view?.addSubview(fadeView)
      }
      self.view?.addSubview(toViewControllerSnapshot)

      UIView.animate(withDuration: duration) {
        fadeView?.alpha = 1.0
      }

      toViewControllerSnapshot.drawAnimatedCircularMask(
        startFrame: rect,
        duration: duration,
        revealType: revealType) { () -> Void in
          self.present(viewController!, animated: false, completion: {
            transitionCompletion?()
            fromViewControllerSnapshot.removeFromSuperview()
            toViewControllerSnapshot.removeFromSuperview()
            fadeView?.removeFromSuperview()
          })
      }

    case RevealType.unreveal:

      guard let fromViewControllerSnapshot: UIView =
        self.view.snapshotView(afterScreenUpdates: true) else {
        fatalError("Error to take sel snapshot")
      }

      guard let toViewControllerSnapshot: UIView = self.presentingViewController?.view.snapshotView(afterScreenUpdates: true)
        ?? self.presentingViewController?.view.snapshotView(afterScreenUpdates: false) else {
        self.dismiss(animated: false, completion: {
          transitionCompletion?()
        })
        return
      }

      let fadeView: UIView? = buildFadeView(fadeColor, fromViewControllerSnapshot.frame)
      fadeView?.alpha = 1.0

      fromViewControllerSnapshot.isOpaque = true
      toViewControllerSnapshot.isOpaque = true

      fromViewControllerSnapshot.layer.shouldRasterize = true
      toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale

      fromViewControllerSnapshot.layer.shouldRasterize = true
      toViewControllerSnapshot.layer.rasterizationScale = UIScreen.main.scale

      self.view?.addSubview(toViewControllerSnapshot)
      if let fadeView: UIView = fadeView {
        self.view?.addSubview(fadeView)
      }
      self.view?.addSubview(fromViewControllerSnapshot)

      UIView.animate(withDuration: duration) {
        fadeView?.alpha = 0.01
      }

      fromViewControllerSnapshot.drawAnimatedCircularMask(
        startFrame: rect,
        duration: duration,
        revealType: revealType) { () -> Void in
          self.dismiss(animated: false, completion: {
            transitionCompletion?()
            toViewControllerSnapshot.removeFromSuperview()
            fromViewControllerSnapshot.removeFromSuperview()
            fadeView?.removeFromSuperview()
          })
      }

    }
    
  }

}
