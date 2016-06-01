//
//  UIAlertController+Rx.swift
//  SecureTribe
//
//  Created by Zhang Yi on 27/11/2015.
//  Copyright © 2015 JustTwoDudes. All rights reserved.
//

import Foundation
import UIKit

typealias AlertControllerResult = (style:UIAlertActionStyle, buttonIndex:Int)

extension UIAlertController {
    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    class func alertWithTitle(title:String?, message:String?, cancelTitle ct:String?, destructiveTitle dt:String?, otherTitles:[String], callback:(AlertControllerResult -> Void)?) -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        if let ct = ct {
            let cancelAction = UIAlertAction(title: ct, style: .Cancel){ _ in
                callback?((.Cancel, 0))
            }
            alert.addAction(cancelAction)
        }
        
        if let dt = dt {
            let destructiveAction =  UIAlertAction(title: dt, style: .Cancel){ _ in
                callback?((.Destructive, 0))
            }
            alert.addAction(destructiveAction)
        }
        
        for (index, title) in otherTitles.enumerate() {
            let action = UIAlertAction(title: title, style: .Default){ _ in
                callback?((.Default, index))
            }
            alert.addAction(action)
        }
        return alert
    }
    
    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    class func alertWithTitle(title:String?, message:String?, cancelTitle ct:String?, otherTitles:[String], callback:(AlertControllerResult -> Void)?) -> UIAlertController {
        return alertWithTitle(title, message: message, cancelTitle: ct, destructiveTitle: nil, otherTitles: otherTitles, callback: callback)
    }
    
    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    class func alertWithMessage(message:String?, cancelTitle ct:String?, otherTitles:[String], callback:(AlertControllerResult -> Void)?) -> UIAlertController {
        return alertWithTitle(nil, message: message, cancelTitle: ct, destructiveTitle: nil, otherTitles: otherTitles, callback: callback)
    }
    
    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    class func alertWithMessage(message:String?, cancelTitle ct:String, callback:(AlertControllerResult -> Void)? = nil) -> UIAlertController{
        return alertWithTitle(nil, message: message, cancelTitle: ct, destructiveTitle: nil, otherTitles: [], callback: callback)
    }
    
    /**
     Creates an UIAlertController instance with options and call back configured in parameter, Can use UIViewController's showAlerController: function to present it.
     */
    class func alertWithMessage(message:String?, callback:(AlertControllerResult -> Void)? = nil) -> UIAlertController{
        return alertWithTitle(nil, message: message, cancelTitle: "OK".localizedString(), destructiveTitle: nil, otherTitles: [], callback: callback)
    }
}