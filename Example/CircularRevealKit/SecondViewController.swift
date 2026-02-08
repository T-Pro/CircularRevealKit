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
import CircularRevealKit

class SecondViewController: UIViewController {

  internal var viewReady = false

  internal lazy var randomButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle("Click me", for: UIControl.State.normal)
    view.backgroundColor = UIColor.black
    return view
  }()

  internal lazy var navigationBar: UINavigationBar = {
    let view = UINavigationBar()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.blue
    let navigationItem: UINavigationItem = UINavigationItem()
    navigationItem.title = "SecondViewController"
    view.items = [navigationItem]
    return view
  }()

  internal lazy var bottomBar: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.green
    return view
  }()

  deinit {
    print("Deinit SecondViewController")
  }

  override func loadView() {
    super.loadView()
    title = "SecondViewController"
    view.backgroundColor = UIColor.white
    view.addSubview(randomButton)
    view.addSubview(navigationBar)
    view.addSubview(bottomBar)
    view.updateConstraintsIfNeeded()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    randomButton.addTarget(
      self,
      action: #selector(randomButtonClick),
      for: .touchUpInside)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func updateViewConstraints() {
    if !viewReady {
      viewReady = true
      let guide = view.safeAreaLayoutGuide

      NSLayoutConstraint.activate([
        randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        randomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        navigationBar.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        bottomBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        bottomBar.heightAnchor.constraint(equalToConstant: 44)
      ])
    }
    super.updateViewConstraints()
  }

  @objc private func randomButtonClick() {
    self.radialDismiss(fadeColor: UIColor.blue, delay: circularAnimationDelay)
  }

}
