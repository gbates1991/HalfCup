//
//  ViewController.swift
//  Rebate
//
//  Created by Pae on 5/10/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

struct LoginDetails{
    var email:String = ""
    var userName:String = ""
    var password:String = ""
    var fbId:String = ""
    var firstName = ""
    var lastName = ""
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var hud : PActivityHUD!

    @IBAction func onBtnConnectFB(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        
        if(UserCredentials.sharedInstance.isAuthorizedLogin == true) {
            self.hud = self.activityHUD(kAPIProgressMessage)
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,first_name,last_name"]).startWithCompletionHandler { connection, graphResult, error in
                guard let graph = graphResult as? [String:String] where error == nil else {
                    return
                }
                
                var details = LoginDetails()
                details.email = graph["email"] ?? ""
                //details.email = "rebatespecialist@gmail.com"
                details.userName = graph["name"] ?? ""
                details.fbId = graph["id"] ?? ""
                
                if let range = details.email.rangeOfString("@") {
                    details.password = details.email.substringToIndex(range.startIndex)
                }
                
                details.firstName = graph["first_name"] ?? ""
                details.lastName = graph["last_name"] ?? ""
                self.checkUser(details)
            }
            return
        }
        
        loginManager.logOut()
        loginManager.logInWithReadPermissions(["email","public_profile", "user_friends", "user_location"], fromViewController: self) { (fbsdkLoginResult, error) in
            if let _ = error {
                NSLog("Process error");
                print(error)
                self.showError()
            } else if (fbsdkLoginResult.isCancelled) {
                NSLog("Cancelled");
                self.showError()
            } else {
                if(fbsdkLoginResult.grantedPermissions.contains("email") && fbsdkLoginResult.grantedPermissions.contains("public_profile"))
                {
                    guard let _ = FBSDKAccessToken.currentAccessToken() else {
                        return
                    }
                    
                    self.hud = self.activityHUD(kAPIProgressMessage)
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,first_name,last_name"]).startWithCompletionHandler { connection, graphResult, error in
                        guard let graph = graphResult as? [String:String] where error == nil else {
                            return
                        }
                        
                        var details = LoginDetails()
                        details.email = graph["email"] ?? ""
                        //details.email = "rebatespecialist@gmail.com"
                        details.userName = graph["name"] ?? ""
                        details.fbId = graph["id"] ?? ""
                        
                        if let range = details.email.rangeOfString("@") {
                            details.password = details.email.substringToIndex(range.startIndex)
                        }
                        
                        details.firstName = graph["first_name"] ?? ""
                        details.lastName = graph["last_name"] ?? ""
                        self.checkUser(details)
                    }
                }
            }
        }
    }
    
    func checkUser(userInfo:LoginDetails){
        guard userInfo.password != "" else {
            //User denied access to face book
            return
        }
        
        let params = ["table":"User", "query":"email=\"\(userInfo.email)\"", "token":kAPIToken]
//        let hud = activityHUD(kAPIProgressMessage)
        APIManager.sharedInstance.checkUser(params) { error, result in
            if error != nil {
                self.hud.hideHUD(false)
                let alert = UIAlertController.alertWithMessage("Login Failed. Please try again later")
                self.showAlertController(alert)
                return
            }
            
            if result?.code == 1 {
                //Save user again
                let credentials = UserCredentials.sharedInstance
                credentials.fbemail = userInfo.email
                credentials.token = result!.userInfo.token
                credentials.userid = result!.userInfo.id
                credentials.username = userInfo.userName
                credentials.firstname = userInfo.firstName
                credentials.lastname = userInfo.lastName
                credentials.fbid = userInfo.fbId
                UserCredentials.sharedInstance.isAuthorizedLogin = true
                self.hud.hideHUD(false)
                self.gotoMainScreen()
            } else {
                //do sign up
                let params = ["table":"User", "username":userInfo.email, "password":userInfo.password, "email":userInfo.email, "token":kAPIToken]
                APIManager.sharedInstance.signUp(params){ error, result in
                    if result?.code == 1 {
                        //Save user again
                        let credentials = UserCredentials.sharedInstance
                        credentials.fbemail = userInfo.email
                        credentials.token = result!.userInfo.token
                        credentials.userid = result!.userInfo.id
                        credentials.username = userInfo.userName
                        credentials.firstname = userInfo.firstName
                        credentials.lastname = userInfo.lastName
                        credentials.fbid = userInfo.fbId
                        self.hud.hideHUD(false)
                        
                        UserCredentials.sharedInstance.isAuthorizedLogin = true
                        
                        self.gotoMainScreen()
                    } else {
                        self.hud.hideHUD(false)
                        let alert = UIAlertController.alertWithMessage("Singup Failed. Please try again later")
                        self.showAlertController(alert)
                        return
                    }
                }
            }
        }
    }


}

extension ViewController : FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //Do nothing.
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func showError() {
        
    }
    
    func gotoMainScreen() {
        let vc = StoryboardScene.Main.mainScreenViewController()
        vc.setRootViewController()
    }
}
