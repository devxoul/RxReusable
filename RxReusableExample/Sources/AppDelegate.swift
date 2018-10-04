//
//  AppDelegate.swift
//  Example
//
//  Created by Suyeol Jeon on 30/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxReusable
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UITableViewCell.initializer
    UITableView.initializer
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = UINavigationController(rootViewController: ViewController())
    window.makeKeyAndVisible()
    self.window = window
    return true
  }

}
