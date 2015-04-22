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
    
    func fetchGroceryList(block: (groceries: [Grocery]) -> Void) {
        
        var groceries = [Grocery]()
        
        var fetchRequest = NSFetchRequest(entityName: "Grocery")
        
        var error: NSError?
        
        // Send fetch request
        groceries = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [Grocery]
        
        if error != nil {
            println(error!.localizedDescription)
        }
        
        // Notify the fetch is finished to the completion block
        block(groceries: groceries)
    }
    
    func saveNewGrocery(groceryName: String, completionHandler: (grocery: Grocery) -> Void) {

        let entity = NSEntityDescription.entityForName("Grocery", inManagedObjectContext: self.managedObjectContext!)
        var grocery = Grocery(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext!)
        grocery.draftName = Utility.stripped(groceryName)
        grocery.itemName = ""
        grocery.itemCategory = ""
        grocery.itemDescription = ""
        grocery.itemID = ""
        grocery.itemImageURL = ""

        self.saveContext()
        
        completionHandler(grocery: grocery)
    }
    
    func deleteGrocery(grocery: Grocery, completionHandler: (error: NSError?) -> Void) {
        
        managedObjectContext!.deleteObject(grocery)
        
        self.saveContext()
        
        completionHandler(error: nil)
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
