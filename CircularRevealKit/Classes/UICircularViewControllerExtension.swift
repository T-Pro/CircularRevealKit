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

// MARK: - Public API

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
    self.performTransition(
      to: viewController, duration: duration, startFrame: startFrame,
      fadeColor: fadeColor, delay: delay, revealType: .reveal, completion)
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
    self.performTransition(
      to: nil, duration: duration, startFrame: startFrame,
      fadeColor: fadeColor, delay: delay, revealType: .unreveal, completion)
  }

}

// MARK: - Async/Await API

@available(iOS 13.0, *)
public extension UIViewController {

  /// Presents a view controller with a circular reveal animation.
  ///
  /// Async/await wrapper around the closure-based `radialPresent`. Suspends
  /// until the circular transition animation completes.
  ///
  /// ```swift
  /// await radialPresent(viewController: detailVC, fadeColor: .blue)
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
  @MainActor
  func radialPresent(
    viewController: UIViewController,
    duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero
  ) async {
    await withCheckedContinuation { continuation in
      radialPresent(
        viewController: viewController,
        duration: duration,
        startFrame: startFrame,
        fadeColor: fadeColor,
        delay: delay) {
          continuation.resume()
        }
    }
  }

  /// Dismisses the current view controller with a circular unreveal animation.
  ///
  /// Async/await wrapper around the closure-based `radialDismiss`. Suspends
  /// until the circular transition animation completes.
  ///
  /// ```swift
  /// await radialDismiss(fadeColor: .blue, delay: 0.5)
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
  @MainActor
  func radialDismiss(
    duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION,
    startFrame: CGRect = CGRect.zero,
    fadeColor: UIColor? = nil,
    delay: TimeInterval = .zero
  ) async {
    await withCheckedContinuation { continuation in
      radialDismiss(
        duration: duration,
        startFrame: startFrame,
        fadeColor: fadeColor,
        delay: delay) {
          continuation.resume()
        }
    }
  }

}

// MARK: - Shared Helpers

private extension UIViewController {

  /// Creates a snapshot of the given view with `systemBackground` and `isOpaque` pre-configured.
  func configuredSnapshot(of view: UIView, afterScreenUpdates: Bool) -> UIView? {
    guard let snapshot = view.snapshotView(afterScreenUpdates: afterScreenUpdates) else {
      return nil
    }
    snapshot.backgroundColor = .systemBackground
    snapshot.isOpaque = true
    return snapshot
  }

  /// Inserts the fade view into a container and animates its alpha for the given reveal type.
  func animateFadeView(
    _ fadeView: UIView?,
    in container: UIView,
    revealType: RevealType,
    duration: TimeInterval
  ) {
    guard let fadeView = fadeView else { return }

    switch revealType {
    case .reveal:
      fadeView.alpha = 0.01
      container.addSubview(fadeView)
      UIView.animate(withDuration: duration) { fadeView.alpha = 1.0 }
    case .unreveal:
      fadeView.alpha = 1.0
      fadeView.isHidden = true
      container.addSubview(fadeView)
      UIView.animate(withDuration: duration) { fadeView.alpha = 0.01 }
    }
  }

  /// Removes snapshot views from their superview and optionally unhides the real view.
  static func cleanupSnapshots(_ views: [UIView?], unhide: UIView? = nil) {
    views.forEach { $0?.removeFromSuperview() }
    unhide?.isHidden = false
  }

  /// Returns whether this view controller is hosted inside a `UINavigationController`.
  func isInsideNavigationController() -> Bool {
    return (presentingViewController is UINavigationController)
      || (parent is UINavigationController)
      || (self is UINavigationController)
  }

  /// Builds a default start rect centered on the screen if the provided frame is `.zero`.
  func buildStartRectIfNeeded(
    _ startFrame: CGRect,
    isNavController: Bool
  ) -> CGRect {
    guard startFrame == .zero else { return startFrame }

    let size: CGSize
    if isNavController {
      size = (parent as? UINavigationController)?.view.frame.size ?? .zero
    } else {
      size = view.frame.size
    }
    return CGRect(origin: CGPoint(x: size.width / 2, y: size.height / 2), size: .zero)
  }

  /// Creates a colored overlay view if `fadeColor` is non-nil.
  func buildFadeView(_ fadeColor: UIColor?, frame: CGRect) -> UIView? {
    guard let fadeColor = fadeColor else { return nil }
    let fadeView = UIView(frame: frame)
    fadeView.backgroundColor = fadeColor
    return fadeView
  }

}

// MARK: - Transition Dispatcher

private extension UIViewController {

