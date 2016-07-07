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
    
    private var testLightColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColorPicker()
        self.setupAppearance()
    }
    
    private func setupColorPicker() {
        horizontalColorPicker.delegate = self
        horizontalColorPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Color
        
        horizontalSaturationPicker.delegate = self
        horizontalSaturationPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Saturation
        
        horizontalBrightnessPicker.delegate = self
        horizontalBrightnessPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.Brightness
    }
    
    private func setupAppearance() {
//        self.colorView.backgroundColor
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
        let lightColor = self.getColorValues(testLightColor)
        Light.shared.testColor(lightColor.x, y: lightColor.y, bri: lightColor.bri)
    }
    
    @IBAction func saveButtonSelected(sender: UIBarButtonItem) {
        // pass testLightColor as UIColor to dashboardViewController for the alarmView.backgroundColor
        Light.shared.setLightColor(testLightColor)
        Light.shared.stateUpdated = true
        navigationController!.popViewControllerAnimated(true)
    }


}
