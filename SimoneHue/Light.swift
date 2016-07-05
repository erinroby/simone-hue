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
    let schedule = PHSchedule()
    
    func startUp() {
        phHueSdk.enableLogging(true)
        phHueSdk.startUpSDK()
        schedule.localTime = true
        schedule.name = "Simone"
    }
    
    enum State {
        case On(Bool)
        case Bri(Int)
        case X(CGFloat)
        case Y(CGFloat)
    }
    
    // Assumes one light.
    
    func setLightState() {
        
    }
    
    func readLightState() {
        
    }
    
    // Assumes one alarm recurring:
    
    enum CalendarUnit {
        case Hour
        case Minute
        case AM
        case PM
    }
    
    func setAlarm(hour: Int, minute: Int) {
        let alarmLightState = PHLightState()
        let components = NSDateComponents()
        
        components.hour = 14
        components.minute = 0
        
        if let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian) {
            self.schedule.date = calendar.dateFromComponents(components)
        }
        
        // The docs say set the alarmStateHere we want here???
        self.schedule.state = alarmLightState
        self.bridgeSendAPI.createSchedule(schedule) { (error) in
            // handle the error!
        }
        
    }
    
    func updateAlarm() {
        
    }

    func readAlarm() {
        
    }
}