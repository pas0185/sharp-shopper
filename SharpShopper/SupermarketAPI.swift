//
//  SupermarketAPI.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/16/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

class SupermarketAPI: NSObject, NSXMLParserDelegate {
    
    var groceries: [Grocery]?
    
    var parser: NSXMLParser?
    var element: String?
    
    var itemName: String?
    var itemDescription: String?
    var itemCategory: String?
    var itemImage: String?
    var itemID: String?
    

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
                
                println("Walmart API completed search for \(searchTerm)")
                
                completion(XMLGroceryData: data)
            })
            task.resume()
        }

    
    }
    
//    func searchByProductName(name: String) -> [Grocery] {
//        
//        let url = NSURL(string: "\(API_URL)/SearchByProductName?APIKEY=\(API_KEY)&ItemName=\(name)")
//        return self.parseToGroceryArrayFromURL(url!)
//    }

    func parseToGroceryArrayFromURL(url: NSURL) -> [Grocery] {
        
        self.groceries = []
        
        self.parser = NSXMLParser(contentsOfURL: url)
        self.parser?.delegate = self
        self.parser?.shouldResolveExternalEntities = false
        self.parser?.parse()
        
        return self.groceries!
    }

    // MARK: - NSXMLParserDelegate Methods
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {

        self.element = elementName
        
        if self.element == "ArrayOfString" {
            println("Started parsing string array")
        }
        
        if self.element == "Product" {
            self.itemName = ""
            self.itemDescription = ""
            self.itemCategory = ""
            self.itemImage = ""
            self.itemID = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        if self.element == "Itemname" {
            self.itemName?.extend(string!)
        }
        if self.element == "ItemDescription" {
            self.itemDescription?.extend(string!)
        }
        if self.element == "ItemCategory" {
            self.itemCategory?.extend(string!)
        }
        if self.element == "ItemImage" {
            self.itemImage?.extend(string!)
        }
        if self.element == "ItemID" {
            self.itemID?.extend(string!)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == "Product" {
            
           // #warning need to come fix this grocery initialization
//            var grocery = Grocery.createInManagedObjectContext(self.managedObjectContext!, itemID: self.itemID!, itemName: self.itemName!, itemDescription: self.itemDescription!, itemCategory: self.itemCategory!, itemImageURL: self.itemImage!, purchased: false, price: 0.0)
//            
//            self.groceries?.append(grocery)
        }
    }
}