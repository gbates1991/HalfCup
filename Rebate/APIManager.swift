//
//  APIManager.swift
//  Rebate
//
//  Created by Zhang Yi on 5/12/2015.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    static let sharedInstance = APIManager()
    
    //loadByQuery
    func checkUser(params:[String:AnyObject], completion:(ErrorType?, ResultSignup?) -> ()){
        Alamofire.request(.POST, kAPICheckUser, parameters:params).responseData {(resp:Response<NSData, NSError>) -> Void in
            guard let data = resp.result.value else {
                completion(resp.result.error, nil)
                return
            }
            let result = ResultSignup(json: JSON(data:data))
            completion(resp.result.error, result)
        }
    }
    
    //sign up
    func signUp(params:[String:AnyObject], completion:(ErrorType?, ResultSignup?) -> ()){
        Alamofire.request(.POST, kAPIInsertData2Table, parameters:params).responseData {(resp:Response<NSData, NSError>) -> Void in
            guard let data = resp.result.value else {
                completion(resp.result.error, nil)
                return
            }
            let result = ResultSignup(json: JSON(data:data))
            completion(resp.result.error, result)
        }
    }
    
    //get merchant type
    func getMerchantType(params:[String:AnyObject], completion:(ErrorType?, [MerchantTypeInfo]) -> ()){
        Alamofire.request(.GET, kAPIGetMerchantType, parameters: params).responseData { (resp:Response<NSData, NSError>) in
            guard let data = resp.result.value else {
                completion(resp.result.error, [])
                return
            }
            let json = SwiftyJSON.JSON(data:data).arrayValue
            var result = [MerchantTypeInfo]()
            for elem in json {
                var m = MerchantTypeInfo()
                m.type_id = elem["type_id"].intValue
                m.type_name = elem["type_name"].stringValue
                m.image_id = elem["image_id"].stringValue
                m.restaurant_number = elem["number_of_merchant"].intValue
                
                let rest = elem["restaurants"].arrayValue
                for restElem in rest {
                    var r = RestaurantInfo()
                    r.id = restElem["id"].intValue
                    r.name = restElem["name"].stringValue ?? ""
                    r.address = restElem["address"].stringValue ?? ""
                    r.code = restElem["code"].stringValue ?? ""
                    
                    m.restaurants.append(r)
                }
                result.append(m)
            }
            completion(resp.result.error, result)
        }
    }
    
    //get like facebook page id
    func getMerchantFacebookPromotionPost(params:[String:AnyObject], completion:(ErrorType?, MerchantPromotionPostInfo?) -> ()) {
        Alamofire.request(.GET, kAPIGetMerchantPromotionPost, parameters: params).responseData { (resp:Response<NSData, NSError>) in
            guard let data = resp.result.value else {
                completion(resp.result.error, nil)
                return
            }
            let result = MerchantPromotionPostInfo(json: JSON(data:data))
            completion(resp.result.error, result)
        }
    }
    
    func getAvailablePromotion(params:[String:AnyObject], completion:(ErrorType?, [AvailablePromotion])->()) {
        Alamofire.request(.GET, kAPILoadAvailablePromotionFromRestaurant, parameters: params).responseData { (resp:Response<NSData, NSError>) in
            guard let data = resp.result.value else {
                completion(resp.result.error, [])
                return
            }
            let json = SwiftyJSON.JSON(data:data).arrayValue
            var result = [AvailablePromotion]()
            for elem in json {
                let m = AvailablePromotion(json: elem)
                result.append(m)
            }
            completion(resp.result.error, result)
        }
    }
    
    func checkAvailableInstant(params:[String:AnyObject], completion:(ErrorType?, String?)->()) {
        Alamofire.request(.GET, kAPICheckAvailableInstant, parameters: params).responseData { (resp:Response<NSData, NSError>) in
            guard let data = resp.result.value else {
                completion(resp.result.error, "Error\nThere is no response from Server.")
                return
            }
            let result = SwiftyJSON.JSON(data:data)
            completion(resp.result.error, result["info"].stringValue)
        }
    }
    
    func registerInstantPromotion(params:[String:AnyObject], completion:(ErrorType?, Bool)->()) {
        Alamofire.request(.GET, kAPIRegisterInstantPromotion, parameters: params).responseData { (resp:Response<NSData, NSError>) in
            guard let data = resp.result.value else {
                completion(resp.result.error, false)
                return
            }
            
            completion(resp.result.error, true)
        }
    }
    
    func getAllInstantByUserId(params:[String:String], completion:(ErrorType?, [AvailablePromotion]) -> ()) {
        Alamofire.request(.GET, kAPIGetAllInstantByUser, parameters: params).responseData { (resp:Response<NSData, NSError>) in
            guard let data = resp.result.value else {
                completion(resp.result.error, [])
                return
            }
            let json = SwiftyJSON.JSON(data:data).arrayValue
            var result = [AvailablePromotion]()
            for elem in json {
                let m = AvailablePromotion(json: elem)
                result.append(m)
            }
            completion(resp.result.error, result)
        }
    }
}