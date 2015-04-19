//
//  WalmartAPI.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/18/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

class WalmartAPI: NSObject {
    
    let API_URL = "http://api.walmartlabs.com/v1"
    
    var groceries: [Grocery]?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    private var APIKey: String {
        get {
            
            var bundle = NSBundle.mainBundle()
            var file = bundle.pathForResource("Keys", ofType: "plist")!
            var dict = NSDictionary(contentsOfFile: file)
            
            var key = dict?.objectForKey("WALMART_API_KEY") as! String
            println("API key = \(key)")
            return key
        }
    }
    
    func searchByProductName(name: String) {

        self.groceries = [Grocery]()
        
        let url: NSURL = NSURL(string: "\(API_URL)/search?apiKey=\(APIKey)&query=\(name)")!
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if error != nil {
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as! NSDictionary
            if err != nil {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            let json = JSON(jsonResult)
            
            let list: Array<JSON> = json["items"].arrayValue
            for dict in list {
                
                let itemID = dict["itemId"].stringValue
                let name = dict["name"].stringValue
                let msrp = dict["msrp"].stringValue
                let salePrice = dict["salePrice"].doubleValue
                let description = dict["shortDescription"].stringValue
                let image = dict["thumbnailImage"].stringValue
                let category = dict["categoryPath"].stringValue
                
                var grocery = Grocery.createInManagedObjectContext(self.managedObjectContext!, itemID: itemID, itemName: name, itemDescription: description, itemCategory: category, itemImageURL: image, purchased: false, price: salePrice)

                println("\n*********************")
                println(grocery)
                self.groceries?.append(grocery)
            }
        })
        
        task.resume()
    }



}