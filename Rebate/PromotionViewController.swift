//
//  PromotionViewController.swift
//  Rebate
//
//  Created by Pae on 5/14/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import XXPagingScrollView
import FBSDKCoreKit
import FBSDKLoginKit

class PromotionViewController : UIViewController {
    
    var imageScrollView:XXPagingScrollView = {
        let v = XXPagingScrollView()
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    
    var btnShare : UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var hud : PActivityHUD?
    
    var restaurantInfo : RestaurantInfo?
    var promotions = [AvailablePromotion]()
    var promotionImages = [AsyncImageView]()
    
    override func viewDidLoad() {
        
        view.addSubview(imageScrollView)
        self.view.sendSubviewToBack(imageScrollView)
        imageScrollView.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 70, 0))
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        setupImageScrollViews()
        setupShareButton()
        
        setupNavigationBar()
    }
    
    func setupImageScrollViews() {
        hud = activityHUD()
        APIManager.sharedInstance.getAvailablePromotion(["restaurant" : restaurantInfo!.id]) { (error, result) in
            if error == nil {
                var i = 0
                let viewSize = CGSize(width: self.view.frame.width*0.9-20, height: self.view.frame.height - self.navigationBar.frame.height - 30)
                for info in result {
                    self.promotions.append(info)
                    let v = AsyncImageView()
                    let place_holder = UIImage(named: "bg")
                    v.setURL(getImageURL(Int(info.attach_id)!), placeholderImage: place_holder)
                    
                    v.frame = CGRect(x: 0,y: 20, width: viewSize.width, height: viewSize.height)
                    v.frame.origin.x = CGFloat(i * (Int(v.frame.width)+20)+10)
                    i += 1
                    self.promotionImages.append(v)
                }
                
                self.imageScrollView.pagingWidth = viewSize.width+20
                self.imageScrollView.pagingHeight = viewSize.height
                
                for view in self.promotionImages {
                    self.imageScrollView.scrollView.addSubview(view)
                }
                
                self.imageScrollView.scrollView.contentSize = CGSizeMake((viewSize.width+20)*CGFloat(self.promotionImages.count), viewSize.height)
            }
            self.hud?.hideHUD(false)
        }
    }
    
    func setupShareButton() {
        let image = UIImage(named: "btn_share_facebook")
        btnShare = UIButton(frame: CGRect(x: 0, y: view.frame.height - 100, width: self.view.frame.width/2, height: 50))
        btnShare.center.x = self.view.frame.width/2
        btnShare.setBackgroundImage(image, forState: UIControlState.Normal)
        btnShare.addTarget(self, action: #selector(PromotionViewController.onShare), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnShare)
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .Plain , target: self, action: #selector(PromotionViewController.onBack))
        navigationBar.topItem?.leftBarButtonItem = backButton
        navigationBar.topItem?.title = restaurantInfo?.name
    }
    
    func onBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showError() {
        
    }
    
    func onShare() {
        hud = activityHUD()
        
        if(UserCredentials.sharedInstance.isAuthorized == true) {
            self.doShare()
            self.hud?.hideHUD(false)
            return
        }
        
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["user_photos"], fromViewController: self) { (fbsdkLoginResult, error) in
            if let _ = error {
                NSLog("Process error");
                self.showError()
            } else if (fbsdkLoginResult.isCancelled) {
                NSLog("Cancelled");
                self.showError()
            } else {
                if(fbsdkLoginResult.grantedPermissions.contains("user_photos")) {
                    loginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self) { (fbsdkLoginResult, error) in
                        if let _ = error {
                            NSLog("Process error");
                            self.showError()
                        } else if (fbsdkLoginResult.isCancelled) {
                            NSLog("Cancelled");
                            self.showError()
                        } else {
                            if(fbsdkLoginResult.grantedPermissions.contains("publish_actions")) {
                                self.doShare()
                            }
                        }
                    }
                }
            }
            UserCredentials.sharedInstance.isAuthorized = true
            self.hud?.hideHUD(false)
        }
    }
    
    func doShare() {
        let credentials = UserCredentials.sharedInstance
        APIManager.sharedInstance.checkAvailableInstant(["user_id":credentials.userid, "restaurant_id":self.restaurantInfo!.id, "token":kAPIToken]) { (error, result) in
            if error != nil {
                self.hud!.hideHUD(false)
                let alert = UIAlertController.alertWithMessage("Failed checking availability of sharing. Please try again later")
                self.showAlertController(alert)
                return
            }
            
            if result == kAPICheckAvailableInstantMessageOK {
                self.shareRestaurant()
            } else {
                self.hud!.hideHUD(false)
                //Showing customized dialog
                self.hud!.hideHUD(false)
                let alert = UIAlertController.alertWithMessage(msgShareFailed, callback: { (result) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func shareRestaurant(){
        FBSDKGraphRequest(graphPath: "/me/feed", parameters: ["link":restaurantInfo!.merchantPromotionPostInfo!.url_link], HTTPMethod: "POST").startWithCompletionHandler({ (connection, graphResult, error) in
            if (error == nil) {
                self.registerInstantPromotion()
            }else{
                self.hud!.hideHUD(false)
                let alert = UIAlertController.alertWithMessage("Error Posting Feed")
                self.showAlertController(alert)
                return
            }
        })
    }
    
    func registerInstantPromotion() {
        let credentials = UserCredentials.sharedInstance
        let params = ["user_id":credentials.userid, "restaurant_id":String(restaurantInfo!.id), "facebookUserID":credentials.fbid, "facebookUserName":credentials.username, "email":credentials.fbemail, "token":kAPIToken]
        print(params)
        APIManager.sharedInstance.registerInstantPromotion(params, completion: { (error , result) in
            if (error != nil || result == false) {
                self.hud!.hideHUD(false)
                let alert = UIAlertController.alertWithMessage("Failed to regist sharing page. Please try again later")
                self.showAlertController(alert)
                return
            }
            
            self.hud!.hideHUD(false)
            let alert = UIAlertController.alertWithMessage(msgShareSuccess, callback: { (result) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            self.presentViewController(alert, animated: true, completion: nil)
/*
            let currentDate = NSDate()
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd, HH:mm:ss"
            let strDate = dateFormater.stringFromDate(currentDate)
            
            let credential = UserCredentials.sharedInstance
            var inboxInfos = [InboxInfo]()
            for var promotion in self.promotions {
                promotion.redeemDate = strDate
                let info = InboxInfo(promotion: promotion)
                inboxInfos.append(info)
            }
            credential.inboxData = inboxInfos
            
            let notifData = ["data" : inboxInfos]
 */
            UserCredentials.sharedInstance.pushNotificationed = true
            NSNotificationCenter.defaultCenter().postNotificationName(notificationInboxReceive, object: nil, userInfo: nil)
        })
    }
}
