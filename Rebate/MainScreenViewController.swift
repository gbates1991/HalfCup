//
//  MainScreenViewController.swift
//  Rebate
//
//  Created by Pae on 5/10/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import XXPagingScrollView
import ImageLoader
import FBSDKCoreKit
import SwiftyJSON

class MainScreenViewController : UIViewController, UIScrollViewDelegate {
    
    var btnShare : UIButton!
    var btnInbox : UIButton!
    var btnProfile : UIButton!
    
    var selectedMenu : Int = 0
    
    var bottomTabView:XXPagingScrollView = {
        let v = XXPagingScrollView()
//        v.backgroundColor = UIColor(colorLiteralRed: 0.32, green: 0.48, blue: 0.67, alpha: 1)
        v.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        return v
    }()
    
    
    var pageView:XXPagingScrollView = {
        let v = XXPagingScrollView()
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    
    var shareViews : [ShareView] = []
    var inboxViews : [InBoxView] = []
    var profileView : ProfileView!
    
    var prof_info : ProfileInfo!
    
    let credentials = UserCredentials.sharedInstance
    
    var myShareGroup = dispatch_group_create()
    
    var isLiked = false
    var restaurantInfo : RestaurantInfo?
    
    override func viewDidLoad() {
        
        view.addSubview(self.pageView)
        pageView.scrollView.delegate = self
        self.pageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 70, 0))
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainScreenViewController.loadInboxData), name: notificationInboxReceive, object: nil)
        
        //creating profile view
        let url = "https://graph.facebook.com/\(credentials.fbid)/picture?type=normal"
        
        prof_info = ProfileInfo(imageURL: url, fbId: "\(credentials.firstname) \(credentials.lastname)", fbEmail: credentials.fbemail, fbName: credentials.username)
        profileView = ProfileView(item: prof_info)
        
        setupSharePageView()
        setupBottomMenuBar()
        updateMenu(0)
        
        setupInboxViews()
        
        if(UserCredentials.sharedInstance.pushNotificationed == true) {
            loadInboxData()
        }
    }
    
    func setupSharePageView() {
        
        for v in pageView.scrollView.subviews {
            v.removeFromSuperview()
        }
        
        if shareViews.count <= 0 {
            
            dispatch_group_enter(myShareGroup)
            if(credentials.country == "") {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"location"]).startWithCompletionHandler({ (connection, graphResult, error) in
                    if let graph = graphResult["location"] as? [String:String] where error==nil {
                        self.credentials.country = graph["name"] ?? ""
                    }
                    
//                    self.credentials.county = graph["name"] ?? ""
                    self.getMerchantType(self.credentials.country)
                })
            } else {
                getMerchantType(credentials.country)
            }
        }
        
        dispatch_group_notify(myShareGroup, dispatch_get_main_queue()) {
            
            if(self.shareViews.count == 0) {
                return;
            }
            
            self.pageView.pagingWidth = self.shareViews[0].frame.width + 20
            self.pageView.pagingHeight = self.shareViews[0].frame.height
            
            for view in self.shareViews {
                self.pageView.scrollView.addSubview(view)
            }
            
            self.pageView.scrollView.contentSize = CGSizeMake((self.shareViews[0].frame.width+20)*CGFloat(self.shareViews.count), self.shareViews[0].frame.height)
            self.pageView.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
        }
    }
    
    func setupInboxViews() {
        let credentials = UserCredentials.sharedInstance
        let inboxInfo = credentials.inboxData
        
        inboxViews.removeAll()
        for info in inboxInfo {
            addNewInboxInfoView(info)
        }
    }
    
    func setupInboxPageView() {
        
        for v in pageView.scrollView.subviews {
            v.removeFromSuperview()
        }
        
        if(inboxViews.count<=0) {
            let lblNotice = UILabel(frame: CGRect(x: 0, y: 0,width: pageView.frame.width, height: 30))
            lblNotice.textAlignment = .Center
            lblNotice.text = "There is nothing to show!"
            lblNotice.font = lblNotice.font.fontWithSize(20)
            lblNotice.center = CGPoint(x: pageView.frame.width/2, y: pageView.frame.height/2)
            pageView.scrollView.addSubview(lblNotice)
            
            return
        }
        
        self.pageView.pagingWidth = self.inboxViews[0].frame.width + 20
        self.pageView.pagingHeight = self.inboxViews[0].frame.height
        
        for view in self.inboxViews {
            self.pageView.scrollView.addSubview(view)
        }
        
        self.pageView.scrollView.contentSize = CGSizeMake((self.inboxViews[0].frame.width+20)*CGFloat(self.inboxViews.count), self.inboxViews[0].frame.height)
        
//        let lastPos = CGPoint(x: (inboxViews[0].frame.width+20)*CGFloat(inboxViews.count-1) + 10, y: 0)
//        self.pageView.scrollView.setContentOffset(lastPos, animated: false)
        self.pageView.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
    }
    
    func setupBottomMenuBar() {
        view.addSubview(bottomTabView)
        self.bottomTabView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(view.frame.height-70, 0, 0, 0))
            print(pageView.frame.height)
        }
        
        btnShare = UIButton(type: UIButtonType.System) as UIButton
        btnShare.frame = CGRectMake(0, 0, view.frame.width/2, 70)
        btnShare.addTarget(self, action: #selector(MainScreenViewController.onMenuShare), forControlEvents: UIControlEvents.TouchUpInside)
        
        btnInbox = UIButton(type: UIButtonType.System) as UIButton
        btnInbox.frame = CGRectMake(view.frame.width/2, 0, view.frame.width/2, 70)
        btnInbox.addTarget(self, action: #selector(MainScreenViewController.onMenuInBox), forControlEvents: UIControlEvents.TouchUpInside)
        
        btnProfile = UIButton(type: UIButtonType.System) as UIButton
        btnProfile.frame = CGRectMake(view.frame.width, 0, view.frame.width/2, 70)
        btnProfile.addTarget(self, action: #selector(MainScreenViewController.onMenuProfile), forControlEvents: UIControlEvents.TouchUpInside)
        
        bottomTabView.pagingWidth = view.frame.width/2
        bottomTabView.pagingHeight = 70
        
        bottomTabView.scrollView.addSubview(btnShare)
        bottomTabView.scrollView.addSubview(btnInbox)
        bottomTabView.scrollView.addSubview(btnProfile)
        
        bottomTabView.scrollView.contentSize = CGSizeMake((view.frame.width/2) * 3, 70)
    }
    
    func setupProfileView() {
        for v in pageView.scrollView.subviews {
            v.removeFromSuperview()
        }
        
        profileView.frame = CGRect(x: 0,y: 0, width: view.frame.width * 0.9, height: view.frame.height-200)
        
        pageView.pagingWidth = profileView.frame.width
        pageView.pagingHeight = profileView.frame.height
        
        self.pageView.scrollView.addSubview(profileView)
        
        self.pageView.scrollView.contentSize = CGSizeMake(profileView.frame.width, profileView.frame.height)
    }
    
    func onMenuShare() {
        updateMenu(0)
        setupSharePageView()
    }
    
    func onMenuInBox() {
        updateMenu(1)
        setupInboxPageView()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func onMenuProfile() {
        updateMenu(2)
        setupProfileView()
    }
    
    func updateMenu(index : Int) {
        let currentLocale = NSLocale.currentLocale().localeIdentifier
        if(currentLocale.hasPrefix("zh")) {
            btnShare.setBackgroundImage(UIImage(named: "btn_share_ch"), forState: .Normal)
            btnInbox.setBackgroundImage(UIImage(named: "btn_inbox_ch"), forState: .Normal)
            btnProfile.setBackgroundImage(UIImage(named: "btn_profile_ch"), forState: .Normal)
            
            selectedMenu = index
            switch(index) {
            case 0:
                btnShare.setBackgroundImage(UIImage(named: "btn_share_sel_ch"), forState: .Normal)
                bottomTabView.scrollView.setContentOffset(btnShare.frame.origin, animated: true)
            case 1:
                btnInbox.setBackgroundImage(UIImage(named: "btn_inbox_sel_ch"), forState: .Normal)
                bottomTabView.scrollView.setContentOffset(btnInbox.frame.origin, animated: true)
            case 2:
                btnProfile.setBackgroundImage(UIImage(named: "btn_profile_sel_ch"), forState: .Normal)
                bottomTabView.scrollView.setContentOffset(btnProfile.frame.origin, animated: true)
            default: break
            }
        } else {
            btnShare.setBackgroundImage(UIImage(named: "btn_share"), forState: .Normal)
            btnInbox.setBackgroundImage(UIImage(named: "btn_inbox"), forState: .Normal)
            btnProfile.setBackgroundImage(UIImage(named: "btn_profile"), forState: .Normal)
            
            selectedMenu = index
            switch(index) {
            case 0:
                btnShare.setBackgroundImage(UIImage(named: "btn_share_sel"), forState: .Normal)
                bottomTabView.scrollView.setContentOffset(btnShare.frame.origin, animated: true)
            case 1:
                btnInbox.setBackgroundImage(UIImage(named: "btn_inbox_sel"), forState: .Normal)
                bottomTabView.scrollView.setContentOffset(btnInbox.frame.origin, animated: true)
            case 2:
                btnProfile.setBackgroundImage(UIImage(named: "btn_profile_sel"), forState: .Normal)
                bottomTabView.scrollView.setContentOffset(btnProfile.frame.origin, animated: true)
            default: break
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for v in pageView.scrollView.subviews {
            let v1 = v as! BaseView
            v1.hidden()
        }
    }
}

extension MainScreenViewController : ShareViewDelegate {
    func getMerchantType(count : String) {
        let params = ["country":credentials.country, "token":kAPIToken]
        APIManager.sharedInstance.getMerchantType(params) { (error, result) in
            if error == nil {
                var i = 0
                for info in result {
                    if(info.restaurant_number == 0) {
                        continue
                    }
                    let v = ShareView(merchantTypeInfo: info)
                    
                    v.frame = CGRect(x: 0,y: 0, width: self.view.frame.width * 0.9-20, height: self.view.frame.height-100)
                    v.frame.origin.x = CGFloat(i * Int(v.frame.width+20) + 10)
                    i += 1
                    v.delegate = self
                    self.shareViews.append(v)
                }
            }
            dispatch_group_leave(self.myShareGroup)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(isLiked == true) {
            let v = StoryboardScene.Main.promotionViewController()
            v.restaurantInfo = restaurantInfo
            self.showViewController(v, sender: nil)
            isLiked = false
        }
    }
    
    func didClickedLikeButton(restaurantInfo : RestaurantInfo?) {
        isLiked = true
        self.restaurantInfo = restaurantInfo
//        v.setRootViewController()
    }
    
    func receiveNotification(notificaton : NSNotification) {
        loadInboxData()
    }
    
    func loadInboxData () {
        
        let hud = activityHUD()
        
        let credentials = UserCredentials.sharedInstance
        let params = ["user_id":credentials.userid, "token":kAPIToken]
        print(params)
        APIManager.sharedInstance.getAllInstantByUserId(params, completion: { (error , result) in
            if (error != nil || result.count==0) {
                hud.hideHUD(false)
                return
            }
            
            let credential = UserCredentials.sharedInstance
            var inboxInfos = [InboxInfo]()
            for promotion in result {
//                if(promotion.isRedeem == true) {
                    let info = InboxInfo(promotion: promotion)
                    inboxInfos.insert(info, atIndex: 0)
//                }
            }
            credential.inboxData.removeAll()
            credential.inboxData = inboxInfos
            
            self.setupInboxViews()
            
            if(UserCredentials.sharedInstance.pushNotificationed == true) {
                UserCredentials.sharedInstance.pushNotificationed = false
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                self.onMenuInBox()
            }
            hud.hideHUD(false)
        })
    }
    
    // Make InboxView from info and if info is new, this view is added to page-scroll-view
    func addNewInboxInfoView(info : InboxInfo) {
        let v = InBoxView(item: info)
        v.frame = CGRect(x: 0,y: 0, width: self.view.frame.width * 0.9-20, height: self.view.frame.height-100)
        v.frame.origin.x = CGFloat(inboxViews.count * Int(v.frame.width+20) + 10)
        inboxViews.append(v)

//        self.pageView.scrollView.addSubview(v)
//        self.pageView.scrollView.setContentOffset(v.frame.origin, animated: false)
    }
}