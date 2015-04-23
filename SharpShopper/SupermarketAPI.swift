//
//  SupermarketAPI.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/16/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

class SupermarketAPI: NSObject, NSXMLParserDelegate {

    private var API_KEY: String {
        get {
            
            var bundle = NSBundle.mainBundle()
            var file = bundle.pathForResource("Keys", ofType: "plist")!
            var dict = NSDictionary(contentsOfFile: file)
            
            return dict?.objectForKey("SUPERMARKET_API_KEY") as! String
        }
    }
    
    private var API_URL: String {
        get {
            
            var bundle = NSBundle.mainBundle()
            var file = bundle.pathForResource("Keys", ofType: "plist")!
            var dict = NSDictionary(contentsOfFile: file)
            
            return dict?.objectForKey("SUPERMARKET_API_URL") as! String
        }
        
    }
    
    func search(searchTerm: String, completion: (XMLGroceryData: NSData) -> Void) {
        println("Supermarket API starting search for: \(searchTerm)")
        
        if let url: NSURL = NSURL(string: "\(API_URL)/SearchByProductName?APIKEY=\(API_KEY)&ItemName=\(searchTerm)") {
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                if error != nil {
                    println(error.localizedDescription)
                }
                
                println("Supermarket API completed search for \(searchTerm)")
                
                completion(XMLGroceryData: data)
            })
            task.resume()
        }
    }
}