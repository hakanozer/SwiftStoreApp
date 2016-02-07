//
//  UserLogin.swift
//  SwiftStoreApp
//
//  Created by Cihat Burak Ağaçhan on 2.02.2016.
//  Copyright © 2016 Hakan. All rights reserved.
//

import UIKit
import Alamofire

class UserLogin: UIViewController {
    
    var UserDic = NSDictionary()
    var UserArray = NSArray()
    
    
    @IBOutlet weak var txtMailAdress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func funcLogin(sender: UIButton) {
        
       GETAlamofire()
        
    }
    
    @IBAction func funcRegistration(sender: UIButton) {
        
    }
    
    
    func GETAlamofire(){
        
        let mail = txtMailAdress.text
        let pass = txtPassword.text
        
        if (mail == "" && pass == ""){
            let alert = UIAlertView(title: "Uyarı Mesajı", message: "Lütfen Bilgilerinizi Giriniz ya da Üye olunuz" , delegate: self, cancelButtonTitle: "Tamam")
            alert.show()
        
        }else{
        
        Alamofire.request(.GET, "http://jsonbulut.com/json/userLogin.php?ref=679eaebee2ddd985fb310da2caa398ec&userEmail=\(mail!)&userPass=\(pass!)")
            .responseJSON { response in
                
                let JSON = response.result.value
                do {
                    try self.UserDic = JSON as! NSDictionary
                    self.UserArray = self.UserDic["user"] as! NSArray
                    let dic = self.UserArray[0] as! NSDictionary
                    let durum = dic["durum"]!
                    let mesaj = dic["mesaj"]!
                    let userId = dic["bilgiler"]!["userId"] as! String
                    
                    if(durum as! NSObject == 0){
                        let alert = UIAlertView(title: "Uyarı Mesajı", message: mesaj as! String, delegate: self, cancelButtonTitle: "Tamam")
                        alert.show()
                    }else {
                        let alert = UIAlertView(title: "Uyarı Mesajı", message: mesaj as! String, delegate: self, cancelButtonTitle: "Tamam")
                        alert.show()
                        NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "userID")
                        print(userId)

                        let vc:ProductList = self.storyboard?.instantiateViewControllerWithIdentifier("ProductList") as! ProductList
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                     
                }catch {
                    let hata = error as! NSError
                    let alert = UIAlertView(title: "Uyarı Mesajı", message: "Data Hatası : \(hata.localizedDescription)" , delegate: self, cancelButtonTitle: "Tamam")
                    alert.show()
                }
        }
    }
}
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
   
}
