//
//  GroceryList.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/31/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit
import Foundation
import CoreData

// TODO: rename class to indicate CoreData interaction i.e. CoreGroceryList, or SSManagedGroceryList
class GroceryList: NSObject, NSXMLParserDelegate {
    
    var items: [Grocery] = []
    var delegate: GroceryListUpdateDelegate?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var purchasedGroceries: [Grocery]
    {
        get
        {
            return items.filter({$0.purchased})
        }
    }
    
    var unpurchasedGroceries: [Grocery]
    {
        get
        {
            return items.filter({!$0.purchased})
        }
    }
    
    override init() {
        super.init()
    }
    
    init(data: NSData) {
        super.init()
        
        // Parse Data
        self.parseJSON(data)
    }
    
    func parseJSON(data: NSData) {
        
        var err: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as! NSDictionary
        if err != nil {
            println("JSON Error \(err!.localizedDescription)")
        }
        
        let json = JSON(jsonResult)
        
        let list: Array<JSON> = json["items"].arrayValue
        for dict in list {
            
            let itemID = dict["itemId"].stringValue
            let name = dict["name"].stringValue
            let msrp = dict["msrp"].stringValue
            let salePrice = dict["salePrice"].doubleValue
            let description = dict["shortDescription"].stringValue
            let image = dict["thumbnailImage"].stringValue
            let category = dict["categoryPath"].stringValue
            
            var grocery = Grocery.createInManagedObjectContext(nil, itemID: itemID, itemName: name, itemDescription: description, itemCategory: category, itemImageURL: image, purchased: false, price: salePrice)
            
            self.items.append(grocery)
        }
        
    }
    func fetchGroceriesFromCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Grocery")
        
        fetchRequest.predicate = NSPredicate(format: "isOnGroceryList = true")
        
        // Fetch all groceries from Core Data
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Grocery] {
            items = fetchResults
            println("Finished fetching groceries from Core Data")
        }
    }
    
    func addGrocery(grocery: Grocery) {
        // Add new grocery to list

        grocery.isOnGroceryList = true
        
        // Append this grocery to this GroceryList
        self.items.append(grocery)
        
        // Save in Core Data
        self.appDelegate.saveContext()
        
        // Tell delegate that data has changed
        self.delegate?.groceryListDataDidChange()
    }
    
    func deleteGrocery(grocery: Grocery) {
        
        // Delete it from managed object context
        self.managedObjectContext?.deleteObject(grocery)
        
        // Refresh list from Core Data
        self.fetchGroceriesFromCoreData()
        
        // Tell delegate that data has changed
        self.delegate?.groceryListDataDidChange()
    }
    
    func didUpdateGrocery(grocery: Grocery, property: String, newValue: String) {
        
        var request = NSFetchRequest(entityName: "Grocery")

        
        //FIXME didUpdateGrocery
    }
}
