//
//  Light.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

class Light: NSObject {
    static let shared = Light()
    
    private override init() {
        super.init()
        self.startUp()
    }
    
    let phHueSdk: PHHueSDK = PHHueSDK()
    let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
    let bridgeSendAPI = PHBridgeSendAPI()
    let lightState = PHLightState()
    
    func startUp() {
        phHueSdk.enableLogging(true)
        phHueSdk.startUpSDK()
    }
}