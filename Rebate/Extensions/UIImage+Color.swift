//
//  UIImageExtensions.swift
//  Rebate
//
//  Created by Zhang Yi on 6/12/2015.
//
//

import Foundation
import UIKit

extension UIImage{
    class func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func ovalImageWithColor(color:UIColor, radius:CGSize) -> UIImage{
        let rect = CGRectMake(0, 0, radius.width * 2, radius.height * 2)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.AllCorners], cornerRadii: radius)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        path.lineWidth = 0.0
        CGContextAddPath(context, path.CGPath)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillPath(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}