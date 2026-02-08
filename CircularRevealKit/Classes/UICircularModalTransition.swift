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

import UIKit

// MARK: - Modal Transition

extension UIViewController {

  /// Performs a circular transition via modal present/dismiss.
  func performModalTransition(
    to viewController: UIViewController?,
    config: TransitionConfig
  ) {
    switch config.revealType {
    case .reveal:
      modalRevealTransition(to: viewController, config: config)
    case .unreveal:
      modalUnrevealTransition(config: config)
    }
  }

  /// Modal reveal: snapshot both VCs, animate the circular mask, then present.
  private func modalRevealTransition(
    to viewController: UIViewController?,
    config: TransitionConfig
  ) {
    guard let viewController = viewController,
          let fromSnapshot = self.view.snapshotView(afterScreenUpdates: true),
          let toSnapshot = viewController.view.snapshotView(afterScreenUpdates: true) else {
      config.completion?()
      return
    }

    let fadeView = buildFadeView(config.fadeColor, frame: fromSnapshot.frame)

    fromSnapshot.isOpaque = true
    toSnapshot.isOpaque = true

    self.view?.addSubview(fromSnapshot)
    if let fadeView = fadeView {
      fadeView.alpha = 0.0
      self.view?.addSubview(fadeView)
    }
    self.view?.addSubview(toSnapshot)

    UIView.animate(withDuration: config.duration) { fadeView?.alpha = 1.0 }

    toSnapshot.drawAnimatedCircularMask(
      startFrame: config.rect,
      duration: config.duration,
      revealType: .reveal,
      {
        self.present(viewController, animated: false) {
          config.completion?()
          Self.cleanupSnapshots([fromSnapshot, toSnapshot, fadeView])
        }
      })
  }

  /// Modal unreveal: snapshot both VCs, animate the circular mask, then dismiss.
  private func modalUnrevealTransition(config: TransitionConfig) {
    guard let fromSnapshot = self.view.snapshotView(afterScreenUpdates: true) else {
      self.dismiss(animated: false) { config.completion?() }
      return
    }

    guard let toSnapshot = self.presentingViewController?.view.snapshotView(afterScreenUpdates: true)
            ?? self.presentingViewController?.view.snapshotView(afterScreenUpdates: false) else {
      self.dismiss(animated: false) { config.completion?() }
      return
    }

    let fadeView = buildFadeView(config.fadeColor, frame: fromSnapshot.frame)

    fromSnapshot.isOpaque = true
    toSnapshot.isOpaque = true

    self.view?.addSubview(toSnapshot)
    if let fadeView = fadeView {
      fadeView.alpha = 1.0
      self.view?.addSubview(fadeView)
    }
    self.view?.addSubview(fromSnapshot)

    UIView.animate(withDuration: config.duration) { fadeView?.alpha = 0.01 }

    fromSnapshot.drawAnimatedCircularMask(
      startFrame: config.rect,
      duration: config.duration,
      revealType: .unreveal,
      {
        self.dismiss(animated: false) {
          config.completion?()
          Self.cleanupSnapshots([toSnapshot, fromSnapshot, fadeView])
        }
      })
  }

}
