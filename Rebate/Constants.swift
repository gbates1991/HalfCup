//
//  Constants.swift
//  Rebate
//
//  Created by Pae on 5/12/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import Foundation

//MARK: - APIRoutes Master API
let kAPIMasterEndPoint = "http://54.251.62.201/social_rebates_system/masterApi/"
let kAPIInsertData2Table = kAPIMasterEndPoint + "save"
let kAPICheckUser = kAPIMasterEndPoint + "loadByQuery"

//MARK: - APIRoutes api
let kAPIEndPoint = "http://54.251.62.201/social_rebates_system/api/"
let kAPIToken = "1234567890"
let kAPIGetRestaurants = kAPIEndPoint + "loadAvailableRestaurant"
let kAPIGetTables = kAPIEndPoint + "loadAvailableTableFromSelectedRestaurant"
let kAPIGetTrendings = kAPIEndPoint + "loadSharedPromotion"
let kAPIGetPromotions = kAPIEndPoint + "loadAvailablePromotionFromSelectedRestaurant"
let kAPIGetCoupons = kAPIEndPoint + "loadVoucher"
let kAPIGetComments = kAPIEndPoint + "loadCommentsOfPost"
let kAPIGetMerchantType = kAPIEndPoint + "getMerchantTypeWithImages"
let kAPIGetMerchantPromotionPost = kAPIEndPoint + "getMerchantFacebookPromotionPost"
let kAPILoadAvailablePromotionFromRestaurant = kAPIEndPoint + "loadAvailablePromotionFromSelectedRestaurant"

//MARK: - APIInstance api
let kAPIInstantEndPoint = "http://54.251.62.201/social_rebates_system/instantApi/"
let kAPICheckAvailableInstant = kAPIInstantEndPoint + "checkAvailableInstant"
let kAPIRegisterInstantPromotion = kAPIInstantEndPoint + "registerInstantPromotion"
let kAPIGetAllInstantByUser = kAPIInstantEndPoint + "getAllInstantbyUser"

//Global Function
func getImageURL(id:Int) -> NSURL{
    return NSURL(string: "http://54.251.62.201/social_rebates_system/masterApi/download?id=\(id)&token=\(kAPIToken)")!
}

let kAPIProgressMessage = "Please wait..."
let kAPIFailedMessage = "Failed"
let kAPISuccessMessage = "Success"

let kAPICheckAvailableInstantMessageOK = "OK"

let msgShareSuccess = "THANKS FOR SHARING. CLAIM YOUR ITEM BY SHOWING THE POST INSIDE YOUR FACEBOOK."
let msgShareFailed = "YOU NEED TO WAIT 8 HOURS BEFORE NEXT REDEEM"

//Notifications
let notificationDropDownCellChanged = "DropDownCellChangedNotification"
let notificationInboxReceive = "InboxDatasReceived"