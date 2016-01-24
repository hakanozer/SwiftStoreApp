//
//  ViewController.swift
//  SQLiteGirisSorgulari
//
//  Created by Hakan on 05/12/15.
//  Copyright © 2015 Hakan. All rights reserved.
//

import UIKit

class ornekSQliteDuzenleSil: UIViewController {
    
    // db Sınıfı oluşturuluyor
    var db = SQLiteDB.sharedInstance()
    
    @IBOutlet weak var txtAdi: UITextField!
    @IBOutlet weak var txtSoyadi: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtSifre: UITextField!
    @IBAction func btnCalis(sender: AnyObject) {
        // insert, update, delete bizlere geriye int değer döner.
        // etkilenen satır sayısı vardır.
        
        let adi = txtAdi.text
        let soyadi = txtSoyadi.text
        let mail = txtMail.text
        let sifre = txtSifre.text
        
        let yaz = db.execute("insert into kullanicilar values (?,?,?,?,?)", parameters: [NSNull(), adi!,soyadi!,mail!,sifre!])
        
        if(yaz > 0) {
            print("Yazma İşlemi Başarılı")
        }else {
            print("Yazma İşlemi Hatalı")
        }
    }
    
    
    // data getirme
    @IBOutlet weak var txtData: UITextView!
    @IBAction func fncDataGetir(sender: AnyObject) {
        
        let query = "select *from kullanicilar"
        let oku = db.query(query)
        var gelen = ""
        for(var i = 0; i < oku?.count; i++) {
            gelen += (oku?[i]["adi"]?.asString())! + " " + (oku?[i]["soyadi"]?.asString())! + "\n"
        }
        txtData.text = gelen
        
        /*
        for var aa in oku! {
        print(aa["adi"]?.asString())
        }
        */
        
    }
    
    
    
    // data silme
    @IBOutlet weak var txtSil: UITextField!
    @IBAction func fncSil(sender: AnyObject) {
        
        let sil = txtSil.text
        let query = "delete from kullanicilar where id = \(sil!)"
        let silDurum = db.execute(query)
        if (silDurum > 0) {
            print("Silme İşlemi Başarılı")
            fncDataGetir(NSNull())
        }else {
            print("Silme Hatası !!!")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

