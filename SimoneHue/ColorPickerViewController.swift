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
    @IBOutlet weak var horizontalAlphaPicker: SwiftHUEColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        horizontalColorPicker.delegate = self
        horizontalColorPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Color
        
        horizontalSaturationPicker.delegate = self
        horizontalSaturationPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Saturation
        
        horizontalBrightnessPicker.delegate = self
        horizontalBrightnessPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.Brightness
        
        horizontalAlphaPicker.delegate = self
        horizontalAlphaPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalAlphaPicker.type = SwiftHUEColorPicker.PickerType.Alpha
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SwiftHUEColorPickerDelegate
    
    func valuePicked(color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        colorView.backgroundColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.Color:
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color

            break
        case SwiftHUEColorPicker.PickerType.Saturation:
            horizontalColorPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color

            break
        case SwiftHUEColorPicker.PickerType.Brightness:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color

            break
        case SwiftHUEColorPicker.PickerType.Alpha:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            break
        }
    }
}
