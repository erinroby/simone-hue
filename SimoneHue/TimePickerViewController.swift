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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func alarmTimeChanged(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let strTime = timeFormatter.stringFromDate(datePicker.date)
        alarmTime = strTime
    }
    
    @IBAction func saveButtonSelected(sender: UIBarButtonItem) {
        // Tell the light to update it's schedule!
        // Dismiss this view.
    
    }
    
}
