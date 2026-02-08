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

class CircularViewCell: UITableViewCell {

  var viewReady = false

  internal lazy var cardImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = UIColor.white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 8
    imageView.roundCornersForAspectFit(radius: 8)
    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.masksToBounds = true
    return imageView
  }()

  internal lazy var titleLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textColor = UIColor.white
    view.isHidden = true
    return view
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(cardImageView)
    addSubview(titleLabel)
    updateConstraintsIfNeeded()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func loadImage(named: String, disabled: Bool = false) {
    cardImageView.contentMode = UIView.ContentMode.scaleAspectFill
    cardImageView.center = imageView?.superview?.center ?? CGPoint.zero
    cardImageView.image = UIImage(named: named)
    titleLabel.isHidden = true
    cardImageView.alpha = disabled ? 0.1 : 1.0
    backgroundColor = disabled ? UIColor.black : UIColor.white
  }

  func showSwiftUILabel(enabled: Bool) {
    cardImageView.image = nil
    cardImageView.backgroundColor = UIColor.systemIndigo
    cardImageView.alpha = enabled ? 1.0 : 0.3
    titleLabel.isHidden = false
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    titleLabel.textColor = UIColor.white
    if enabled {
      titleLabel.text = "SwiftUI Demo"
      backgroundColor = UIColor.systemIndigo
    } else {
      titleLabel.text = "SwiftUI Demo (Requires iOS 15+)"
      backgroundColor = UIColor.darkGray
    }
  }

  override func updateConstraints() {
    if !viewReady {
      viewReady = true
      configTableViewConstraints()
      configTitleConstraints()
    }
    super.updateConstraints()
  }

  func configTableViewConstraints() {
    NSLayoutConstraint.activate([
      cardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      cardImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      cardImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }

  func configTitleConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

}