  /// Central dispatcher that resolves the transition path (navigation vs modal)
  /// and delegates to the appropriate handler.
  func performTransition(
    to viewController: UIViewController?,
    duration: TimeInterval,
    startFrame: CGRect,
    fadeColor: UIColor?,
    delay: TimeInterval,
    revealType: RevealType,
    _ completion: (() -> Void)? = nil
  ) {
    let isNavController = isInsideNavigationController()
    let rect = buildStartRectIfNeeded(startFrame, isNavController: isNavController)

    if isNavController {
      performNavigationTransition(
        to: viewController, duration: duration, rect: rect,
        fadeColor: fadeColor, delay: delay, revealType: revealType, completion)
    } else {
      performModalTransition(
        to: viewController, duration: duration, rect: rect,
        fadeColor: fadeColor, delay: delay, revealType: revealType, completion)
    }
  }

}

// MARK: - Navigation Controller Transition

private extension UIViewController {

  /// Performs a circular transition via `UINavigationController` push/pop.
  func performNavigationTransition(
    to viewController: UIViewController?,
    duration: TimeInterval,
    rect: CGRect,
    fadeColor: UIColor?,
    delay: TimeInterval,
    revealType: RevealType,
    _ completion: (() -> Void)? = nil
  ) {
    let animatorDirector = CircularTransitionDirector()
    animatorDirector.duration = duration
    animatorDirector.animationBlock = { [weak self] (context, animationTime, transitionDone) in

      context.containerView.backgroundColor = .systemBackground
      context.containerView.isOpaque = true

      guard let toView = context.viewController(forKey: .to)?.view,
            let fromView = context.viewController(forKey: .from)?.view else {
        transitionDone(false)
        return
      }

      let fromViewController = context.viewController(forKey: .from)

      switch revealType {
      case .reveal:
        self?.navRevealAnimation(
          context: context, toView: toView, fromView: fromView,
          rect: rect, fadeColor: fadeColor, delay: delay,
          animationTime: animationTime, transitionDone: transitionDone,
          transitionCompletion: completion)
      case .unreveal:
        self?.navUnrevealAnimation(
          context: context, toView: toView, fromView: fromView,
          fromViewController: fromViewController,
          rect: rect, fadeColor: fadeColor, delay: delay,
          animationTime: animationTime, transitionDone: transitionDone,
          transitionCompletion: completion)
      }
    }

    guard let navigationController = self.parent as? UINavigationController else { return }

    // Retain the director via associated object since navigationController.delegate is weak.
    objc_setAssociatedObject(
      navigationController, &associatedDirectorKey,
      animatorDirector, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    navigationController.delegate = animatorDirector

    switch revealType {
    case .reveal:
      if let viewController = viewController {
        navigationController.pushViewController(viewController, animated: true)
      }
    case .unreveal:
      navigationController.popViewController(animated: true)
    }
  }

  /// Handles the reveal (expanding circle) animation inside a navigation transition.
  func navRevealAnimation(
    context: UIViewControllerContextTransitioning,
    toView: UIView,
    fromView: UIView,
    rect: CGRect,
    fadeColor: UIColor?,
    delay: TimeInterval,
    animationTime: TimeInterval,
    transitionDone: @escaping (Bool) -> Void,
    transitionCompletion: (() -> Void)?
  ) {
    context.containerView.addSubview(toView)
    context.containerView.addSubview(fromView)

    DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
      guard let toSnapshot = self?.configuredSnapshot(of: toView, afterScreenUpdates: true),
            let fromSnapshot = self?.configuredSnapshot(of: fromView, afterScreenUpdates: true) else {
        transitionDone(false)
        return
      }

      toView.isHidden = true
      context.containerView.bringSubviewToFront(toView)

      fromSnapshot.frame.origin = fromView.frame.origin
      toSnapshot.frame.origin = fromView.frame.origin

      let fadeView = self?.buildFadeView(fadeColor, frame: fromView.frame)

      context.containerView.addSubview(fromSnapshot)

      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self?.animateFadeView(fadeView, in: context.containerView, revealType: .reveal, duration: animationTime)

        toSnapshot.isHidden = true
        context.containerView.addSubview(toSnapshot)

        toSnapshot.layoutIfNeeded()
        fromSnapshot.layoutIfNeeded()

        toSnapshot.drawAnimatedCircularMask(
          startFrame: rect,
          duration: animationTime,
          revealType: .reveal,
          startBlock: {
            fromSnapshot.isHidden = false
            toSnapshot.isHidden = false
            fadeView?.isHidden = false
          }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
              transitionDone(true)
              transitionCompletion?()
              Self.cleanupSnapshots([fromSnapshot, fadeView, toSnapshot], unhide: toView)
            }
          }
      }
    }
  }

  /// Handles the unreveal (contracting circle) animation inside a navigation transition.
  func navUnrevealAnimation(
    context: UIViewControllerContextTransitioning,
    toView: UIView,
    fromView: UIView,
    fromViewController: UIViewController?,
    rect: CGRect,
    fadeColor: UIColor?,
    delay: TimeInterval,
    animationTime: TimeInterval,
    transitionDone: @escaping (Bool) -> Void,
    transitionCompletion: (() -> Void)?
  ) {
    guard let toSnapshot = configuredSnapshot(of: toView, afterScreenUpdates: true),
          let fromSnapshot = configuredSnapshot(of: fromView, afterScreenUpdates: true) else {
      transitionDone(false)
      return
    }

    toSnapshot.isHidden = true
    context.containerView.addSubview(toSnapshot)

    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
      let fadeView = self?.buildFadeView(fadeColor, frame: fromView.frame)
      self?.animateFadeView(fadeView, in: context.containerView, revealType: .unreveal, duration: animationTime)

      fromSnapshot.isHidden = true
      context.containerView.addSubview(fromSnapshot)
      context.containerView.insertSubview(toView, belowSubview: fromView)

      toSnapshot.layoutIfNeeded()
      fromSnapshot.layoutIfNeeded()

      CATransaction.flush()

      toSnapshot.isHidden = false

      fromSnapshot.drawAnimatedCircularMask(
        startFrame: rect,
        duration: animationTime,
        revealType: .unreveal) {
          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            transitionDone(true)
            transitionCompletion?()
            Self.cleanupSnapshots([fromSnapshot, fadeView, toSnapshot])
            fromViewController?.view.removeFromSuperview()
            toView.alpha = 1.0
            toView.isHidden = false
          }
        }

      fromSnapshot.isHidden = false
      toSnapshot.isHidden = false
      fadeView?.isHidden = false
    }
  }

}

