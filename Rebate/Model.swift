//
//  Model.swift
//  Rebate
//
//  Created by Pae on 5/12/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BaseResult{
    var code:Int = 0
    var info:String = ""
    
    init(json:JSON){
        code = json["code"].intValue
        info = json["info"].stringValue
    }
}

struct ResultSignup{
    var userInfo:UserInfo
    var code:Int = 0
    var info:String = ""
    init(json:JSON){
        code = json["code"].intValue
        info = json["info"].stringValue
        userInfo = UserInfo(json:json["data"])
    }
}

struct UserInfo{
    var id:String = "0"
    var accountExpired = false
    var accountLocked = false
    var email = ""
    var enabled = false
    var token = ""
    var username = ""
    var firstname = ""
    var lastname = ""
    var country = ""
    init (json:JSON){
        id = json["id"].stringValue
        accountExpired = json["accountExpired"].boolValue
        accountLocked = json["accountLocked"].boolValue
        email = json["email"].stringValue
        enabled = json["enabled"].boolValue
        token = json["token"].stringValue
        username = json["username"].stringValue
        firstname = json["firstname"].stringValue
        lastname = json["lastname"].stringValue
        country = json["countyr"].stringValue
    }
}

struct MerchantTypeInfo{
    var type_id : Int = 0
    var type_name : String = ""
    var image_id : String = ""
    var restaurant_number : Int = 0
    var restaurants : [RestaurantInfo] = []
}

struct RestaurantInfo{
    var id : Int = 0
    var address : String = ""
    var code : String = ""
    var name : String = ""
    
    var merchantPromotionPostInfo : MerchantPromotionPostInfo?
}

struct MerchantPromotionPostInfo {
    var id : Int = 0
    var pageID : String = ""
    var postID : String = ""
    var url_link : String = ""
    
    init (json:JSON) {
        id = json["id"].intValue
        pageID = json["pageID"].stringValue
        postID = json["postID"].stringValue
        url_link = json["urlLink"].stringValue
    }
}

struct AvailablePromotion {
    var restaurant_id : Int = 0
    var id : Int = 0
    var shared_count : Int = 0
    var title : String = ""
    var attach_id : String = ""
    var restaurant_name : String = ""
    var description : String = ""
    var redeemDate : String = ""
    var isRedeem : Bool = true
    
    init (json:JSON) {
        restaurant_id = json["restaurant_id"].intValue ?? 0
        id = json["id"].intValue ?? 0
        shared_count = json["shared_count"].intValue ?? 0
        title = json["title"].stringValue ?? ""
        attach_id = json["attach_id"].stringValue ?? ""
        
        if attach_id == "" {
            attach_id = json["attachment_id"].stringValue ?? ""
        }
        
        restaurant_name = json["restaurant_name"].stringValue ?? ""
        description = json["description"].stringValue ?? ""
        isRedeem = json["isRedeem"].boolValue ?? true
        redeemDate = json["updateDate"].stringValue ?? ""
        
        // Change string of Date for displaying string  ( 2016-01-01T12:32:25Z => 2016-01-01, 12:32:22 )
        if(redeemDate != "") {
            let newString = redeemDate.stringByReplacingOccurrencesOfString("T", withString: ", ")
            let lastString = newString.stringByReplacingOccurrencesOfString("Z", withString: "")
            redeemDate = lastString
        }
    }
}

class InboxInfo : NSObject, NSCoding {
    var title : String = ""
    var desc : String = ""
    var img_id : String = ""
    var redeem_date : String = ""
    
    init(promotion : AvailablePromotion) {
        title = promotion.title
        desc = promotion.description
        img_id = promotion.attach_id
        redeem_date = promotion.redeemDate
    }
    
    init(info : InboxInfo) {
        title = info.title
        desc = info.desc
        img_id = info.img_id
        redeem_date = info.redeem_date
    }
    
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.desc = aDecoder.decodeObjectForKey("desc") as! String
        self.img_id = aDecoder.decodeObjectForKey("img_id") as! String
        self.redeem_date = aDecoder.decodeObjectForKey("redeem_date") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.desc, forKey: "desc")
        aCoder.encodeObject(self.img_id, forKey: "img_id")
        aCoder.encodeObject(self.redeem_date, forKey: "redeem_date")
    }
}