//
//  TimePickerViewController.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var alarmTime = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        Light.shared.readAlarm()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSchedules() {
//        print(Light.shared.cache.schedules)
//   
//        print(Light.shared.cache.schedules.count) // maybe I could say if the schedules.count > 0 do an update on that identifier...otherwise, make a new alarm
//        for schedule in Light.shared.cache.schedules {
//            print(schedule)
//        }
    }
    
    @IBAction func alarmTimeChanged(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        alarmTime = timeFormatter.stringFromDate(datePicker.date)
    }
    
    @IBAction func saveButtonSelected(sender: UIBarButtonItem) {
        var alarmInt = alarmTime.componentsSeparatedByString(":")
        Light.shared.setAlarm(Int(alarmInt[0])!, minute: Int(alarmInt[1])!)
        navigationController!.popViewControllerAnimated(true)
    }
    
}
