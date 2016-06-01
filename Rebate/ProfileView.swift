//
//  ProfileView.swift
//  Rebate
//
//  Created by Pae on 5/11/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileView : BaseView {
    var info : ProfileInfo!
    var imageView : AsyncImageView!
    var lblInfo : UILabel!
    var btnLogout : UIButton!
    
    override func didMoveToWindow() {
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width*0.8, height: frame.height/2)
        imageView.center.x = frame.width / 2
        addSubview(imageView)
        
        lblInfo.frame = CGRect(x: 0, y: imageView.frame.height + 20, width: frame.width, height: 99)
        lblInfo.font = lblInfo.font.fontWithSize(20)
        lblInfo.numberOfLines = 0
        lblInfo.fixHeight()
        lblInfo.center.x = frame.width/2
        
        btnLogout.frame = CGRect(x: 0, y: frame.height - 60, width: frame.width/2, height: 55)
        btnLogout.center.x = frame.width/2
        
        addSubview(imageView)
        addSubview(lblInfo)
        addSubview(btnLogout)
    }
}

extension ProfileView {
    convenience init(item : ProfileInfo) {
        self.init()
        info = ProfileInfo(imageURL: item.imageURL, fbId: item.fbId, fbEmail: item.fbEmail, fbName: item.fbName)
        
        imageView = AsyncImageView()
        lblInfo = UILabel()
        btnLogout = UIButton()
/*
        if item.imageURL=="" {
            imageView.image = UIImage(named: "blank")
        } else {
            imageView.load(item.imageURL)
        }
*/
        let place_holder = UIImage(named: "logo_top")
        imageView.setURL(item.imageURL, placeholderImage: place_holder)
        let string = "Facebook ID : \(info.fbId)\nFacebook Email : \(info.fbEmail)\nFacebook Name : \(info.fbName)"
        lblInfo.font = lblInfo.font.fontWithSize(15)
        lblInfo.textAlignment = .Center
        lblInfo.text = string
        
        let currentLocale = NSLocale.currentLocale().localeIdentifier
        if(currentLocale.hasPrefix("zh")) {
            btnLogout.setBackgroundImage(UIImage(named: "click_logout_normal_ch"), forState: UIControlState.Normal)
        } else {
            btnLogout.setBackgroundImage(UIImage(named: "click_logout_normal"), forState: UIControlState.Normal)
        }
        btnLogout.addTarget(self, action: #selector(ProfileView.onLogout), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onLogout() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        var credentials = UserCredentials.sharedInstance
        credentials.clearUserInfo()
        
        let vc = StoryboardScene.Main.loginScreenViewController()
        vc.setRootViewController()
    }
}

struct ProfileInfo {
    var imageURL : String = ""
    var fbId : String = ""
    var fbEmail : String = ""
    var fbName : String = ""
}