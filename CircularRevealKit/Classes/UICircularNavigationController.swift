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

let defaultRadialDuration: TimeInterval = 0.5

public extension UIViewController {

  func setupBackButton(title: String = "Back", style: UIBarButtonItemStyle = UIBarButtonItemStyle.plain) {
    navigationItem.hidesBackButton = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: title, style: style, target: self, action: #selector(handleBackButton))
  }

  @objc func handleBackButton() {
    self.navigationController?.radialPopViewController()
  }

}

public extension UINavigationController {

  func radialPushViewController(
    _ viewController: UIViewController? = nil,
    _ duration: TimeInterval = defaultRadialDuration,
    _ startFrame: CGRect = CGRect.zero,
    show: Bool = true,
    _ transitionCompletion: (() -> ())? = nil) {
    
    let rect: CGRect
    
    if startFrame == CGRect.zero {
      let viewControllerSize = visibleViewController?.view.frame.size
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
    
    let animatorDirector = CicularTransactionDirector()
    animatorDirector.duration = duration
    delegate = animatorDirector
    animatorDirector.animationBlock = { (transactionContext, animationTime, completion) in

      let toViewController = transactionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
      let fromViewController = transactionContext.viewController(forKey: UITransitionContextViewControllerKey.from)

      if let toView = toViewController?.view, let fromView = fromViewController?.view {
        transactionContext.containerView.insertSubview(toView, aboveSubview: fromView)
      }

      toViewController?.view.drawAnimatedCircularMask(startFrame: rect, duration: animationTime) { () -> Void in
        completion()
        transitionCompletion?()
      }

    }

    if show {
      if let viewController = viewController {
        pushViewController(viewController, animated: true)
      } else {
        print("ViewController is nil")
      }
    } else {
      popViewController(animated: true)
    }

  }

  func radialPopViewController() {
    radialPushViewController(show: false)
  }

}





