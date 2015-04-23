//
//  GroceryParser.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/14/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation
import SWXMLHash
import CoreData

class GroceryParser: NSObject {
    
    class func parse(fromJSON data: NSData) -> [Grocery] {
        
        // From JSON - Walmart API format
        
        var groceries = [Grocery]()
        
        return groceries
    }
    
    class func parse(fromXML data: NSData) -> [Grocery] {
        
        // From XML - Supermarket API format
        var groceries = [Grocery]()
        
        
        // Need entity description of Grocery, but not saving to Core Data yet
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("Grocery", inManagedObjectContext: managedObjectContext!)
        
        // Use SWXMLHash to parse the XML
        let xml = SWXMLHash.parse(data)

        let arr = xml["ArrayOfProduct"][0].children
        println("In XML parser, found \(arr.count) products")
        for index in 0...arr.count-1 {
            
            // Build a Grocery but do not insert it into our Managed Object Context
            var grocery = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: nil) as! Grocery
            
            
            // Extracted XML and values and assign them to the grocery
            if let itemID = xml["ArrayOfProduct"][0].children[index]["itemID"].element?.text {
                grocery.itemID = itemID
            }
            if let name = xml["ArrayOfProduct"][0].children[index]["Itemname"].element?.text {
                grocery.itemName = name
            }
            if let description = xml["ArrayOfProduct"][0].children[index]["ItemDescription"].element?.text {
                grocery.itemDescription = description
            }
            if let category = xml["ArrayOfProduct"][0].children[index]["ItemCategory"].element?.text {
                grocery.itemCategory = category
            }
            if let image = xml["ArrayOfProduct"][0].children[index]["ItemImage"].element?.text {
                grocery.itemImageURL = image
            }
            
            grocery.purchased = false
                    
            groceries.append(grocery)
        }
        
        return groceries
    }
}
