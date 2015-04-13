//
//  GroceryList.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/31/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class GroceryList: NSObject, NSXMLParserDelegate {
    
    private var groceryList: [Grocery] = []

    override init() {
        super.init()
    }
    
    init(url: NSURL) {
        super.init()
        
        if let xmlParser = NSXMLParser(contentsOfURL: url) {
            xmlParser.delegate = self
            xmlParser.parse()
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        println("Element's name is \(elementName)")
        println("Element's attributes are \(attributeDict)")
    }
    
    func addGrocery(grocery: Grocery) {
        self.groceryList.append(grocery)
    }
    
    func purchasedGroceries() -> [Grocery] {
        var purchasedList: [Grocery] = []
        
        for grocery in self.groceryList {
            if grocery.purchased {
                purchasedList.append(grocery)
            }
        }
        
        return purchasedList
    }
    
    func unpurchasedGroceries() -> [Grocery] {
        var unpurchasedList: [Grocery] = []
        
        for grocery in self.groceryList {
            if !grocery.purchased {
                unpurchasedList.append(grocery)
            }
        }
        
        return unpurchasedList
    }
    
   
}
