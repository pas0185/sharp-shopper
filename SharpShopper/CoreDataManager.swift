//
//  CoreDataManager.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/21/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit
import CoreData

private let _CoreDataManagerInstance = CoreDataManager()

class CoreDataManager: NSObject {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    class var sharedInstance: CoreDataManager {
        return _CoreDataManagerInstance
    }
    
    
    func fetchGroceryList(block: (list: GroceryList) -> Void) {
        
        var groceries = [Grocery]()
        
        var fetchRequest = NSFetchRequest(entityName: "Grocery")
        
        var error: NSError?
        
        // Send fetch request
        groceries = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [Grocery]
        
        if error != nil {
            println(error!.localizedDescription)
        }
        
        var gList = GroceryList(groceries: groceries)
        
        // Notify the fetch is finished to the completion block
        block(list: gList)
    }
    
    func saveNewGrocery(groceryName: String, completionHandler: (grocery: Grocery) -> Void) {

        var grocery = Grocery.createInManagedObjectContext(managedObjectContext!, itemID: "", itemName: groceryName, itemDescription: "", itemCategory: "", itemImageURL: "", purchased: false, price: 0)
        
        self.saveContext()
        
        completionHandler(grocery: grocery)
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
            }
        }
    }
}
