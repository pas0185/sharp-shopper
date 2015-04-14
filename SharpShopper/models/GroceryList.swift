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

// TODO: rename class to indicate CoreData interaction ie CoreGroceryList SSManagedGroceryList
class GroceryList: NSObject, NSXMLParserDelegate {
    
     var items: [Grocery] = []

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
 
    
    override init() {
        super.init()
    }
    
    func makeDummyList() {
    
        if let moc = self.managedObjectContext {
            
            Grocery.createInManagedObjectContext(moc, itemID: "", itemName: "Juicy Fruit", itemDescription: "", itemCategory: "Juice", itemImageURL: "", purchased: false, price: 3.43)
            
            Grocery.createInManagedObjectContext(moc, itemID: "", itemName: "Oranges", itemDescription: "", itemCategory: "Fruits", itemImageURL: "", purchased: false, price: 1.27)
            
            moc.save(nil)
        }
    }
    
    func fetchGroceries() {
        let fetchRequest = NSFetchRequest(entityName: "Grocery")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Grocery] {
            items = fetchResults
        }
    }
    
    
    
    func addGrocery(grocery: Grocery) {
        // Add new grocery to list

        if let moc = self.managedObjectContext {
            // Create this grocery in managed core data
            var grocery = Grocery.createInManagedObjectContext(moc, grocery: grocery)
            
            // Append this grocery to this GroceryList
            self.items.append(grocery)
        }
    }
    
    // MARK: - Helper Methods
    
    func purchasedGroceries() -> [Grocery] {
        // Filter list to return only ones that have been purchased
        var purchasedList: [Grocery] = []
        for grocery in self.items {
            if grocery.purchased {
                purchasedList.append(grocery)
            }
        }
        
        return purchasedList
    }
    
    func unpurchasedGroceries() -> [Grocery] {
        var unpurchasedList: [Grocery] = []
        
        for grocery in self.items {
            if !grocery.purchased {
                unpurchasedList.append(grocery)
            }
        }
        
        return unpurchasedList
    }

}
