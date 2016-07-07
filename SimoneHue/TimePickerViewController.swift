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
    
    private var alarmTime = String()
    private var alarmTimeChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatePicker()
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDatePicker() {
          let schedule = Light.shared.cache.schedules["7"] as! PHSchedule
          datePicker.setDate(schedule.date, animated: false)
    }
    
    @IBAction func alarmTimeChanged(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        alarmTime = timeFormatter.stringFromDate(datePicker.date)
        alarmTimeChanged = true
    }
    
    @IBAction func saveButtonSelected(sender: UIBarButtonItem) {
        var alarmInt = alarmTime.componentsSeparatedByString(":")
        if alarmTimeChanged {
            Light.shared.setAlarm(Int(alarmInt[0])!, minute: Int(alarmInt[1])!)
        }
        navigationController!.popViewControllerAnimated(true)
    }
    
}
