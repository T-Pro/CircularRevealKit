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

import Foundation
import UIKit

extension FirstViewController {

  func configTableViewConstraints() {
    let contraints = [
      NSLayoutConstraint(
        item: view!,
        attribute: .top,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .top,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view!,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .bottom,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view!,
        attribute: .left,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .left,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view!,
        attribute: .right,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .right,
        multiplier: 1,
        constant: 0)]
    view.addConstraints(contraints)
  }

  func configStubViewConstraints() {
    let contraints = [
      NSLayoutConstraint(
        item: view!,
        attribute: .top,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .top,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view!,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .bottom,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view!,
        attribute: .left,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .left,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view!,
        attribute: .right,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .right,
        multiplier: 1,
        constant: 0)]
    view.addConstraints(contraints)
  }

  func configLogoViewConstraints() {
    let contraints = [
      NSLayoutConstraint(
        item: logoView,
        attribute: .width,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: 115),
      NSLayoutConstraint(
        item: logoView,
        attribute: .height,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: 115),
      NSLayoutConstraint(
        item: stubView,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: logoView,
        attribute: .centerX,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: stubView,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: logoView,
        attribute: .centerY,
        multiplier: 1,
        constant: 0)
      ]
    view.addConstraints(contraints)
  }

}
