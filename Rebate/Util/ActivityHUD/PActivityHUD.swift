//
//  PActivityHUD.swift
//  SecureTribe
//
//  Created by Zhang Yi on 25/11/2015.
//  Copyright © 2015 JustTwoDudes. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Activity HUD Protocol
protocol PActivityHUDContext {
    var frontVC : UIViewController? { get }  //View Controller displaying the progress hud.
    var message:String { get set }           //Message to show
    var frontView : UIView? { get }
}

protocol PActivityHUD {
    init(context:PActivityHUDContext)
    
    /**
     Shows HUD with current context
    */
    func showHUD(animated:Bool)
    
    /**
     Clean up HUD with current context
     */
    func hideHUD(animated:Bool)
    
    /**
     Clean up HUD after seconds
     */
    func hideHUD(animated:Bool, after:NSTimeInterval)
    
    /**
     Change activity hud's message
    */
    func setMessage(message:String)
    
    /**
     Display Failed icon
    */
    func setFailedWithMessage(message:String)
    /**
     Display succeed icon
    */
    func setSucceedWithMessage(message:String)
}