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
    
    func fetchGroceriesFromCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Grocery")
        
        // Have purchased/unpurchased separated at the git go
        let sortDescriptor = NSSortDescriptor(key: "purchased", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Fetch all groceries from Core Data
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Grocery] {
            items = fetchResults
            println("Finished fetching groceries from Core Data")
        }
    }
    
    func addGrocery(grocery: Grocery) {
        // Add new grocery to list

        if let moc = self.managedObjectContext {
            // Create this grocery in managed core data
            var grocery = Grocery.createInManagedObjectContext(moc, grocery: grocery)
            
            // Append this grocery to this GroceryList
            self.items.append(grocery)
            
            // Save in Core Data
            self.appDelegate.saveContext()
            
            // Tell delegate that data has changed
            self.delegate?.groceryListDataDidChange()
        }
    }
    
    func deleteGrocery(grocery: Grocery) {
        
        // Delete it from managed object context
        self.managedObjectContext?.deleteObject(grocery)
        
        // Refresh list from Core Data
        self.fetchGroceriesFromCoreData()
        
        // Tell delegate that data has changed
        self.delegate?.groceryListDataDidChange()
    }    
}
