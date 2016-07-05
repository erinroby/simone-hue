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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableHeartbeat()
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
        print("localConnection")
        // TODO: If connection is successful, this method will be called every heartbeat interval.
        // Update UI to show connected state and cached data
    }
    
    func noLocalConnection() {
        print("noLocalConnection")
        // TODO: Inform the user that there are connectivity issues and to please check network connection.
    }
    
    func notAuthenticated() {
        print("notAuthenticated")
        // TODO: We are not authenticated so start the authentication/pushlink process.
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.doAuthentication()
        }
    }
    
    func authenticationSuccess() {
        print("authenticationSuccess")
        Light.shared.phHueSdk.enableLocalConnection()
        // TODO: Dismiss the pushlinkViewController here...cause we're good to go!
        // TODO: enable a heartbeat to connect to this bridge.
    }
    
    func authenticationFailed() {
        print("authenticationFailed")
        // TODO: Inform the user about this and ask the user to try again.
    }
    
    func noLocalBridge() {
        print("noLocalBridge")
        // TODO: Coding error. Be sure that code has handled phHueSdk.setBridgeToUseWithIpAddress(macAddress: String) has been called before beginning pushlink process
    }
    
    func buttonNotPressed() {
        print("buttonNotPressed")
        // TODO: Type of NSNotification. Fetch percentage of time elepsed from notification. Dict: NSDictionary = notification.userInfo
        // progressPercentage: NSNumber = dictionary objectForKey(progressPercentage)
        // Update UI says documentation.
    }
    
    func doAuthentication() {
        print("doAuthentication")
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
    
    // MARK: Light State Methods - TODO: refactor to model.
    
    @IBAction func offButtonSelected(sender: UIButton) {
        
        for light in Light.shared.cache!.lights!.values {
            
            Light.shared.lightState.on = false
            
            Light.shared.bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: Light.shared.lightState) { (errors: [AnyObject]!) -> () in
                if errors != nil {
                    print(errors)
                }
            }
        }
    }
    
    @IBAction func onButtonSelected(sender: UIButton) {
        
        for light in Light.shared.cache!.lights!.values {
            
            Light.shared.lightState.brightness = 100
            Light.shared.lightState.saturation = 254
            Light.shared.lightState.on = true
            
            Light.shared.bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: Light.shared.lightState) { (errors: [AnyObject]!) -> () in
                if errors != nil {
                    print(errors)
                }
                print(Light.shared.lightState)
            }
        }
    }
    
}

