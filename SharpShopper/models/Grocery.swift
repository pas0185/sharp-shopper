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
    
    var name: String {
        
        if self.itemName != ""{
            return itemName
        }
        
        if self.draftName != ""{
            return draftName
        }
        
        return ""
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
//    class func createInManagedObjectContext(moc: NSManagedObjectContext?, itemID: String?, itemName: String?, itemDescription: String?, itemCategory: String?, itemImageURL: String?, purchased: Bool, price: Double?) -> Grocery {
//        
//        var myMoc = moc
//        
//        if myMoc == nil {
//            println("Using a scrap managed object context")
//            myMoc = NSManagedObjectContext()
//        }
//        
//        if let entity = NSEntityDescription.entityForName("Grocery", inManagedObjectContext: myMoc!)
//        {
//        
//            var newGrocery = NSManagedObject(entity: entity, insertIntoManagedObjectContext: nil) as! Grocery
//            
//    //        let newGrocery = NSEntityDescription.insertNewObjectForEntityForName("Grocery", inManagedObjectContext: moc) as! Grocery
//            
//            newGrocery.itemID = stripped(itemID)
//            newGrocery.itemName = stripped(itemName)
//            newGrocery.itemDescription = stripped(itemDescription)
//            newGrocery.itemCategory = stripped(itemCategory)
//            newGrocery.itemImageURL = stripped(itemImageURL)
//            
//            newGrocery.purchased = purchased
//            newGrocery.price = price!
//            
//            return newGrocery
//        }
//        
//        return Grocery()
//    }
    
    class func stripped(string: String?) -> String {
        if let newString = string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            return newString
        }
        
        return ""
    }
}
