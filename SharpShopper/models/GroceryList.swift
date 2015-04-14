//
//  GroceryList.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/31/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class GroceryList: NSObject, NSXMLParserDelegate {
    
     var groceryList: [Grocery] = []

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
            groceryList = fetchResults
        }
    }
    
    
    
    func addGrocery(grocery: Grocery) {
        // Add new grocery to list
        self.groceryList.append(grocery)
        
        // Insert into Core Data

        let coreGrocery = NSEntityDescription.insertNewObjectForEntityForName("Grocery", inManagedObjectContext: self.managedObjectContext!) as! Grocery


        // ASSIGN FIELDS FROM EXISTING GROCERY OBJECT??
        
        
        // ***** TODO ***** //
        var attributes = GroceryParser.parseToDictionary(grocery)

        
        // Save our changes
        self.saveToCoreData()
    }
    
    // MARK: - Core Data
    func saveToCoreData() {
        
        if let dataMgr = CoreDataManager.sharedManager() {
            dataMgr.saveDataInManagedContextUsingBlock(nil)
        }
    }
    
    class func restoreFromCoreData(delegate: NSFetchedResultsControllerDelegate) -> GroceryList {
    
        // Get the NSFetchedReultsController from the Core Data Manager
        
        var sortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
//        var sectionNameKeyPath = ""
//        var predicate = NSPredicate(format: "Grocery.name == %@")
        
        if let fetchedResultsController = CoreDataManager.sharedManager().fetchEntitiesWithClassName("Grocery", sortDescriptors: [sortDescriptor], sectionNameKeyPath: nil, predicate: nil) {
            
            var error: NSError?
            fetchedResultsController.performFetch(&error)
            
            if error != nil {
                println("Error restoring Groceries from Core Data")
            }
            
            // TODO: something with fetchedResultsController
            fetchedResultsController.delegate = delegate
            
        }
        
        return GroceryList()
    }
    
    
    // MARK: - Helper Methods
    
    func purchasedGroceries() -> [Grocery] {
        // Filter list to return only ones that have been purchased
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
