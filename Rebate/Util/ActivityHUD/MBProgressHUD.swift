//
//  MBProgressHUD.swift
//  SecureTribe
//
//  Created by Zhang Yi on 25/11/2015.
//  Copyright © 2015 JustTwoDudes. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PActivityHUD extension
class MBActivityHUD:PActivityHUD{
    var hud:MBProgressHUD?
    var context:PActivityHUDContext
    
    required init(context:PActivityHUDContext){
       self.context = context
    }
    
    func showHUD(animated: Bool) {
        var targetView = context.frontVC?.view
        if targetView == nil {
            targetView = context.frontView
        }
        
        hud = MBProgressHUD.showHUDAddedTo(targetView ?? UIApplication.sharedApplication().keyWindow, animated:true)
        hud?.labelText = context.message
    }
    
    func hideHUD(animated: Bool){
        //do something here.
        hud?.hide(true)
    }
    
    func setMessage(message: String) {
        context.message = message
        hud?.labelText = message
    }
    
    /**
     Display Failed icon, hide it after 1 seconds
     */
    func setFailedWithMessage(message: String) {
        hud?.mode = .CustomView
        hud?.customView = UIImageView(image: UIImage(named: "ic_hud_fail"))
        hud?.labelText = "Failed"
        hud?.detailsLabelText = message
        
        hud?.hide(true, afterDelay: 1.0)
    }
    /**
     Display succeed icon, hide it after 1 seconds
     */
    func setSucceedWithMessage(message: String) {
        hud?.mode = .CustomView
        hud?.customView = UIImageView(image: UIImage(named: "ic_hud_success"))
        hud?.labelText = "Success"
        hud?.detailsLabelText = message
        
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func hideHUD(animated: Bool, after: NSTimeInterval) {
        hud?.hide(animated, afterDelay: after)
    }
}
