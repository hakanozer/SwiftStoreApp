//
//  ProductDetail.swift
//  SwiftStoreApp
//
//  Created by Cihat Burak Ağaçhan on 30.01.2016.
//  Copyright © 2016 Hakan. All rights reserved.
//

import UIKit
import Alamofire

class ProductDetail: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet weak var TxtProductName: UILabel!
    @IBOutlet weak var TxtBrief: UILabel!
    @IBOutlet weak var TxtDescription: UITextView!
    @IBOutlet weak var TxtPrice: UILabel!
    @IBOutlet weak var TxtCampaign: UILabel!
    @IBOutlet weak var Like1: UIButton!
    @IBOutlet weak var Like2: UIButton!
    @IBOutlet weak var Like3: UIButton!
    @IBOutlet weak var Like4: UIButton!
    @IBOutlet weak var Like5: UIButton!
    @IBOutlet weak var lblTotalVote: UILabel!
    @IBOutlet weak var lblBasketNumber: UILabel!

    var CustomerId = ""
    
    var db = SQLiteDB.sharedInstance()
    var productDetailDic = NSDictionary()
    var pageViewController : UIPageViewController?
    var contentImages = [String]()
    var customerVote = 0
    
    @IBAction func AddForBuy(sender: UIButton) {
        
        if(CustomerId != ""){
        //ürün bilgileri gönderecek
            let ProductId = productDetailDic["productId"] as! String
            let productName = productDetailDic["productName"] as! String
            let imageArray = productDetailDic["images"] as! NSArray
            let imageDic = imageArray[0] as! NSDictionary
            let ProductImage = imageDic["thumb"] as? String
            let productPrice = productDetailDic["price"] as? String
            addBasket(Int(ProductId)!, productName: productName, productImagePath: ProductImage!, productPrice: productPrice!)
        }else{
            let alert = UIAlertView(title: "Uyarı Mesajı", message: "Lütfen Kullanıcı girişi yapınız.", delegate: self, cancelButtonTitle: "Tamam")
            alert.show()
        let vc:UserLogin = storyboard?.instantiateViewControllerWithIdentifier("UserLogin") as! UserLogin
        self.presentViewController(vc, animated: true, completion: nil)
        }
        
    }
    
    func addBasket(let productId:Int, let productName:String, let productImagePath:String, let productPrice:String)->Int
    {
        var count:Int = 0;
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("userID") != nil)
        {
            print(NSUserDefaults.standardUserDefaults().valueForKey("userID")!);
            let customerID = Int(NSUserDefaults.standardUserDefaults().valueForKey("userID") as! String);
            var strSQL = "insert into siparis values (?,?,?,?,?,?,?)";
            let sets = db.execute(strSQL, parameters: [NSNull(), customerID!, productId, productName,productImagePath, 0, productPrice]);
            
            if(sets > 0)
            {
                let uyari:UIAlertController = UIAlertController(title: "Ürün Sepeti", message: "Ürün sepetinize başarılı bir şekilde eklendi. ", preferredStyle: .Alert);
                
                //buton ekleme
                let tamam = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default, handler: nil);
                uyari.addAction(tamam);
                
                self.presentViewController(uyari, animated: true, completion: nil);
            }
            else
            {
                let uyari:UIAlertController = UIAlertController(title: "Ürün Sepeti", message: "Ürün sepete eklenirken hata oluştu. ", preferredStyle: .Alert);
                
                //buton ekleme
                let tamam = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default, handler: nil);
                uyari.addAction(tamam);
                
                self.presentViewController(uyari, animated: true, completion: nil);
            }
            
            strSQL = "select count(id) as sayi from siparis where kullaniciid = " + customerID!.description + " and satinalinmismi = 0";
            
            let iGet = db.query(strSQL);
            let countStr = (iGet?[0]["sayi"]?.asString())!;
            count = Int(countStr)!;
            
        }
        else
        {
            let uyari:UIAlertController = UIAlertController(title: "Kullanıcı Login Hatası", message: "Kullanıcı bulunmadı.", preferredStyle: .Alert);
            
            //buton ekleme
            let tamam = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default, handler: nil);
            uyari.addAction(tamam);
            
            self.presentViewController(uyari, animated: true, completion: nil);
        }
        
        return count;
    }
    
    @IBAction func funcVote(sender: UIButton) {
        print("yaz")
        
        if(CustomerId != ""){
            
            let producId = productDetailDic["productId"] as! String
            
            Alamofire.request(.GET, "http://jsonbulut.com/json/likeManagement.php?ref=679eaebee2ddd985fb310da2caa398ec&productId=\(producId)&vote=\(customerVote)&customerId=\(CustomerId)")
                .responseJSON { response in
                    
                    //let JSON = response.result.value
                    let alert = UIAlertView(title: "Uyarı Mesajı", message: "Oy verdiğiniz için teşekkür ederiz.", delegate: self, cancelButtonTitle: "Tamam")
                    alert.show()
                    
            }

        }else{
            
            let vc:UserLogin = storyboard?.instantiateViewControllerWithIdentifier("UserLogin") as! UserLogin
            self.presentViewController(vc, animated: true, completion: nil)
            print("giriş başarısız")
        }
        
    
        
    }
    
    @IBAction func Like5(sender: UIButton) {
        Like5.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like4.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like3.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        customerVote = 5
        
    }
    
    @IBAction func Like4(sender: UIButton) {
        Like4.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like3.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like5.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        customerVote = 4
    }
    
    @IBAction func Like3(sender: UIButton) {
        Like3.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like5.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like4.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        customerVote = 3
    }
    
    @IBAction func Like2(sender: UIButton) {
        Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        Like5.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like4.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like3.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        customerVote = 2
    }
    
    @IBAction func Like1(sender: UIButton) {
        Like5.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like4.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like3.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like2.setImage(UIImage(named: "1.png") , forState: UIControlState.Normal)
        Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        customerVote = 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "userID")
        CustomerId = NSUserDefaults.standardUserDefaults().objectForKey("userID") as! String
        TxtProductName.text = productDetailDic["productName"] as? String
        TxtBrief.text = productDetailDic["brief"] as? String
        TxtDescription.text = productDetailDic["description"] as? String
        TxtDescription.layer.borderWidth = 1
        TxtDescription.layer.borderColor = UIColor.blackColor().CGColor
        TxtPrice.text = productDetailDic["price"] as? String
        let likeDic = productDetailDic["likes"]!["like"] as! NSDictionary
        let like1 = likeDic["ortalama"] as! String
        let like = Double(like1)
        
        if (Int(like!) == 1){
           Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        }else if (Int(like!) == 2){
            Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        }else if (Int(like!) == 3){
            Like3.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        }else if (Int(like!) == 4){
            Like4.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like3.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        }else if (Int(like!) == 5){
            Like5.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like4.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like3.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like2.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
            Like1.setImage(UIImage(named: "Y1.png") , forState: UIControlState.Normal)
        }
        let TotalVote = likeDic["oy_toplam"] as? String
        lblTotalVote.text = "(\(TotalVote!))"
        let campaignId = String(productDetailDic["campaign"]!["campaignTypeId"])
        if(Int(campaignId) != 0){
            TxtCampaign.text =  "\(productDetailDic["campaignTitle"]!)"
        }
        let imageArray = productDetailDic["images"] as! NSArray
        let imageDic = imageArray[0] as! NSDictionary
        contentImages.append((imageDic["thumb"] as? String)!)
        contentImages.append((imageDic["normal"] as? String)!)
        
        pageViewCreate()
        setupPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func pageViewCreate(){
        
        let pageControl = self.storyboard?.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        
        pageControl.dataSource = self
        pageControl.delegate = self
        
        
        if (contentImages.count > 0) {
            let start = getItemController(0)!
            let startView:NSArray = [start]
            pageControl.setViewControllers(startView as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageControl
        addChildViewController(pageViewController!)
        self.view.addSubview((pageViewController?.view)!)
        pageViewController?.didMoveToParentViewController(self)
        self.pageViewController!.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.size.width, height: 250)
        
    }
    
    
    func setupPage(){
        let app = UIPageControl.appearance()
        app.pageIndicatorTintColor = UIColor.grayColor()
        app.currentPageIndicatorTintColor = UIColor.whiteColor()
        app.backgroundColor = UIColor.redColor()
    }
    
    
    
    func getItemController(itemIndex:Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            return pageItemController
        }
        return nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemCon = viewController as! PageItemController
        if itemCon.itemIndex+1 < contentImages.count {
            return getItemController(itemCon.itemIndex+1)
        }
        return nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemCon = viewController as! PageItemController
        if itemCon.itemIndex > 0 {
            return getItemController(itemCon.itemIndex-1)
        }
        
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
