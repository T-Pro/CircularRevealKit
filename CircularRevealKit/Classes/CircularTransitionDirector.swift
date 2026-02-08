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

public typealias AnimationBlock = ((
  _ transactionContext: UIViewControllerContextTransitioning,
  _ animationTime: TimeInterval,
  _ transitionCompletion: @escaping (_ didComplete: Bool) -> Void) -> Void)

@available(*, deprecated, renamed: "CircularTransitionDirector")
public typealias CicularTransactionDirector = CircularTransitionDirector

public class CircularTransitionDirector: NSObject {

  public var duration: TimeInterval = DEFAULT_CIRCULAR_ANIMATION_DURATION
  public var transitionContext: UIViewControllerContextTransitioning?
  public var animationBlock: AnimationBlock?

  deinit {
    animationBlock = nil
  }

}

extension CircularTransitionDirector: UIViewControllerAnimatedTransitioning {

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
      -> TimeInterval {
    return duration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.animationBlock?(transitionContext, duration) { (didComplete: Bool) in
      transitionContext.completeTransition(didComplete)
    }
  }

}

extension CircularTransitionDirector: UIViewControllerInteractiveTransitioning {

  public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.animationBlock?(transitionContext, duration) { (didComplete: Bool) in
      transitionContext.completeTransition(didComplete)
    }
  }

}

extension CircularTransitionDirector: UINavigationControllerDelegate {

  public func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController)
      -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  public func  navigationController(
    navigationController: UINavigationController,
    interactionControllerForAnimationController
    animationController: UIViewControllerAnimatedTransitioning)
      -> UIViewControllerInteractiveTransitioning? {
    return nil
  }

}
