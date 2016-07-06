//
//  DashboardViewController.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    let notificationManager = PHNotificationManager.defaultManager()
    
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var lightView: UIView!
    @IBOutlet weak var alarmView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableHeartbeat()
        self.setupAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func enableHeartbeat() {
        if Light.shared.cache?.bridgeConfiguration?.ipaddress != nil {
            self.configureBridge(Light.shared.cache.bridgeConfiguration.bridgeId, ipAddress: Light.shared.cache.bridgeConfiguration.ipaddress)
        } else {
            self.searchForBridge()
        }
    }
    
    func disableHeartbeat() {
        Light.shared.phHueSdk.disableLocalConnection()
    }
    
    func setupAppearance() {
        self.lightView.layer.cornerRadius = 75
        self.alarmView.layer.cornerRadius = 20
        self.lightView.backgroundColor = Light.shared.readColor()
        navigationController?.navigationBarHidden = true

    }
    
    func searchForBridge() {
        self.disableHeartbeat()
        let bridgeSearch = PHBridgeSearching(upnpSearch: true, andPortalSearch: true, andIpAdressSearch: true)
        bridgeSearch.startSearchWithCompletionHandler { (bridgesFound: [NSObject : AnyObject]!) in
            if (bridgesFound != nil) {
                for (key, value) in bridgesFound {
                    self.configureBridge(key as! String, ipAddress: value as! String)
                }
            } else {
                print("Light.searchForBridge: No bridge found!")
            }
        }
    }
    
    func configureBridge(bridgeId: String, ipAddress: String) {
        Light.shared.phHueSdk.setBridgeToUseWithId(bridgeId, ipAddress: ipAddress)
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.registerNotifications()
            Light.shared.phHueSdk.enableLocalConnection()
        }
    }
    
    func registerNotifications() {
        // Pushlink Notifications
        notificationManager.registerObject(self, withSelector: #selector(self.authenticationSuccess), forNotification: PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION)
        notificationManager.registerObject(self, withSelector: #selector(self.authenticationFailed), forNotification: PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION)
        notificationManager.registerObject(self, withSelector: #selector(self.noLocalConnection), forNotification: PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION)
        notificationManager.registerObject(self, withSelector: #selector(self.noLocalBridge), forNotification: PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION)
        notificationManager.registerObject(self, withSelector: #selector(self.buttonNotPressed), forNotification: PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION)
        
        // Bridge Connection Notifications
        notificationManager.registerObject(self, withSelector: #selector(self.localConnection), forNotification: LOCAL_CONNECTION_NOTIFICATION)
        notificationManager.registerObject(self, withSelector: #selector(self.noLocalConnection), forNotification: NO_LOCAL_CONNECTION_NOTIFICATION)
        notificationManager.registerObject(self, withSelector: #selector(self.notAuthenticated), forNotification: NO_LOCAL_AUTHENTICATION_NOTIFICATION)
    }
    
    // MARK: Notification handler methods. if this subclass isn't inheriting from NSObject, I need @objc before each func declaration.
    
    func localConnection() {
        // TODO: If connection is successful, this method will be called every heartbeat interval.
        // Update UI to show connected state and cached data
    }
    
    func noLocalConnection() {
        // TODO: Inform the user that there are connectivity issues and to please check network connection.
    }
    
    func notAuthenticated() {
        // TODO: We are not authenticated so start the authentication/pushlink process.
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.doAuthentication()
        }
    }
    
    func authenticationSuccess() {
        Light.shared.phHueSdk.enableLocalConnection()
        // TODO: Dismiss the pushlinkViewController here...cause we're good to go!
        // TODO: enable a heartbeat to connect to this bridge.
    }
    
    func authenticationFailed() {
        // TODO: Inform the user about this and ask the user to try again.
    }
    
    func noLocalBridge() {
        // TODO: Coding error. Be sure that code has handled phHueSdk.setBridgeToUseWithIpAddress(macAddress: String) has been called before beginning pushlink process
    }
    
    func buttonNotPressed() {
        // TODO: Type of NSNotification. Fetch percentage of time elepsed from notification. Dict: NSDictionary = notification.userInfo
        // progressPercentage: NSNumber = dictionary objectForKey(progressPercentage)
        // Update UI says documentation.
    }
    
    func doAuthentication() {
        self.disableHeartbeat()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pushlinkViewController = storyboard.instantiateViewControllerWithIdentifier("PushlinkViewController") as! PushlinkViewController
        navigationController?.presentViewController(
            pushlinkViewController,
            animated: true,
            completion: {(bool) in
                pushlinkViewController.startPushLinking()
        })
    }
    
    func rgbConvert() {
        // + (UIColor *)colorFromXY:(CGPoint)xy andBrightness:(float)brightness forModel:(NSString*)model
    }
    
    func timePickerViewControllerDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func wakeButtonSelected(sender: UIButton) {
        Light.shared.setOnState()
        // update title to WAKE OFF!
    }
    
}

