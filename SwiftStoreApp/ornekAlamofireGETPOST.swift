//
//  ornekAlamofireGETPOST.swift
//  SwiftStoreApp
//
//  Created by Hakan on 24/01/16.
//  Copyright © 2016 Hakan. All rights reserved.
//

import UIKit
import Alamofire

class ornekAlamofireGETPOST: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // yardım linki : https://github.com/Alamofire/Alamofire
        
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
