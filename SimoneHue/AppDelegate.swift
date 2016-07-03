//
//  AppDelegate.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var dashboardViewController: DashboardViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
    // self.checkBridgeAuthStatus()
        navigationController = window!.rootViewController as? UINavigationController
        return true
    }
    
    func checkBridgeAuthStatus() {
    // TODO: Check model bridge cache for auth status to see what view to show...use a do / catch here?
    // I'd like to ask the model what statue it is in so I know what view to present to the user. 
    }
    
    func presentPushlinkViewController() {
        // TODO: Present the authorization views if necessary.
    }
}

