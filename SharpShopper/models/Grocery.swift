//
//  Grocery.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation
import CoreData

class Grocery: NSManagedObject {

    @NSManaged var draftName: String
    @NSManaged var itemID: String
    @NSManaged var itemName: String
    @NSManaged var itemDescription: String
    @NSManaged var itemCategory: String
    @NSManaged var itemImageURL: String
    @NSManaged var purchased: Bool
    @NSManaged var price: Double
    
    var title: String {
        
        if self.draftName != "" {
            return self.draftName
        }
        
        if self.itemName != "" {
            return self.itemName
        }
        
        return ""
    }
    
    var subtitle: String {
        
        return self.itemName
    }
    
    class func arrayFromJSON(data: NSData) -> [Grocery] {
        
        var groceries = [Grocery]()
        
        var err: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as! NSDictionary
        if err != nil {
            println("JSON Error \(err!.localizedDescription)")
        }
        
        
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        let entity = NSEntityDescription.entityForName("Grocery", inManagedObjectContext: managedObjectContext!)
        
        
        let json = JSON(jsonResult)
        
        let list: Array<JSON> = json["items"].arrayValue
        for dict in list {
            
            var grocery = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: nil) as! Grocery
            
            
            grocery.draftName = dict["draftName"].stringValue
            grocery.itemID = dict["itemId"].stringValue
            grocery.itemName = dict["name"].stringValue
            grocery.itemDescription = dict["shortDescription"].stringValue
            grocery.itemCategory = dict["categoryPath"].stringValue
            grocery.itemImageURL = dict["thumbnailImage"].stringValue
            grocery.price = dict["salePrice"].doubleValue
            
            grocery.purchased = false
            
            groceries.append(grocery)
        }

        
        return groceries
    }
    
    class func stripped(string: String?) -> String {
        if let newString = string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            return newString
        }
        
        return ""
    }
}
