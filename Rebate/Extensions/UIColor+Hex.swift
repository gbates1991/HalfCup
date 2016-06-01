//
//  UIColor+Hex.swift
//  Rebate
//
//  Created by Zhang Yi on 6/12/2015.
//
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString hex:String){
        let colorString = hex.stringByReplacingOccurrencesOfString("#", withString: "")
        var alpha:CGFloat = 0, red:CGFloat = 0, blue:CGFloat = 0, green:CGFloat = 0
        
        let colorComponentsFrom:(String, Int, Int) -> CGFloat = { string, start, length in
            let startIndex = string.startIndex.advancedBy(start)
            let endIndex = startIndex.advancedBy(length)
            let range = Range(start: startIndex, end: endIndex)
            let substring = string.substringWithRange(range)
            let fullHex = (length == 2) ? substring : "\(substring)\(substring)"
            
            var hexComponent:UInt32 = 0
            NSScanner(string: fullHex).scanHexInt(&hexComponent)
            return CGFloat(hexComponent) / 255.0
        }
        
        let length = colorString.characters.count
        switch length {
        case 3: //#RGB
            alpha = 1.0
            red = colorComponentsFrom(colorString, 0,  1)
            green = colorComponentsFrom(colorString, 1,  1)
            blue = colorComponentsFrom(colorString,1,  1)
        case 4: //#ARGB
            alpha = colorComponentsFrom(colorString, 0,  1)
            red = colorComponentsFrom(colorString, 1,  1)
            green = colorComponentsFrom(colorString,  2,  1)
            blue = colorComponentsFrom(colorString,  3,  1)
        case 6: //#RRGGBB
            alpha = 1.0
            red = colorComponentsFrom(colorString, 0,  2)
            green = colorComponentsFrom(colorString, 2,  2)
            blue = colorComponentsFrom(colorString, 4,  2)
        case 8: //##AARRGGBB
            alpha = colorComponentsFrom(colorString,  0,  2)
            red = colorComponentsFrom(colorString,  2,  2)
            green = colorComponentsFrom(colorString,  4,  2)
            blue = colorComponentsFrom(colorString,  6,  2)
        default:
            break
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}