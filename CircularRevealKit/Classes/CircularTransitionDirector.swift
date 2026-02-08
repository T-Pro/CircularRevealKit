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

/// A closure that performs the actual circular animation within a view controller transition.
///
/// - Parameters:
///   - transactionContext: The transitioning context provided by UIKit containing the container view
///     and the participating view controllers.
///   - animationTime: The duration of the animation in seconds.
///   - transitionCompletion: A completion handler that **must** be called with `true` if the
///     transition completed successfully, or `false` if it was cancelled or failed.
public typealias AnimationBlock = ((
  _ transactionContext: UIViewControllerContextTransitioning,
  _ animationTime: TimeInterval,
  _ transitionCompletion: @escaping (_ didComplete: Bool) -> Void) -> Void)

@available(*, deprecated, renamed: "CircularTransitionDirector")
public typealias CicularTransactionDirector = CircularTransitionDirector

/// Coordinates circular reveal/unreveal transitions for `UINavigationController` push and pop operations.
///
/// `CircularTransitionDirector` conforms to `UIViewControllerAnimatedTransitioning`,
/// `UIViewControllerInteractiveTransitioning`, and `UINavigationControllerDelegate`.
/// It acts as the navigation controller's delegate and provides itself as the animation controller.
///
/// The actual animation logic is injected through the `animationBlock` closure, which is
/// called when UIKit requests the transition animation.
///
/// In most cases you do not need to create this object directly -- it is used internally
/// by `radialPresent(viewController:duration:startFrame:fadeColor:delay:_:)`
/// and `radialDismiss(duration:startFrame:fadeColor:delay:_:)`.
public class CircularTransitionDirector: NSObject {

  /// The duration of the transition animation in seconds.
  ///
  /// Defaults to `defaultCircularAnimationDuration` (0.5 seconds).
  public var duration: TimeInterval = defaultCircularAnimationDuration

  /// The current transition context, set automatically when the transition begins.
  public var transitionContext: UIViewControllerContextTransitioning?

  /// The closure that performs the circular animation.
  ///
  /// This block receives the transition context, animation duration, and a completion handler.
  /// It is responsible for creating snapshot views, applying the circular mask animation,
  /// and calling the completion handler when finished.
  public var animationBlock: AnimationBlock?

  deinit {
    animationBlock = nil
  }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension CircularTransitionDirector: UIViewControllerAnimatedTransitioning {

  /// Returns the duration of the circular transition animation.
  ///
  /// - Parameter transitionContext: The context object containing information about the transition.
  /// - Returns: The configured ``duration`` value.
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
      -> TimeInterval {
    return duration
  }

  /// Performs the circular transition animation.
  ///
  /// Stores the transition context and invokes the `animationBlock` closure.
  /// When the animation block calls its completion handler, the transition context
  /// is notified via `completeTransition(_:)`.
  ///
  /// - Parameter transitionContext: The context object containing information about the transition.
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.animationBlock?(transitionContext, duration) { (didComplete: Bool) in
      transitionContext.completeTransition(didComplete)
    }
  }

}

// MARK: - UIViewControllerInteractiveTransitioning

extension CircularTransitionDirector: UIViewControllerInteractiveTransitioning {

  /// Starts the interactive circular transition.
  ///
  /// This method has the same implementation as `animateTransition(using:)` and is provided
  /// for protocol conformance.
  ///
  /// - Parameter transitionContext: The context object containing information about the transition.
  public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.animationBlock?(transitionContext, duration) { (didComplete: Bool) in
      transitionContext.completeTransition(didComplete)
    }
  }

}

// MARK: - UINavigationControllerDelegate

extension CircularTransitionDirector: UINavigationControllerDelegate {

  /// Returns this director as the animation controller for navigation push/pop operations.
  ///
  /// - Parameters:
  ///   - navigationController: The navigation controller performing the transition.
  ///   - operation: The type of navigation operation (push or pop).
  ///   - fromVC: The view controller being navigated away from.
  ///   - toVC: The view controller being navigated to.
  /// - Returns: This director instance as the animation controller.
  public func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController)
      -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  /// Returns `nil` since interactive transitions are not currently supported.
  public func navigationController(
    navigationController: UINavigationController,
    interactionControllerForAnimationController
    animationController: UIViewControllerAnimatedTransitioning)
      -> UIViewControllerInteractiveTransitioning? {
    return nil
  }

}
