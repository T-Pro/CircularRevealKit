//
//  UIImageViewExtension.swift
//  CircularRevealKit
//
//  Created by Pedro Paulo de Amorim on 16/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIImageView {
  
  func roundCornersForAspectFit(radius: CGFloat) {
    if let image = self.image {
      //calculate drawingRect
      let boundsScale = self.bounds.size.width / self.bounds.size.height
      let imageScale = image.size.width / image.size.height
      var drawingRect : CGRect = self.bounds
      if boundsScale > imageScale {
        drawingRect.size.width =  drawingRect.size.height * imageScale
        drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
      }else{
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
