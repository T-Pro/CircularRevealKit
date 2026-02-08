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

extension UIImageView {

  func roundCornersForAspectFit(radius: CGFloat) {
    if let image = self.image {
      // calculate drawingRect
      let boundsScale = self.bounds.size.width / self.bounds.size.height
      let imageScale = image.size.width / image.size.height
      var drawingRect: CGRect = self.bounds
      if boundsScale > imageScale {
        drawingRect.size.width =  drawingRect.size.height * imageScale
        drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
      } else {
        drawingRect.size.height = drawingRect.size.width / imageScale
        drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
      }
      let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      self.layer.mask = mask
    }
  }

}
