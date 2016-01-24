//
//  ViewController.swift
//  SwiftStoreApp
//
//  Created by Hakan on 24/01/16.
//  Copyright © 2016 Hakan. All rights reserved.
//

import UIKit
import GoogleMobileAds

/*

There are two steps to solve your problem:

Put the path of GoogleMobileAds.framework in Targets -> Build Settings "Framework Search Path"

Set "No" under Project -> Build Settings -> Enable Bitcode
*/

class ornekReklam: UIViewController {
    
    var inters:GADInterstitial!
    
    override func viewDidLoad() {
        self.inters = self.tamEkranReklam()
        super.viewDidLoad()
    }
    
    
    func tamEkranReklam() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: "ca-app-pub-8644394833467014/9766722208")
        let req = GADRequest()
        req.testDevices = ["2077ef9a63d2b398840261c8221a0c9b","8c3bbcd8b38b27c768b6ee62bf0fc9ac"]
        ad.loadRequest(req)
        return ad
    }
    
    
    
    @IBAction func fncTamEkranReklem(sender: UIButton) {
        // reklam denetimi
        if(self.inters.isReady){
            self.inters.presentFromRootViewController(self)
            self.inters = self.tamEkranReklam()
        }
    }
    
    
    
    // alt reklam
    @IBOutlet weak var altReklam: GADBannerView!
    
    override func viewWillAppear(animated: Bool) {
        altReklam.adUnitID = "ca-app-pub-8644394833467014/8289989008"
        altReklam.rootViewController = self
        altReklam.loadRequest(GADRequest())
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
