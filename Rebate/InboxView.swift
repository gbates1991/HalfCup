//
//  InboxView.swift
//  Rebate
//
//  Created by Pae on 5/11/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit

class InBoxView : BaseView {
    var info : InboxInfo!
    var imageView : AsyncImageView!
    var lblTitle : UILabel!
    var lblDescription : UILabel!
    var lblRedeemDate : UILabel!
    var image_id : String!
    
    override func didMoveToWindow() {
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*2/3)
        
        let place_holder = UIImage(named: "logo_top")
        imageView.setURL(getImageURL(Int(info.img_id)!), placeholderImage: place_holder)
        addSubview(imageView)
        
        lblTitle.text = info.title
        lblTitle.font = lblTitle.font.fontWithSize(20)
        lblTitle.frame = CGRect(x: 0, y: imageView.frame.height + 15, width: frame.width-10, height: 50)
        lblTitle.fixHeight()
//        let heightConstraint : NSLayoutConstraint = NSLayoutConstraint()
//        lblTitle.resizeHeightToFit(heightConstraint)
//        lblTitle.addConstraint(heightConstraint)
        
        lblDescription.text = info.desc
        lblDescription.lineBreakMode = .ByCharWrapping
        lblDescription.numberOfLines = 0
        lblDescription.frame = CGRect(x: 0, y: 0, width: frame.width-30, height: 99)
        lblDescription.fixHeight()
        
        lblRedeemDate.text = info.redeem_date
        lblRedeemDate.frame = CGRect(x: 0, y: frame.height - 25, width: frame.width, height: 20)
        lblRedeemDate.fixHeight()
        
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: lblTitle.frame.height + imageView.frame.height + 30, width: frame.width-30, height: frame.height - (lblTitle.frame.height + imageView.frame.height + lblRedeemDate.frame.height + 50)))
        scrollView.contentSize = lblDescription.frame.size
        scrollView.addSubview(lblDescription)
        
        addSubview(imageView)
        addSubview(lblTitle)
        addSubview(scrollView)
        addSubview(lblRedeemDate)
    }
}

extension InBoxView {
    convenience init(item : InboxInfo) {
        self.init()
        info = InboxInfo(info: item)
        
        imageView = AsyncImageView()
        lblTitle = UILabel()
        lblDescription = UILabel()
        lblRedeemDate = UILabel()
    }
}