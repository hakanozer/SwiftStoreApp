//
//  UserRegistration.swift
//  SwiftStoreApp
//
//  Created by Cihat Burak Ağaçhan on 2.02.2016.
//  Copyright © 2016 Hakan. All rights reserved.
//

import UIKit
import Alamofire

class UserRegistration: UIViewController {

    var UserDic = NSDictionary()
    var UserArray = NSArray()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordVerify: UITextField!
    
    
    @IBAction func funcRegister(sender: UIButton) {
        GETAlamofire()
    }
    
    func GETAlamofire(){
        
        let name = txtName.text
        let surname = txtSurname.text
        let tel = txtTel.text
        let mail = txtMail.text
        let pass = txtPassword.text
        let verifyPass = txtPasswordVerify.text
        
        if(name == "" || surname == "" || tel == "" || mail == "" || pass == "" || verifyPass == ""){
            let alert = UIAlertView(title: "Uyarı Mesajı", message: "Lütfen eksik bilgileri giriniz" as! String, delegate: self, cancelButtonTitle: "Tamam")
            alert.show()
        }else{
        
        if(pass == verifyPass){
            
            Alamofire.request(.GET, "http://jsonbulut.com/json/userRegister.php?ref=679eaebee2ddd985fb310da2caa398ec&userName=\(name!)&userSurname=\(surname!)&userPhone=\(tel!)&userMail=\(mail!)&userPass=\(pass!)")
                .responseJSON { response in
                    
                    let JSON = response.result.value
                    do {
                        try self.UserDic = JSON as! NSDictionary
                        self.UserArray = self.UserDic["user"] as! NSArray
                        let dic = self.UserArray[0] as! NSDictionary
                        let durum = dic["durum"]!
                        let mesaj = dic["mesaj"]!
                        let userId = dic["kullaniciId"]! as! String
                        print(userId)
                        if(durum as! NSObject == 0){
                            let alert = UIAlertView(title: "Uyarı Mesajı", message: mesaj as! String, delegate: self, cancelButtonTitle: "Tamam")
                            alert.show()
                            
                        }else {
                            let alert = UIAlertView(title: "Uyarı Mesajı", message: mesaj as! String , delegate: self, cancelButtonTitle: "Tamam")
                            alert.show()
                            NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "userID")
                            let vc:ProductList = self.storyboard?.instantiateViewControllerWithIdentifier("ProductList") as! ProductList
                            self.presentViewController(vc, animated: true, completion: nil)
                            
                        }
                        
                    }catch {
                        let hata = error as! NSError
                        let alert = UIAlertView(title: "Uyarı Mesajı", message: "Data Hatası : \(hata.localizedDescription)" , delegate: self, cancelButtonTitle: "Tamam")
                        alert.show()
                        
                    }
                    
                    
            }
            
        }else {
            let alert = UIAlertView(title: "Uyarı Mesajı", message: "Şifre Doğrulama Hatası" , delegate: self, cancelButtonTitle: "Tamam")
            alert.show()
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
