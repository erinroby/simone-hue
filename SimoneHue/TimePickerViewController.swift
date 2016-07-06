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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func alarmTimeChanged(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        alarmTime = timeFormatter.stringFromDate(datePicker.date)
    }
    
    @IBAction func saveButtonSelected(sender: UIBarButtonItem) {
        var alarmInt = alarmTime.componentsSeparatedByString(":")
        Light.shared.setAlarm(Int(alarmInt[0])!, minute: Int(alarmInt[1])!)
    }
    
}
