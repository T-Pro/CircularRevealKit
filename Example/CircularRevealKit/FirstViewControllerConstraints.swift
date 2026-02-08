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

extension FirstViewController {

  func configTableViewConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  func configStubViewConstraints() {
    NSLayoutConstraint.activate([
      stubView.topAnchor.constraint(equalTo: view.topAnchor),
      stubView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  func configLogoViewConstraints() {
    NSLayoutConstraint.activate([
      logoView.widthAnchor.constraint(equalToConstant: 115),
      logoView.heightAnchor.constraint(equalToConstant: 115),
      logoView.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
      logoView.centerYAnchor.constraint(equalTo: stubView.centerYAnchor)
    ])
  }

}
