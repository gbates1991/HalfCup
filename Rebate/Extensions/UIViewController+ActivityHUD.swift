//
//  UIViewController+ActivityHUD.swift
//  Rebate
//
//  Created by Zhang Yi on 6/12/2015.
//
//

import Foundation
import UIKit

private struct ActivityHUDContextMock : PActivityHUDContext{
    var frontVC:UIViewController? = nil
    var message:String = ""
    var frontView:UIView? = nil
}

// MARK: - UIViewController activityHUD extension
extension UIViewController {
    /**
     Initates new activity hud with message, start spinning, and return it
     
     - Parameter message: Optional, default=nil, message to display in HUD
     
     - Returns: PActivityHUD instance, can use hide: method to dismiss it.
     */
    func activityHUD(message:String? = nil) -> PActivityHUD{
        let mock = ActivityHUDContextMock(frontVC: self, message: message ?? "", frontView:nil)
        let hud = ActivityHUDFactory.createActivityHUD(mock)
        hud.showHUD(true)
        return hud
    }
}

// MARK: - UIViewController activityHUD extension
extension UIView {
    /**
     Initates new activity hud with message, start spinning, and return it
     
     - Parameter message: Optional, default=nil, message to display in HUD
     
     - Returns: PActivityHUD instance, can use hide: method to dismiss it.
     */
    func activityHUD(message:String? = nil) -> PActivityHUD{
        let mock = ActivityHUDContextMock(frontVC: nil, message: message ?? "", frontView:self)
        let hud = ActivityHUDFactory.createActivityHUD(mock)
        hud.showHUD(true)
        return hud
    }
}