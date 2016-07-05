//
//  PushlinkViewController.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

protocol PHBridgePushLinkViewControllerDelegate {
    func pushlinkSuccess()
    func pushlinkFailed(error: PHError)
}

class PushlinkViewController: UIViewController {
    var phHueSdk: PHHueSDK!
    var delegate: PHBridgePushLinkViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushLinkSuccess() {
        // Start here to dismiss the view...
    }
    
    func pushLinkFailed(error: PHError) {
        // Start here to handle errors...
    }
    
    func startPushLinking() {
        Light.shared.phHueSdk.startPushlinkAuthentication()
    }

}
