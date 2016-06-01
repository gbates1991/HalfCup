//
//  UserCredentials.swift
//  Rebate
//
//  Created by Zhang Yi on 8/12/2015.
//
//

import Foundation

private let kNSDefaultsKeyFBEmail = "com.ous.rebatespecialist.usercredentials.fbemail"
private let kNSDefaultsKeyUserID = "com.ous.rebatespecialist.usercredentials.userid"
private let kNSDefaultsKeyToken = "com.ous.rebatespecialist.usercredentials.token"
private let kNSDefaultsKeyUserName = "com.ous.rebatespecialist.usercredentials.username"
private let kNSDefaultsKeyFirstName = "com.ous.rebatespecialist.usercredentials.firstname"
private let kNSDefaultsKeyLastName = "com.ous.rebatespecialist.usercredentials.lastname"
private let kNSDefaultsKeyFBID = "com.ous.rebatespecialist.usercredentials.fbid"
private let kNSDefaultsKeyCountry = "com.ous.rebatespecialist.usercredentials.country"
private let kNSDefaultsKeyInboxInfo = "com.ous.rebatespecialist.usercredentials.inboxinfo"
private let kNSDefaultsKeyPushNotification = "com.ous.rebatespecialist.usercredentials.pushnotification"
private let kNSDefaultsKeyIsAuthorized = "com.ous.rebatespecialist.usercredentials.isauthorized"
private let kNSDefaultsKeyIsAuthorizedLogin = "com.ous.rebatespecialist.usercredentials.isauthorizedlogin"

class UserCredentials {
    static let sharedInstance = UserCredentials()
    let kvostore = NSUserDefaults.standardUserDefaults()
    var pushNotificationed:Bool {
        get {
            return kvostore.boolForKey(kNSDefaultsKeyPushNotification) ?? false
        }set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyPushNotification)
            kvostore.synchronize()
        }
    }
    
    var fbemail:String{
        get {
            return kvostore.stringForKey(kNSDefaultsKeyFBEmail) ?? ""
        }set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyFBEmail)
            kvostore.synchronize()
        }
    }
    
    var userid:String{
        get {
            return kvostore.stringForKey(kNSDefaultsKeyUserID) ?? "0"
        }set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyUserID)
            kvostore.synchronize()
        }
    }
    
    var token:String{
        get {
            return kvostore.stringForKey(kNSDefaultsKeyToken) ?? ""
        }set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyToken)
            kvostore.synchronize()
        }
    }
    
    var username:String{
        get {
            return kvostore.stringForKey(kNSDefaultsKeyUserName) ?? ""
        }set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyUserName)
            kvostore.synchronize()
        }
    }
    
    var firstname:String{
        get{
            return kvostore.stringForKey(kNSDefaultsKeyFirstName) ?? ""
        }
        set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyFirstName)
            kvostore.synchronize()
        }
    }
    
    var lastname:String{
        get{
            return kvostore.stringForKey(kNSDefaultsKeyLastName) ?? ""
        }
        set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyLastName)
            kvostore.synchronize()
        }
    }
    
    var fbid:String{
        get{
            return kvostore.stringForKey(kNSDefaultsKeyFBID) ?? ""
        }
        set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyFBID)
            kvostore.synchronize()
        }
    }
    
    var country:String{
        get{
            return kvostore.stringForKey(kNSDefaultsKeyCountry) ?? ""
        }
        set{
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyCountry)
            kvostore.synchronize()
        }
    }
    
    var isAuthorized : Bool {
        get{
            return kvostore.boolForKey(kNSDefaultsKeyIsAuthorized) ?? false
        }
        set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyIsAuthorized)
            kvostore.synchronize()
        }
    }
    
    var isAuthorizedLogin : Bool {
        get{
            return kvostore.boolForKey(kNSDefaultsKeyIsAuthorizedLogin) ?? false
        }
        set {
            kvostore.setValue(newValue, forKey: kNSDefaultsKeyIsAuthorizedLogin)
            kvostore.synchronize()
        }
    }
    
    var inboxData : [InboxInfo] {
        get {
            
            if let info = kvostore.objectForKey(kNSDefaultsKeyInboxInfo) {
                let inboxinfo = NSKeyedUnarchiver.unarchiveObjectWithData(info as! NSData) as? [InboxInfo]
                
                if let result = inboxinfo {
                    return result
                }

                return []
                
            }
            
            return []
        }
        set {
            var inboxinfo = [InboxInfo]()
            if newValue.count == 0 {
                return
            }
            //for sorting by date
            inboxinfo.append(newValue[0])
            var tmpArray = newValue
            tmpArray.removeFirst()
            for elem in tmpArray
            {
                var isAdded = false
                for i in 0..<inboxinfo.count {
                    if elem.redeem_date >= inboxinfo[i].redeem_date {
                        inboxinfo.insert(elem, atIndex: i)
                        isAdded = true
                        break;
                    }
                }
                if(isAdded == false) {
                    inboxinfo.append(elem)
                }
//                inboxinfo.append(elem)
            }
            let saveData = NSKeyedArchiver.archivedDataWithRootObject(inboxinfo)
            NSUserDefaults.standardUserDefaults().setObject(saveData, forKey: kNSDefaultsKeyInboxInfo)
        }
    }
    
    func hasSavedUser() -> Bool{
        return fbemail != ""
    }
    
    func clearUserInfo(){
        fbemail = ""
        userid = ""
        token = ""
        username = ""
        country = ""
        firstname = ""
        lastname = ""
        fbid = ""
        pushNotificationed = false
        inboxData.removeAll()
        isAuthorized = false
        isAuthorizedLogin = false
    }
}