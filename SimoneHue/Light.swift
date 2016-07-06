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
    
    let currentLightState = PHLightState()
    let alarmLightState = PHLightState()
    let testLightState = PHLightState()

    let schedule = PHSchedule()
    
    func startUp() {
        phHueSdk.enableLogging(true)
        phHueSdk.startUpSDK()
        schedule.localTime = true
    }
    
    private func getColorValues(color: UIColor) -> (x: CGFloat, y: CGFloat, bri: Int) {
        let xyColor = PHUtilities.calculateXY(color, forModel: "LCT007")
        var hue = CGFloat()
        var sat = CGFloat()
        var bri = CGFloat()
        var alpha = CGFloat()
        
        color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
        let brightnessValue = Int(max(0, min(100, Int(bri * 100))))
        
        return (xyColor.x, y: xyColor.y, brightnessValue)
    }
    
    func testColor(x: CGFloat, y: CGFloat, bri: Int) {
        for light in Light.shared.cache!.lights!.values {
            testLightState.x = x
            testLightState.y = y
            testLightState.brightness = bri
            
            self.setLightState(light.identifier, state: testLightState)
        }
    }
    
    // refactor into a toggle as in the docs.
    func setOnState() {
        for light in Light.shared.cache!.lights!.values {
            self.currentLightState.on = true
            self.setLightState(light.identifier, state: currentLightState)
        }
    }
    
    func setLightState(light: String , state: PHLightState) {
        Light.shared.bridgeSendAPI.updateLightStateForId(light, withLightState: state) { (errors: [AnyObject]!) -> () in
            if errors != nil {
                print(errors)
            }
        }
    }
    
    // I need this funciton to return a color in the current state so that I can reflect that state as well as the alarm color state in my colorView on the dashboard.
    func readColorState(state: PHLightState) -> UIColor {
        let color = UIColor()
        return color
    }
    
    // Assumes one possible recurring alarm:
    
    func setAlarm(hour: Int, minute: Int) {
        let components = NSDateComponents()
        
        components.hour = hour
        components.minute = minute
        // add days of the week here.
        
        if let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian) {
            self.schedule.date = calendar.dateFromComponents(components)
        }
        
        self.schedule.state = alarmLightState
        self.schedule.identifier = "Simone"
        self.bridgeSendAPI.createSchedule(schedule) { (error) in
            // handle the errors!
        }
        
    }
    
    func updateAlarm() {
        
    }
    
    func readAlarm() {
        
    }
}