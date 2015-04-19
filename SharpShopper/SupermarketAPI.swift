//
//  SupermarketAPI.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/16/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

class SupermarketAPI: NSObject, NSXMLParserDelegate {
    
    let API_URL = "http://www.SupermarketAPI.com/api.asmx"

    var groceries: [Grocery]?
    
    var parser: NSXMLParser?
    var element: String?
    
    var itemName: String?
    var itemDescription: String?
    var itemCategory: String?
    var itemImage: String?
    var itemID: String?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    private var APIKey: String {
        get {
            
            var bundle = NSBundle.mainBundle()
            var file = bundle.pathForResource("Keys", ofType: "plist")!
            var dict = NSDictionary(contentsOfFile: file)
            
            var key = dict?.objectForKey("SUPERMARKET_API_KEY") as! String
            return key
        }
    }
    
    func searchByProductName(name: String) -> [Grocery] {
        
        let url = NSURL(string: "\(API_URL)/SearchByProductName?APIKEY=\(APIKey)&ItemName=\(name)")
        return self.parseToGroceryArrayFromURL(url!)
    }

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
            var grocery = Grocery.createInManagedObjectContext(self.managedObjectContext!, itemID: self.itemID!, itemName: self.itemName!, itemDescription: self.itemDescription!, itemCategory: self.itemCategory!, itemImageURL: self.itemImage!, purchased: false, price: 0.0)
            
            self.groceries?.append(grocery)
        }
    }
}