//
//  Light.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/1/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import Foundation

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
    

    
    let maxHue = 65535
    let maxDim = 254
    
    func startUp() {
        phHueSdk.enableLogging(true)
        phHueSdk.startUpSDK()
    }
    
    enum State {
        case On
        case Bri
        case Sat
        case Hue
    }
    
    // TODO: refactor light state menthods from controller to here.
    func updateState() {
        
    }
    
    // TODO: write methods for scheduling here.
}