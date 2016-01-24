//
//  ornekFacebookBaglanResimCikis.swift
//  SwiftStoreApp
//
//  Created by Hakan on 24/01/16.
//  Copyright © 2016 Hakan. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class ornekFacebookBaglanResimCikis: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var loginResim: FBSDKProfilePictureView!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var txtData: UITextView!
    @IBOutlet weak var txtAdiSoyadi: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.delegate = self
        // oturum denetimi yapılıyor
        if(FBSDKAccessToken.currentAccessToken() != nil){
            // daha önce giriş yapılmış
            print("Giriş var")
            dataGetir()
        }else {
            // oturum kapalı - yapılmamış
            print("Giriş yok")
            loginButton.readPermissions = ["public_profile","email","user_friends"]
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        // hata denetimi
        if((error) != nil) {
            // hata var
        }else if result.isCancelled {
            // izin iptali
        }else {
            
            // datalar geldi
            if result.grantedPermissions.contains("email"){
                // dataları getir
                dataGetir()
            }
        }
        
    }
    
    
    // dataları getir fnc
    func dataGetir(){
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,link,gender,picture,friends"])
        req.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // hata var
                print("Hata Oluştu")
            }else {
                // data geldi
                self.txtData.text = "\(result)"
                let dic = result as! NSDictionary
                self.txtAdiSoyadi.text = dic["name"] as? String
                for (key,val) in dic {
                    print("key \(key) val \(val)")
                }
                
                
                let listeReq = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields":"id"])
                listeReq.startWithCompletionHandler({ (connection, friResult, error) -> Void in
                    print("\(friResult)")
                    //let fdic = friResult as! NSDictionary
                    //for (key,val) in fdic {
                    //  print("Arkadaş key \(key) val \(val)")
                    //}
                    
                })
                
                
                
            }
        })
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
