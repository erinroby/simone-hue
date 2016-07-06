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

    var schedule = PHSchedule()
    
    func startUp() {
        phHueSdk.enableLogging(true)
        phHueSdk.startUpSDK()
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
        let newSchedule = PHSchedule()
        newSchedule.name = "Simone's Alarm"
        newSchedule.localTime = false
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let date = NSDate()
        let components = calendar!.components([.Era, .Year, .Month, .Day], fromDate: date)
        
        components.hour = hour
        components.minute = minute
        components.second = 0

        newSchedule.date = calendar!.dateFromComponents(components)
        alarmLightState.on = false
        newSchedule.state = alarmLightState
        newSchedule.groupIdentifier = "0"
        
        self.bridgeSendAPI.createSchedule(newSchedule) { (error) in
            print("in create schedule")
        }
    }
    
    func updateAlarm() {
        
    }
    
    func readAlarm() {
        
    }
}