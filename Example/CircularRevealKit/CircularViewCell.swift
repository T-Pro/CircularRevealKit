//
// Copyright (c) 2019 T-Pro
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
    view.text = "Not ready"
    view.textColor = UIColor.white
    view.isHidden = false
    return view
  }()

//  internal lazy var detailView: UIView = {
//    let view = UIView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.backgroundColor = UIColor.black
//    view.isHidden = true
//    return view
//  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(cardImageView)
    addSubview(titleLabel)
    updateConstraintsIfNeeded()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func loadImage(named: String, disabled: Bool) {
    cardImageView.contentMode = UIView.ContentMode.scaleAspectFill
    cardImageView.center = imageView?.superview?.center ?? CGPoint.zero
    cardImageView.image = UIImage(named: named)
    titleLabel.isHidden = !disabled
    cardImageView.alpha = disabled ? 0.1 : 1.0
    backgroundColor = disabled ? UIColor.black : UIColor.white
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
    let contraints = [
      NSLayoutConstraint(
        item: self,
        attribute: .top,
        relatedBy: .equal,
        toItem: cardImageView,
        attribute: .top,
        multiplier: 1,
        constant: -8),
      NSLayoutConstraint(
        item: self,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: cardImageView,
        attribute: .bottom,
        multiplier: 1,
        constant: 8),
      NSLayoutConstraint(
        item: self,
        attribute: .left,
        relatedBy: .equal,
        toItem: cardImageView,
        attribute: .left,
        multiplier: 1,
        constant: -8),
      NSLayoutConstraint(
        item: self,
        attribute: .right,
        relatedBy: .equal,
        toItem: cardImageView,
        attribute: .right,
        multiplier: 1,
        constant: 8)
    ]
    addConstraints(contraints)
  }

  func configTitleConstraints() {
    let contraints = [
      NSLayoutConstraint(
        item: self,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: titleLabel,
        attribute: .centerX,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: self,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: titleLabel,
        attribute: .centerY,
        multiplier: 1,
        constant: 0)
    ]
    addConstraints(contraints)
  }

}
