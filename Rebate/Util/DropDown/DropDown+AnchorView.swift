//
//  DropDown+AnchorView.swift
//  Rebate
//
//  Created by Pae on 5/10/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import SnapKit

extension DropDown {
    public var hiddenVal : Bool {
        get {
            return self.hidden
        }
        
        set {
            self.hidden = newValue
            if let v = anchorView {
                v.hidden = newValue
            }
        }
    }
    func setDefaultAnchorView(view : UIView) {
        let imgBg = UIImage(named: "comb_back")
        let backView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width*2/3, height: 30))
        backView.image = imgBg
        backView.userInteractionEnabled = true
        let placeholderView = UILabel(frame: CGRect(x: 5, y: 0, width: backView.frame.width-10, height: backView.frame.height))
        placeholderView.textAlignment = .Left
        placeholderView.tag = 1
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
        button.tag = 2
        backView.addSubview(placeholderView)
        backView.addSubview(button)
        
        backView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/3)
        view.addSubview(backView)
        anchorView = backView
        direction = .Bottom
        bottomOffset = CGPoint(x: 0, y:anchorView!.bounds.height)
    }
    
    func setPlaceHolderText(placeholder: String) {
        if let txtView = anchorView?.viewWithTag(1) as? UILabel {
            txtView.text = " " + placeholder
        }
    }
    
    func getAnchorButton() -> UIButton? {
        if let button = anchorView?.viewWithTag(2) as? UIButton {
            return button
        }
        return nil
    }
}
