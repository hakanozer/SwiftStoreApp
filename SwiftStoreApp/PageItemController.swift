//
//  PageItemController.swift
//  SwiftStoreApp
//
//  Created by Cihat Burak Ağaçhan on 30.01.2016.
//  Copyright © 2016 Hakan. All rights reserved.
//
import UIKit

class PageItemController: UIViewController {
    
    var itemIndex:Int = 0
    var imageName : String = "" {
        
        didSet {
            if let imageView = contentImageView {
                let nsdata = NSData(contentsOfURL: NSURL(string: imageName)!)
                imageView.image = UIImage(data: nsdata!)
            }
        }
    }
    
    
    @IBOutlet var contentImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsdata = NSData(contentsOfURL: NSURL(string: imageName)!)
        
        
        let url = imageName
        let imageCache = NSDictionary()
        
        let imageUrl = NSURL(string: url)!
        var image:UIImage? = imageCache.valueForKey(url) as? UIImage
        
        if(image == nil) {
            let request = NSURLRequest(URL: imageUrl)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (responce:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                
                if error == nil {
                    image = UIImage(data: data!)
                    dispatch_async(dispatch_get_main_queue(),{
                        if image != nil {
                            self.contentImageView?.image = UIImage(data: nsdata!)
                        }
                    })
                }else {
                    dispatch_async(dispatch_get_main_queue(),{
                        if image != nil {
                            self.contentImageView?.image = UIImage(data: nsdata!)
                        }
                    })
                }
                
            })
            
        }
        
    }
    
}
