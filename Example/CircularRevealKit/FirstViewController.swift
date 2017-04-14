//
//  ViewController.swift
//  CircularRevealKit
//
//  Created by ppamorim on 04/14/2017.
//  Copyright (c) 2017 ppamorim. All rights reserved.
//

import UIKit
import CircularRevealKit

class FirstViewController: UIViewController {
  
  var viewReady = false

  lazy var randomButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle("Click me", for: UIControlState.normal)
    view.backgroundColor = UIColor.black
    return view
  }()
  
  override func loadView() {
    super.loadView()
    title = "FirstViewController"
    setupBackButton()
    view.backgroundColor = UIColor.white
    view.addSubview(randomButton)
    view.updateConstraintsIfNeeded()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    randomButton.addTarget(self, action: #selector(randomButtonClick), for: .touchUpInside)
  }
  
  override func updateViewConstraints() {
    if !viewReady {
      viewReady = true
      view.addConstraint(
        NSLayoutConstraint(
          item: view,
          attribute: .centerX,
          relatedBy: .equal,
          toItem: randomButton,
          attribute: .centerX,
          multiplier: 1,
          constant: 0))
      view.addConstraint(
        NSLayoutConstraint(
          item: view,
          attribute: .centerY,
          relatedBy: .equal,
          toItem: randomButton,
          attribute: .centerY,
          multiplier: 1,
          constant: 0))
    }
    super.updateViewConstraints()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @objc private func randomButtonClick() {
    self.navigationController?.radialPushViewController(SecondViewController())
  }
  
}

