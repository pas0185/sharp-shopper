//
//  NetworkManager.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/22/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

private let _NetworkManagerInstance = NetworkManager()
private let walmart = WalmartAPI()
private let supermarket = SupermarketAPI()

class NetworkManager: NSObject {
    
    class var sharedInstance: NetworkManager {
        return _NetworkManagerInstance
    }
    
    func fetchGroceries(forSearchTerm term: String, completionHandler: (groceries: [Grocery]) -> Void) {
        
        var groceries = [Grocery]()
        
        
        // TODO: fetch from some API
        
        
        completionHandler(groceries: groceries)
    }
    
    func fetchFromWalmart(term: String, completionHandler: (groceries: [Grocery]) -> Void) {
        
        var groceries = [Grocery]()
        
        // Search Walmart API for this term
        walmart.search(term, completion: {
            (JSONGroceryData: NSData) -> Void in
            
            // Parse the JSON data
            groceries = GroceryParser.parse(fromJSON: JSONGroceryData)

            // Send the groceries to the completion handler
            completionHandler(groceries: groceries)
        })
    }
    
    func fetchFromSupermarket(term: String, completionHandler: (groceries: [Grocery]) -> Void) {
        
        var groceries = [Grocery]()
        
        // Search Supermarket API for this term
        supermarket.search(term, completion: {
            (XMLGroceryData: NSData) -> Void in
            
            // Parse the XML data
            groceries = GroceryParser.parse(fromXML: XMLGroceryData)
            
            // Send the groceries to the completion handler
            completionHandler(groceries: groceries)
        })
    }
}
