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
    
    var groceries = [Grocery]()
    var delegate: ClientAPIDelegate?
    
    // Maybe shouldn't have this here
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    

    private var APIKey: String {
        
        // Get the API key from Keys.Plist
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
        
        let url: NSURL = NSURL(string: "\(API_URL)/search?apiKey=\(APIKey)&query=\(name)")!
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if error != nil {
                println(error.localizedDescription)
            }
            
            self.delegate?.foundNetworkGroceries(groceryListData: data)
        })
        
        task.resume()
    }



}