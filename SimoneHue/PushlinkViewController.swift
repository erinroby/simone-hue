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
    // outlet to progress bar here. @IBOutlet weak var progressView: UIProgressView

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushLinkSuccess() {
        
    }
    
    func pushLinkFailed(error: PHError) {
        
    }
    
    func startPushLinking() {
        print("startPushLinking")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
