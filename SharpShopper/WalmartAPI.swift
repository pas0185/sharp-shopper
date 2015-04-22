//
//  WalmartAPI.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/18/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

class WalmartAPI: NSObject {
    
    // MARK: - API Information from Keys.Plist
    
    private var API_KEY: String {
        get {
            var bundle = NSBundle.mainBundle()
            var file = bundle.pathForResource("Keys", ofType: "plist")!
            var dict = NSDictionary(contentsOfFile: file)
            
            return dict?.objectForKey("WALMART_API_KEY") as! String
        }
    }
    
    private var API_URL: String {
        get {
            var bundle = NSBundle.mainBundle()
            var file = bundle.pathForResource("Keys", ofType: "plist")!
            var dict = NSDictionary(contentsOfFile: file)
            
            return dict?.objectForKey("WALMART_API_URL") as! String
        }
    }

    
    func search(searchTerm: String, completion: (JSONGroceryData: NSData) -> Void) {
        println("Walmart API starting search for \(searchTerm)")
                
        if let url: NSURL = NSURL(string: "\(API_URL)/search?apiKey=\(API_KEY)&query=\(searchTerm)") {
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                if error != nil {
                    println(error.localizedDescription)
                }
                
                println("Walmart API completed search for \(searchTerm)")
                
                completion(JSONGroceryData: data)
            })
            task.resume()
        }
    }
}