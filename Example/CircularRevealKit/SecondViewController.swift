//
//  SecondViewController.swift
//  CircularRevealKit
//
//  Created by Pedro Paulo de Amorim on 14/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CircularRevealKit

class SecondViewController: UIViewController {
  
  override func loadView() {
    super.loadView()
    title = "SecondViewController"
    view.backgroundColor = UIColor.black
    setupBackButton()
  }

}
