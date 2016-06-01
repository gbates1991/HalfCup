//
//  UIViewController+RootVC.swift
//  Rebate
//
//  Created by Zhang Yi on 8/12/2015.
//
//

import UIKit

extension UIViewController{
    func setRootViewController(){
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        
        guard window.rootViewController != self else{
            return
        }
        
        UIView.transitionWithView(window, duration: 0.5, options: .TransitionCrossDissolve, animations: { () -> Void in
            let oldState = UIView.areAnimationsEnabled()
            UIView.setAnimationsEnabled(false)
            window.rootViewController = self
            UIView.setAnimationsEnabled(oldState)
            },
            completion: nil)
    }
}