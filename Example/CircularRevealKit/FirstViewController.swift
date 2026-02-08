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

let CIRCULAR_ANIMATION_CELL: String = "Cell"
let CIRCULAR_ANIMATION_DELAY: TimeInterval = 0.5

class FirstViewController: UIViewController {

  internal var viewReady = false
  internal var cellHeight: CGFloat = 0.0

  internal lazy var tableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(CircularViewCell.self, forCellReuseIdentifier: CIRCULAR_ANIMATION_CELL)
    view.tableFooterView = UIView()
    return view
  }()

  internal lazy var stubView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black
    return view
  }()

  internal lazy var logoView: UIView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black
    view.image = UIImage(named: "lib_icon")
    return view
  }()

  internal let images = ["view_controller", "view_cell"]

  deinit {
    tableView.delegate = nil
    tableView.dataSource = nil
  }

  override func loadView() {
    super.loadView()
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = UIColor.white
    view.addSubview(tableView)
    view.addSubview(stubView)
    stubView.addSubview(logoView)
    view.updateConstraintsIfNeeded()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configTableView()
    dismissStubView()
  }

  override func updateViewConstraints() {
    if !viewReady {
      viewReady = true
      configTableViewConstraints()
      configStubViewConstraints()
      configLogoViewConstraints()
    }
    super.updateViewConstraints()
  }

  private func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }

  private func dismissStubView() {

    let viewControllerSize = view.frame.size
    let width = viewControllerSize.width
    let height = viewControllerSize.height
    let rect = CGRect(
      origin: CGPoint(
        x: width/2,
        y: height/2),
      size: CGSize(
        width: 0,
        height: 0))
    
    stubView.drawAnimatedCircularMask(
      startFrame: rect,
      duration: 0.33,
      revealType: RevealType.unreveal) { [weak self] in
        self?.stubView.isHidden = true
    }

  }

  private func show() {
    let vc = SecondViewController()
    vc.modalPresentationStyle = .overCurrentContext
    self.radialPresent(viewController: vc, fadeColor: UIColor.blue, delay: CIRCULAR_ANIMATION_DELAY)
  }

}

extension FirstViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0:
      self.show()
    case 1:
      self.present(SecondViewController(), animated: true)
      default: break
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if cellHeight == 0.0 {
      cellHeight = (view.frame.width * 9)/16
    }
    return cellHeight
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? CircularViewCell {
      cell.loadImage(named: images[indexPath.row], disabled: indexPath.row != 0)
    }
  }

}

extension FirstViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CIRCULAR_ANIMATION_CELL, for: indexPath)
  }

}
