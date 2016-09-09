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
    
    var light = PHLight()
    var schedule = PHSchedule()
    
    var stateUpdated = false
    
    func startUp() {
        phHueSdk.enableLogging(true)
        phHueSdk.startUpSDK()
        light = self.cache.lights["1"] as! PHLight
        schedule = self.cache.schedules["7"] as! PHSchedule
        phHueSdk.setLocalHeartbeatInterval(0.5, forResourceType: RESOURCES_LIGHTS)
    }
    
    func getColorValues(color: UIColor) -> (x: CGFloat, y: CGFloat, bri: Int) {
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
            self.light.lightState.x = x
            self.light.lightState.y = y
            self.light.lightState.brightness = bri
            self.light.lightState.on = true
            self.setLightState(light.identifier, state: self.light.lightState)
        }
    }
    
    func setLightColor(color: UIColor) {
        let xyColor = getColorValues(color)
        testColor(xyColor.x, y: xyColor.y, bri: xyColor.bri)
    }
    
    func isOn() -> Bool {
        return self.light.lightState.on == true
    }
    
    func toggle() -> Bool {
        if self.light.lightState.on == true {
            self.light.lightState.on = false
        } else {
            self.light.lightState.on = true
        }
        self.setLightState(self.light.identifier, state: self.light.lightState)
        return self.light.lightState.on == true
    }
    
    func turnLightOn() {
        self.light.lightState.on = true
        self.setLightState(self.light.identifier, state: self.light.lightState)
    }
    
    func setLightState(light: String , state: PHLightState) {
        Light.shared.bridgeSendAPI.updateLightStateForId(light, withLightState: state) { (errors: [AnyObject]!) -> () in
            if errors != nil {
                print(errors)
            }
        }
    }
    
    func readCurrentColorState() -> UIColor {
        let lightState = self.light.lightState
        let x = lightState.x as CGFloat
        let y = lightState.y as CGFloat
        let xy = CGPointMake(x, y)
        let color: UIColor = PHUtilities.colorFromXY(xy, forModel: "LCT007")
        return color
    }
    
    func getAlarmTime() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        let time = formatter.stringFromDate(schedule.date)
        return time
    }
    
    func setAlarm(hour: Int, minute: Int) {
        self.schedule.name = "Simone's Alarm"
        self.schedule.localTime = false
        
        let alarmLightState = PHLightState()
        alarmLightState.on = true
        
        self.schedule.state = alarmLightState
        self.schedule.lightIdentifier = self.light.identifier
        self.schedule.identifier = "7"
        self.schedule.recurringDays.rawValue = 127
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let date = NSDate()
        let components = calendar!.components([.Era, .Year, .Month, .Day], fromDate: date)
        
        components.hour = hour
        components.minute = minute
        components.second = 0

        self.schedule.date = calendar!.dateFromComponents(components)

        self.bridgeSendAPI.updateScheduleWithSchedule(self.schedule) { (error) in
        }
    }
}
