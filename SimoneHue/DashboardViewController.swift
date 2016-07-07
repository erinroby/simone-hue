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
    @IBOutlet weak var wakeButton: UIButton!
    @IBOutlet weak var alarmTime: UILabel!
    
    let grey = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
    var currentColor = UIColor()
    
    var isLightOn = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableHeartbeat()
        self.currentColor = Light.shared.readCurrentColorState()
        self.alarmView.backgroundColor = self.currentColor
        self.isLightOn = Light.shared.isOn()
        if self.isLightOn {
            self.wakeButton.setTitle("WAKE OFF", forState: .Normal)
        } else {
            self.wakeButton.setTitle("WAKE ON", forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Light.shared.stateUpdated {
            self.currentColor = Light.shared.readCurrentColorState()
            self.alarmView.backgroundColor = self.currentColor
            Light.shared.stateUpdated = false
        }
        self.setupAppearance()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
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
        
        if self.isLightOn != Light.shared.isOn() {
            Light.shared.toggle()
        }
        
        if self.isLightOn {
            self.lightView.backgroundColor = self.currentColor
            Light.shared.setLightColor(self.currentColor)
        } else {
            self.lightView.backgroundColor = grey
        }
        
        self.alarmTime.text = Light.shared.getAlarmTime()
        
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
    
    // MARK: Notification handler methods required by SDK.
    
    func localConnection() {
    }
    
    func noLocalConnection() {
    }
    
    func notAuthenticated() {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.doAuthentication()
        }
    }
    
    func authenticationSuccess() {
        Light.shared.phHueSdk.enableLocalConnection()
    }
    
    func authenticationFailed() {
    }
    
    func noLocalBridge() {
    }
    
    func buttonNotPressed() {
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
    
    func setLightView() {
        // if time == alarmTime, change background color?
    }
    
    func timePickerViewControllerDidFinish() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func wakeButtonSelected(sender: UIButton) {
        self.isLightOn = Light.shared.toggle()
        self.setupAppearance()
        if self.isLightOn {
            self.wakeButton.setTitle("WAKE OFF", forState: .Normal)
        } else {
            self.wakeButton.setTitle("WAKE ON", forState: .Normal)
        }
    }
}

