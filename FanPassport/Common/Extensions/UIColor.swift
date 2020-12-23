//
//  UIColor.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func colorRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return colorRGB(red, green, blue, alpha: 1.0)
    }
    
    static func colorRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha : CGFloat) -> UIColor {
        
        return UIColor.init(red: red / 255.0,
                            green: green / 255.0,
                            blue: blue / 255.0, alpha: alpha)
        
    }
    
    static func colorRGB(_ hexValue : String) -> UIColor {
        return UIColor.colorRGB(hexValue, alpha : 1.0)
    }
    
    static func colorRGB(_ hexValue : String, alpha : CGFloat) -> UIColor {
        
        if let colorNum = UInt(String(hexValue.suffix(6)), radix: 16) {
            let red = colorNum >> 16
            let green = (colorNum & 0x00FF00) >> 8
            let blue = (colorNum & 0x0000FF)
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
            
        }
        return .black
    }
    
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    /// Red button color
    @nonobjc static var redRounded: UIColor {
        return UIColor(red: 0.93, green: 0.07, blue: 0.31, alpha: 1)
    }
    
    /// Title color
    @nonobjc static var gunPowder: UIColor {
        return UIColor(red: 0.28, green: 0.27, blue: 0.35, alpha: 1)
    }
    
    /// TextField valid green color
    @nonobjc static var northTexasGreen: UIColor {
        return UIColor(red: 0.00, green: 0.57, blue: 0.23, alpha: 1)
    }
    
    /// Default gray color
    @nonobjc static var heatherGray: UIColor {
        return UIColor(red: 0.70, green: 0.74, blue: 0.77, alpha: 1.00)
    }
    
    @nonobjc static var tabBarRed: UIColor {
        return UIColor(red:0.88, green:0.14, blue:0.26, alpha:1.00)
    }
    
    
    @nonobjc static var orangeText: UIColor {
        return UIColor(red: 0.95, green: 0.51, blue: 0.14, alpha: 1)
    }
}
