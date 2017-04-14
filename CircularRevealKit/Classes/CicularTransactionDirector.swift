//
//  CicularTransactionDirector.swift
//  Pods
//
//  Created by Pedro Paulo de Amorim on 14/04/2017.
//
//

import Foundation
import UIKit

public let DEFAULT_DURATION: TimeInterval = 0.5
public typealias AnimationBlock = (( _ transactionContext: UIViewControllerContextTransitioning,
                                     _ animationTime: TimeInterval,
                                     _ transitionCompletion: @escaping ()->()) ->())

public class CicularTransactionDirector: NSObject {

  public var duration: TimeInterval = DEFAULT_DURATION
  public var transitionContext: UIViewControllerContextTransitioning?
  public var animationBlock: AnimationBlock?

}

extension CicularTransactionDirector: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
      -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.animationBlock?(transitionContext, duration) { _ in
      transitionContext.completeTransition(true)
    }
  }
  
}

extension CicularTransactionDirector: UIViewControllerInteractiveTransitioning {

  public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    self.animationBlock?(transitionContext, duration) { _ in }
  }

}

extension CicularTransactionDirector: UINavigationControllerDelegate {

  public func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationControllerOperation,
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
