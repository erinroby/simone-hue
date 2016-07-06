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
    
    var currentLightState = PHLightState()
    let alarmLightState = PHLightState()
    let testLightState = PHLightState()
    
    var alarmColor = UIColor.whiteColor()
    
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
            testLightState.on = true
            self.setLightState(light.identifier, state: testLightState)
        }
    }
    
    // refactor into a toggle as in the docs.
    func setOnState() {
        for light in Light.shared.cache!.lights!.values {
            self.currentLightState.on = false
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
    
    func readCurrentColorState() -> UIColor {
        let light = self.cache.lights["1"] as! PHLight
        let lightState = light.lightState
        let x = lightState.x as CGFloat
        let y = lightState.y as CGFloat
        let xy = CGPointMake(x, y)
        let color: UIColor = PHUtilities.colorFromXY(xy, forModel: "LCT007")
        return color
    }
    
//    func readAlarmColorState() -> UIColor {
//        let schedule = self.cache.schedules["7"] as! PHSchedule
//        
//        let x = alarmState.x as CGFloat
//        let y = alarmState.y as CGFloat
//        let xy = CGPointMake(x, y)
//        let color: UIColor = PHUtilities.colorFromXY(xy, forModel: "LCT007")
//        return color
//
//    }
    
    func getAlarmTime() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        let schedule = self.cache.schedules["7"] as! PHSchedule
        let time = formatter.stringFromDate(schedule.date)

        return time
    }
    
    func getNSDate() -> NSDate {
        let schedule = self.cache.schedules["7"] as! PHSchedule
        return schedule.date
    }
    
    func setAlarm(hour: Int, minute: Int) {
        let newSchedule = PHSchedule()
        
        newSchedule.name = "Simone's Alarm"
        newSchedule.localTime = false
        newSchedule.state = alarmLightState
        newSchedule.lightIdentifier = "1"
        newSchedule.identifier = "7"
        newSchedule.recurringDays.rawValue = 127
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let date = NSDate()
        let components = calendar!.components([.Era, .Year, .Month, .Day], fromDate: date)
        
        components.hour = hour
        components.minute = minute
        components.second = 0

        newSchedule.date = calendar!.dateFromComponents(components)

        self.bridgeSendAPI.updateScheduleWithSchedule(newSchedule) { (error) in
        }
    }
    
    func saveAlarmState(x: CGFloat, y: CGFloat, bri: Int) {
        for light in Light.shared.cache!.lights!.values {
            alarmLightState.x = x
            alarmLightState.y = y
            alarmLightState.brightness = bri
            alarmLightState.on = true
            self.setLightState(light.identifier, state: alarmLightState)
            print(self.cache.schedules["7"])
        }
    }
    
    //

}