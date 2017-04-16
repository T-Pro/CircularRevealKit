//
//  FirstViewControllerContraints.swift
//  CircularRevealKit
//
//  Created by Pedro Paulo de Amorim on 16/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension FirstViewController {
  
  func configTableViewConstraints() {
    let contraints = [
      NSLayoutConstraint(
        item: view,
        attribute: .top,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .top,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .bottom,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view,
        attribute: .left,
        relatedBy: .equal,
        toItem: tableView,
        attribute: .left,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view,
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
        item: view,
        attribute: .top,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .top,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .bottom,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view,
        attribute: .left,
        relatedBy: .equal,
        toItem: stubView,
        attribute: .left,
        multiplier: 1,
        constant: 0),
      NSLayoutConstraint(
        item: view,
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
