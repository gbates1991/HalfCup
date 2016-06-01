//
//  ShareView.swift
//  Rebate
//
//  Created by Pae on 5/10/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

class ShareView : BaseView {
    var merchantTypeInfo:MerchantTypeInfo!
    var btnSubmenu: UIButton = UIButton()
    var imageBackground: AsyncImageView = AsyncImageView()
    
    var dropDown_Merchant : DropDown!
    var btnFBLike : UIButton!
    var btnLikeButton : FBSDKLikeControl = FBSDKLikeControl()
    
    var delegate : ShareViewDelegate?
    
    override func didMoveToWindow() {
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        self.imageBackground.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        addSubview(self.imageBackground)
        
//        btnSubmenu.setTitle(txtSubmenuTitle, forState: .Normal)
        btnSubmenu.setBackgroundImage(UIImage(named: "btn_back_normal"), forState: UIControlState.Normal)
        btnSubmenu.setBackgroundImage(UIImage(named: "btn_back_pressedl"), forState: UIControlState.Highlighted)
        btnSubmenu.setTitleColor(UIColor.lightTextColor(), forState: UIControlState.Normal)
        btnSubmenu.frame = CGRect(x: 0, y: 0, width: frame.width*2/3, height: 85)
        btnSubmenu.center = CGPoint(x: frame.width/2, y: frame.height/2)
        btnSubmenu.addTarget(self, action: #selector(ShareView.onSubmenuClicked), forControlEvents: .TouchUpInside)
        
        let firstLineFontSize = [NSFontAttributeName : UIFont.systemFontOfSize(30)]
        let txtSubmenuTitleFirtLine = NSMutableAttributedString(string:"\(merchantTypeInfo.type_name)\n", attributes: firstLineFontSize)
        
        let txtSubmenuTitleSecondLine = NSMutableAttributedString(string:"(\(merchantTypeInfo.restaurants.count) listing)")
        txtSubmenuTitleFirtLine.appendAttributedString(txtSubmenuTitleSecondLine)
        txtSubmenuTitleFirtLine.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: (txtSubmenuTitleFirtLine.string as NSString).rangeOfString(txtSubmenuTitleFirtLine.string))

        let titleLabel  = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: btnSubmenu.frame.width, height: btnSubmenu.frame.height)
        titleLabel.center = CGPoint(x: btnSubmenu.frame.width/2, y: btnSubmenu.frame.height/2)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .Center
        titleLabel.attributedText = txtSubmenuTitleFirtLine
        btnSubmenu.addSubview(titleLabel)
        
        addSubview(self.btnSubmenu)
        
        setupDropDown()
        setupFBLikeBtn()
        hidden()
        
        if(dropDown_Merchant.indexForSelectedRow < 0 ) {
            btnLikeButton.objectID = ""
        }
    }
    
    func onSubmenuClicked() {
        dropDown_Merchant.hiddenVal = false
//        btnFBLike.hidden = false
        btnSubmenu.hidden = true
        btnLikeButton.hidden = false
    }
    
    override func hidden() {
        dropDown_Merchant.hiddenVal = true
//        btnFBLike.hidden = true
        btnSubmenu.hidden = false
        btnLikeButton.hidden = true
    }
    
    func onDropDown() {
        dropDown_Merchant.show()
    }

    func onDropdownChanged(){
        let selectedIndex = dropDown_Merchant.indexForSelectedRow
        if(selectedIndex < 0 || merchantTypeInfo.restaurant_number == 0){
            return
        }
        let resId = merchantTypeInfo.restaurants[selectedIndex!].id;
        
        let hud = activityHUD()
        APIManager.sharedInstance.getMerchantFacebookPromotionPost(["restaurant_id":"\(resId)", "token":kAPIToken]) { (error, response) in
            if error==nil && response?.pageID != "" {
                self.btnLikeButton.objectID = "https://www.facebook.com/\(response!.pageID)"
                self.merchantTypeInfo.restaurants[selectedIndex!].merchantPromotionPostInfo = response
            }
            hud.hideHUD(false)
        }
    }
}

extension ShareView {
    convenience init(merchantTypeInfo : MerchantTypeInfo) {
        self.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShareView.onDropdownChanged), name: notificationDropDownCellChanged, object: nil)
        self.merchantTypeInfo = MerchantTypeInfo(type_id: merchantTypeInfo.type_id, type_name: merchantTypeInfo.type_name, image_id: merchantTypeInfo.image_id, restaurant_number: merchantTypeInfo.restaurant_number, restaurants: merchantTypeInfo.restaurants)
        
        if merchantTypeInfo.image_id == "" {
            imageBackground.image = UIImage (named: "bg")
        } else {
            let place_holder = UIImage(named: "bg")
            imageBackground.setURL(getImageURL(Int(merchantTypeInfo.image_id)!), placeholderImage: place_holder)
        }
    }
    
    func setupDropDown() {
        dropDown_Merchant = DropDown()
        dropDown_Merchant.setDefaultAnchorView(self)    //make default dropdown view
        addSubview(dropDown_Merchant)
        dropDown_Merchant.dismissMode = .OnTap
        //set text what there is no item selected
        dropDown_Merchant.setPlaceHolderText(" Select \(merchantTypeInfo.type_name)")
        
        //
        dropDown_Merchant.getAnchorButton()?.addTarget(self, action: #selector(ShareView.onDropDown), forControlEvents: UIControlEvents.TouchUpInside)
        
        //example data source
        for elem in merchantTypeInfo.restaurants {
            dropDown_Merchant.dataSource.append(elem.name)
        }
        
        dropDown_Merchant.selectionAction = { [unowned self] (index, item) in
            self.dropDown_Merchant.setPlaceHolderText(item)
        }
        
        
    }
    
    func setupFBLikeBtn() {
        btnFBLike = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width/3-40, height : 30))
        btnFBLike.setTitle(" ", forState: .Normal)
        btnFBLike.backgroundColor = UIColor.blueColor()
        btnFBLike.center = CGPoint(x: frame.width/2, y: frame.height*2/3)

        
        let scaleX = frame.width / (2 * btnLikeButton.frame.width)
        btnLikeButton.transform = CGAffineTransformMakeScale(scaleX, 1.7)
        btnLikeButton.frame.origin = CGPoint(x: frame.width/2 - btnLikeButton.frame.width*11/20, y: frame.height*2/3)
        btnLikeButton.likeControlStyle = FBSDKLikeControlStyle.BoxCount
        btnLikeButton.likeControlAuxiliaryPosition = .Bottom
        addSubview(btnFBLike)
        btnLikeButton.addTarget(self, action: #selector(ShareView.onFBLikeClicked), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(btnLikeButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ShareView.onClicked(_:)))
        btnFBLike.addGestureRecognizer(gesture)
        btnFBLike.hidden = true
    }

    func onClicked(sender : UITapGestureRecognizer) {
        
    }
    
    func onFBLikeClicked() {
        let selectedIndex = dropDown_Merchant.indexForSelectedRow
        if(selectedIndex < 0) {
            return;
        }
        let restInfo = merchantTypeInfo.restaurants[selectedIndex!]
        delegate?.didClickedLikeButton(restInfo)
    }
}

protocol ShareViewDelegate {
    func didClickedLikeButton(restaurantInfo : RestaurantInfo?)
}
