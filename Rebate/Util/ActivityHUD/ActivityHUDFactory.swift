//
//  ActivityHUDFactory.swift
//  SecureTribe
//
//  Created by Zhang Yi on 25/11/2015.
//  Copyright © 2015 JustTwoDudes. All rights reserved.
//

import Foundation

// MARK: - Wrapper for creating activity hud
class ActivityHUDFactory {
    class func createActivityHUD(context:PActivityHUDContext) -> PActivityHUD{
        return MBActivityHUD(context: context)
    }
}