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

import Foundation
import UIKit
import QuartzCore
import ObjectiveC

private var associatedDirectorKey: UInt8 = 0

public extension UIViewController {

  /// Presents a view controller with a circular reveal animation.
  ///
  /// The animation creates an expanding circle from `startFrame` that reveals the
  /// presented view controller. If the current view controller is embedded in a
  /// `UINavigationController`, the transition uses a custom push animation via
  /// `CircularTransitionDirector`. Otherwise, it takes snapshots of both view
  /// controllers and performs a modal presentation with `animated: false`.
  ///
  /// ```swift
  /// let detailVC = DetailViewController()
  /// radialPresent(viewController: detailVC, fadeColor: .blue)
  /// ```
  ///
  /// - Parameters:
  ///   - viewController: The view controller to present.
  ///   - duration: The duration of the circular reveal animation in seconds.
  ///     Defaults to `DEFAULT_CIRCULAR_ANIMATION_DURATION` (0.5s).
  ///   - startFrame: The rectangle from which the circle expands. When `CGRect.zero`
  ///     (the default), the animation originates from the center of the screen.
  ///   - fadeColor: An optional overlay color that fades in during the transition.
  ///     Pass `nil` (the default) for no overlay.
  ///   - delay: A delay in seconds before the animation begins. Defaults to `0`.
  ///   - completion: An optional closure called after the transition completes.
  func radialPresent(
    viewController: UIViewController,
    duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero,
    _ completion: (() -> Void)? = nil) {
    self.push(viewController, duration, startFrame, fadeColor, delay, revealType: .reveal, completion)
  }

  /// Dismisses the current view controller with a circular unreveal animation.
  ///
  /// The animation creates a contracting circle toward `startFrame` that hides the
  /// current view controller, revealing the one beneath. If inside a `UINavigationController`,
  /// this triggers a pop transition with a custom animation. Otherwise, it performs
  /// a modal dismissal with `animated: false`.
  ///
  /// ```swift
  /// radialDismiss(fadeColor: .blue, delay: 0.5)
  /// ```
  ///
  /// - Parameters:
  ///   - duration: The duration of the circular unreveal animation in seconds.
  ///     Defaults to `DEFAULT_CIRCULAR_ANIMATION_DURATION` (0.5s).
  ///   - startFrame: The rectangle toward which the circle contracts. When `CGRect.zero`
  ///     (the default), the animation contracts toward the center of the screen.
  ///   - fadeColor: An optional overlay color that fades out during the transition.
  ///     Pass `nil` (the default) for no overlay.
  ///   - delay: A delay in seconds before the animation begins. Defaults to `0`.
  ///   - completion: An optional closure called after the transition completes.
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
    
      let animatorDirector = CircularTransitionDirector()
      animatorDirector.duration = duration
      animatorDirector.animationBlock = { [weak self] (transactionContext, animationTime, completion) in

        transactionContext.containerView.backgroundColor = UIColor.systemBackground
        transactionContext.containerView.isOpaque = true
        
        let toViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.to)

        let fromViewController: UIViewController? = transactionContext.viewController(
          forKey: UITransitionContextViewControllerKey.from)

        guard let toView: UIView = toViewController?.view,
          let fromView: UIView = fromViewController?.view else {
            completion(false)
            return
        }

        switch revealType {

        case RevealType.reveal:

          transactionContext.containerView.addSubview(toView)
          transactionContext.containerView.addSubview(fromView)

          DispatchQueue.main.asyncAfter(deadline: .now()) {

            guard let toViewSnapshot: UIView = toView.snapshotView(afterScreenUpdates: true),
              let fromViewSnapshot: UIView = fromView.snapshotView(afterScreenUpdates: true) else {
                completion(false)
                return
            }

            toViewSnapshot.backgroundColor = UIColor.systemBackground
            fromViewSnapshot.backgroundColor = UIColor.systemBackground
            toViewSnapshot.isOpaque = true
            fromViewSnapshot.isOpaque = true

            toView.isHidden = true

            transactionContext.containerView.bringSubviewToFront(toView)

            fromViewSnapshot.frame.origin = fromView.frame.origin
            toViewSnapshot.frame.origin = fromView.frame.origin

            let fadeView: UIView? = self?.buildFadeView(fadeColor, fromView.frame)

            fromViewSnapshot.isOpaque = true
            transactionContext.containerView.addSubview(fromViewSnapshot)

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
                revealType: revealType,
                startBlock: {

                  fromViewSnapshot.isHidden = false
                  toViewSnapshot.isHidden = false
                  fadeView?.isHidden = false

                }) { () -> Void in

                  DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    completion(true)
                    transitionCompletion?()
                    fromViewSnapshot.removeFromSuperview()
                    fadeView?.removeFromSuperview()
                    toViewSnapshot.removeFromSuperview()
                    toView.isHidden = false
                  }

                }

            }

          }

        case RevealType.unreveal:

          guard let toViewSnapshot: UIView = toView.snapshotView(afterScreenUpdates: true),
            let fromViewSnapshot: UIView = fromView.snapshotView(afterScreenUpdates: true) else {
              completion(false)
              return
          }

          toViewSnapshot.isHidden = true
          transactionContext.containerView.addSubview(toViewSnapshot)

          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {

            let fadeView: UIView? = self?.buildFadeView(fadeColor, fromView.frame)

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

            CATransaction.flush()

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

      // Retain the director via associated object since navigationController.delegate is weak.
      // It will be released when the navigation controller is deallocated or when a new
      // director is associated.
      objc_setAssociatedObject(
        navigationController,
        &associatedDirectorKey,
        animatorDirector,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

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

      guard let viewController = viewController,
        let fromViewControllerSnapshot: UIView = self.view.snapshotView(afterScreenUpdates: true),
        let toViewControllerSnapshot: UIView = viewController.view.snapshotView(afterScreenUpdates: true) else {
          transitionCompletion?()
          return
      }

      let fadeView: UIView? = buildFadeView(fadeColor, fromViewControllerSnapshot.frame)
      fadeView?.alpha = 0.0

      fromViewControllerSnapshot.isOpaque = true
      toViewControllerSnapshot.isOpaque = true

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
          self.present(viewController, animated: false, completion: {
            transitionCompletion?()
            fromViewControllerSnapshot.removeFromSuperview()
            toViewControllerSnapshot.removeFromSuperview()
            fadeView?.removeFromSuperview()
          })
      }

    case RevealType.unreveal:

      guard let fromViewControllerSnapshot: UIView =
        self.view.snapshotView(afterScreenUpdates: true) else {
        self.dismiss(animated: false, completion: {
          transitionCompletion?()
        })
        return
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
