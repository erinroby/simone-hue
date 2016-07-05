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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColorPicker()
    }
    
    func setupColorPicker() {
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
    
    // MARK: - SwiftHUEColorPickerDelegate
    
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
        
//        let dim = horizontalBrightnessPicker How to get this value?
        let xyColor = PHUtilities.calculateXY(color, forModel: "LCT007")
        
            self.getHSBA(color)
//            print(color)
        self.getColor(xyColor.x, y: xyColor.y)
        // TODO: Right now only the color and saturation pickers matter. What about the overall brightness/DIM or "bri" in the docs? I'd like a third slider show this and ditch the alpha and brightness here.
    }
    
    func getColor(x: CGFloat, y: CGFloat) {
        for light in Light.shared.cache!.lights!.values {
            
            Light.shared.lightState.x = x
            Light.shared.lightState.y = y
            
            Light.shared.bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: Light.shared.lightState) { (errors: [AnyObject]!) -> () in
                if errors != nil {
                    print(errors)
                }
                // handle errors
            }
        }
    }
    
    
    func getHSBA(color:UIColor) {
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        
        color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
//        
//        let hueValue = Int(max(0, min(360, Float(hue * 360))))
//        let saturationValue = Int(max(0, min(100, Float(sat * 100))))
        let brightnessValue = Int(max(0, min(100, Int(bri * 100))))
        
        for light in Light.shared.cache!.lights!.values {
//            Light.shared.lightState.hue = hueValue
//            Light.shared.lightState.saturation = saturationValue
            Light.shared.lightState.brightness = brightnessValue
            
            Light.shared.bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: Light.shared.lightState) { (errors: [AnyObject]!) -> () in
                if errors != nil {
                    print(errors)
                }
                // handle errors
            }
        }

    }
    
    func updateColor(hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat) {
        for light in Light.shared.cache!.lights!.values {
            Light.shared.lightState.hue = hue
            Light.shared.lightState.saturation = saturation
            Light.shared.lightState.brightness = brightness
            
            Light.shared.bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: Light.shared.lightState) { (errors: [AnyObject]!) -> () in
                if errors != nil {
                    print(errors)
                }
                // handle errors
            }
        }
    }
    
}