// MARK: - Modal Transition

private extension UIViewController {

  /// Performs a circular transition via modal present/dismiss.
  func performModalTransition(
    to viewController: UIViewController?,
    duration: TimeInterval,
    rect: CGRect,
    fadeColor: UIColor?,
    delay: TimeInterval,
    revealType: RevealType,
    _ completion: (() -> Void)? = nil
  ) {
    switch revealType {
    case .reveal:
      modalRevealTransition(
        to: viewController, duration: duration, rect: rect,
        fadeColor: fadeColor, completion: completion)
    case .unreveal:
      modalUnrevealTransition(
        duration: duration, rect: rect,
        fadeColor: fadeColor, completion: completion)
    }
  }

  /// Modal reveal: snapshot both VCs, animate the circular mask, then present.
  func modalRevealTransition(
    to viewController: UIViewController?,
    duration: TimeInterval,
    rect: CGRect,
    fadeColor: UIColor?,
    completion: (() -> Void)?
  ) {
    guard let viewController = viewController,
          let fromSnapshot = self.view.snapshotView(afterScreenUpdates: true),
          let toSnapshot = viewController.view.snapshotView(afterScreenUpdates: true) else {
      completion?()
      return
    }

    let fadeView = buildFadeView(fadeColor, frame: fromSnapshot.frame)

    fromSnapshot.isOpaque = true
    toSnapshot.isOpaque = true

    self.view?.addSubview(fromSnapshot)
    if let fadeView = fadeView {
      fadeView.alpha = 0.0
      self.view?.addSubview(fadeView)
    }
    self.view?.addSubview(toSnapshot)

    UIView.animate(withDuration: duration) { fadeView?.alpha = 1.0 }

    toSnapshot.drawAnimatedCircularMask(
      startFrame: rect,
      duration: duration,
      revealType: .reveal) {
        self.present(viewController, animated: false) {
          completion?()
          Self.cleanupSnapshots([fromSnapshot, toSnapshot, fadeView])
        }
      }
  }

  /// Modal unreveal: snapshot both VCs, animate the circular mask, then dismiss.
  func modalUnrevealTransition(
    duration: TimeInterval,
    rect: CGRect,
    fadeColor: UIColor?,
    completion: (() -> Void)?
  ) {
    guard let fromSnapshot = self.view.snapshotView(afterScreenUpdates: true) else {
      self.dismiss(animated: false) { completion?() }
      return
    }

    guard let toSnapshot = self.presentingViewController?.view.snapshotView(afterScreenUpdates: true)
            ?? self.presentingViewController?.view.snapshotView(afterScreenUpdates: false) else {
      self.dismiss(animated: false) { completion?() }
      return
    }

    let fadeView = buildFadeView(fadeColor, frame: fromSnapshot.frame)

    fromSnapshot.isOpaque = true
    toSnapshot.isOpaque = true

    self.view?.addSubview(toSnapshot)
    if let fadeView = fadeView {
      fadeView.alpha = 1.0
      self.view?.addSubview(fadeView)
    }
    self.view?.addSubview(fromSnapshot)

    UIView.animate(withDuration: duration) { fadeView?.alpha = 0.01 }

    fromSnapshot.drawAnimatedCircularMask(
      startFrame: rect,
      duration: duration,
      revealType: .unreveal) {
        self.dismiss(animated: false) {
          completion?()
          Self.cleanupSnapshots([toSnapshot, fromSnapshot, fadeView])
        }
      }
  }

}
