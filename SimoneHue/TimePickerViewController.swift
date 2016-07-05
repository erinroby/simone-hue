//
//  TimePickerViewController.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAlarm() {
        for light in Light.shared.cache!.lights!.values {
            
            let newSchedule = PHSchedule()
            print(newSchedule)
            newSchedule.name = "test schedule"
            newSchedule.localTime = true
            
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
