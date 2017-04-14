//
//  AppDelegate.swift
//  CircularRevealKit
//
//  Created by ppamorim on 04/14/2017.
//  Copyright (c) 2017 ppamorim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UINavigationController(rootViewController: FirstViewController())
    self.window?.makeKeyAndVisible()
    return true
  }

}

