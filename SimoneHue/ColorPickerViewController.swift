//
//  ColorPickerViewController.swift
//  SimoneHue
//
//  Created by Erin Roby on 7/2/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, SwiftHUEColorPickerDelegate {
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var horizontalColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalSaturationPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalBrightnessPicker: SwiftHUEColorPicker!
    @IBOutlet weak var playButton: UIButton!
    
    private var testLightColor = UIColor()
    private var colorChanged = false
    private var isLightOn = Bool()
    private var alarmColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.setupColorPicker()
    }
    
    private func setupColorPicker() {
        horizontalColorPicker.delegate = self
        horizontalColorPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalColorPicker.type = SwiftHUEColorPicker.PickerType.Color
        horizontalColorPicker.currentColor = self.alarmColor
        
        
        horizontalSaturationPicker.delegate = self
        horizontalSaturationPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Saturation
        horizontalSaturationPicker.currentColor = self.alarmColor
        
        horizontalBrightnessPicker.delegate = self
        horizontalBrightnessPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.Brightness
        horizontalBrightnessPicker.currentColor = self.alarmColor
    }
    
    private func setupAppearance() {
        let grey = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
        
        horizontalColorPicker.cornerRadius = 0
        horizontalColorPicker.labelBackgroundColor = grey
        horizontalColorPicker.labelFontColor = grey
        horizontalSaturationPicker.cornerRadius = 0
        horizontalSaturationPicker.labelBackgroundColor = grey
        horizontalSaturationPicker.labelFontColor = grey
        horizontalBrightnessPicker.cornerRadius = 0
        horizontalBrightnessPicker.labelBackgroundColor = grey
        horizontalBrightnessPicker.labelFontColor = grey
        
        self.colorView.layer.cornerRadius = 75
        self.alarmColor = Light.shared.readCurrentColorState()
        self.colorView.backgroundColor = self.alarmColor
        
        navigationController?.navigationBarHidden = false
    }
    
    // MARK: SwiftHUEColorPickerDelegate
    
    func valuePicked(color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        colorView.backgroundColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.Color:
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            break
            
        case SwiftHUEColorPicker.PickerType.Saturation:
            horizontalColorPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            break
            
        case SwiftHUEColorPicker.PickerType.Brightness:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            break
            
        case SwiftHUEColorPicker.PickerType.Alpha:
            break
            
        }
        
        self.testLightColor = color
        self.colorChanged = true
    }
    
    // MARK: Manage Color Space for HUE
    
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
    
    @IBAction private func playButtonPressed(sender: UIButton) {
        if !self.colorChanged && !Light.shared.isOn() {
            Light.shared.turnLightOn()
        } else {
            let lightColor = self.getColorValues(testLightColor)
            Light.shared.testColor(lightColor.x, y: lightColor.y, bri: lightColor.bri)
        }
    }
    
    @IBAction func saveButtonSelected(sender: UIBarButtonItem) {
        if !self.colorChanged {
            navigationController!.popViewControllerAnimated(true)
        } else {
            Light.shared.setLightColor(testLightColor)
            Light.shared.stateUpdated = true
            navigationController!.popViewControllerAnimated(true)
        }
    }


}
