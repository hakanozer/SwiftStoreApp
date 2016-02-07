//
//  ProductList.swift
//  SwiftStoreApp
//
//  Created by Cihat Burak Ağaçhan on 30.01.2016.
//  Copyright © 2016 Hakan. All rights reserved.
//

import UIKit
import Alamofire


class ProductList: UITableViewController, UISearchResultsUpdating {

    var ProductFilter = [String]()
    var searchBar = UISearchController()
    var ProductDic = NSDictionary()
    var ProductsArray = NSArray()
    var InfoArray = NSArray()
    var filterArray = [String]()
    var InfoDic = NSDictionary()
    let Refresh = UIRefreshControl()
    let imageCache = NSDictionary()
    
    var data = NSMutableData()
    
    var item = 0
    
    
    func GETAlamofire(){
        
        Alamofire.request(.GET, "http://jsonbulut.com/json/product.php?ref=679eaebee2ddd985fb310da2caa398ec&start=0")
            .responseJSON { response in
                
                let JSON = response.result.value
                do {
                    try self.ProductDic = JSON as! NSDictionary
                    self.ProductsArray = self.ProductDic["Products"] as! NSArray
                    self.InfoDic = self.ProductsArray[0] as! NSDictionary
                    self.InfoArray = self.InfoDic["bilgiler"] as! NSArray
                    // print(self.InfoArray.count)
                    
                }catch {
                    let hata = error as! NSError
                    print("Data Hatası : \(hata.localizedDescription)")
                }
                
                self.tableView.reloadData()
                self.Refresh.endRefreshing()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar = UISearchController(searchResultsController: nil)
        self.searchBar.searchResultsUpdater = self
        self.searchBar.dimsBackgroundDuringPresentation = false
        self.searchBar.searchBar.sizeToFit()
        self.searchBar.searchBar.placeholder = "Arama Yap"
        
        self.tableView.tableHeaderView = self.searchBar.searchBar
        Refresh.addTarget(self, action: "GETAlamofire", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = Refresh
        GETAlamofire()
        
       
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    var j = 0
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if(j==0){
            for(var i=0 ; i < self.InfoArray.count ; i++ ){
                let dic = InfoArray[i] as! NSDictionary
                let baslik = dic["productName"] as! String
                self.filterArray.append(baslik)
            }
            
        }
        j++
        
        self.ProductFilter.removeAll(keepCapacity: false)
        let arama = NSPredicate(format: "SELF CONTAINS[c] %@",searchController.searchBar.text!)
        let diz = (self.filterArray as NSArray).filteredArrayUsingPredicate(arama)
        self.ProductFilter = diz as! [String]
        self.tableView.reloadData()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchBar.active) {
            return self.ProductFilter.count
        }else {
            return self.InfoArray.count
        }

    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(self.searchBar.active){
            for(var i = 0 ; i < self.InfoArray.count;i++){
                let detailDic = InfoArray[i] as! NSDictionary
                
                if(self.ProductFilter[indexPath.row] == detailDic["productName"] as! String){
                
                    cell.textLabel?.text = detailDic["productName"] as? String
                    cell.detailTextLabel?.text = detailDic["price"] as? String
                    
                    
                    
                    let imageArray = InfoArray[indexPath.row]["images"] as! NSArray
                    let imageDic = imageArray[0] as! NSDictionary
                    let thumb = imageDic["thumb"] as? String
                    
                    let imageUrl = NSURL(string: thumb!)!
                    var image:UIImage? = imageCache.valueForKey(thumb!) as? UIImage
                    
                    if(image == nil) {
                        let request = NSURLRequest(URL: imageUrl)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (responce:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                            
                            if error == nil {
                                image = UIImage(data: data!)
                                dispatch_async(dispatch_get_main_queue(),{
                                    if image != nil {
                                        cell.imageView!.image = image!
                                        cell.setNeedsLayout()
                                    }
                                })
                            }else {
                                dispatch_async(dispatch_get_main_queue(),{
                                    if image != nil {
                                        cell.imageView!.image = image!
                                        cell.setNeedsLayout()
                                    }
                                })
                            }
                            
                        })
                        
                    }
                    
                
                }
            
            
            }
        
        }else {
            
            let detailDic = InfoArray[indexPath.row] as! NSDictionary
            cell.textLabel?.text = detailDic["productName"] as? String
            cell.detailTextLabel?.text = detailDic["price"] as? String
            
            
            
            let imageArray = InfoArray[indexPath.row]["images"] as! NSArray
            let imageDic = imageArray[0] as! NSDictionary
            let thumb = imageDic["thumb"] as? String
            
            let imageUrl = NSURL(string: thumb!)!
            var image:UIImage? = imageCache.valueForKey(thumb!) as? UIImage
            
            if(image == nil) {
                let request = NSURLRequest(URL: imageUrl)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (responce:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                    
                    if error == nil {
                        image = UIImage(data: data!)
                        dispatch_async(dispatch_get_main_queue(),{
                            if image != nil {
                                cell.imageView!.image = image!
                                cell.setNeedsLayout()
                            }
                        })
                    }else {
                        dispatch_async(dispatch_get_main_queue(),{
                            if image != nil {
                                cell.imageView!.image = image!
                                cell.setNeedsLayout()
                            }
                        })
                    }
                    
                })
                
            }
 
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        

        return cell
    }
    
   
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let product = InfoArray[indexPath.row] as! NSDictionary
        let vc:ProductDetail = storyboard?.instantiateViewControllerWithIdentifier("ProductDetail") as! ProductDetail
        vc.productDetailDic = product
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
