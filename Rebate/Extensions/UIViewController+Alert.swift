//
//  UIViewController+Alert.swift
//  Rebate
//
//  Created by Zhang Yi on 6/12/2015.
//
//

import Foundation
import UIKit
extension UIViewController {
    // MARK: - Show alert controller: simply alert controller
    /**
    Display Alert Controller to user (simlpy use presentViewController for now), alertController should be configured with callbacks first.
    - Parameter alert: UIAlertController to be displayed on top of this viewcontroller instance.
    */
    func showAlertController(alert:UIAlertController){
        presentViewController(alert, animated: true, completion: nil)
    }
}