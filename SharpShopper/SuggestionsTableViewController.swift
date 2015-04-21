//
//  SuggestionsTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/8/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class SuggestionsTableViewController: UITableViewController {

    var suggestedGroceries = [Grocery]()
    var suggestionTerm: String?
    let walmartClient = WalmartAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Table View
        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")
        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Remove all old groceries
        self.suggestedGroceries.removeAll(keepCapacity: true)
        
        // Go fetch suggestions for the term
        if let term = suggestionTerm {
            self.performSearchForTerm(term)
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.performSearchForTerm(suggestionTerm)
    }
    
    func performSearchForTerm(term: String?) {
    
        self.suggestedGroceries.removeAll(keepCapacity: true)
        
        if let searchTerm = term {
            println("SuggestionsViewController performing search for term: \(searchTerm)")
            walmartClient.searchByProductName(searchTerm) {
                (groceryData: NSData) in
                
                // Parse the grocery data
                var groceries = Grocery.arrayFromJSON(groceryData)
                
                // Assign these groceries for the TableView
                self.suggestedGroceries = groceries
                
                // Reload TableView
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    //MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.suggestedGroceries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell") as? GroceryTableViewCell
        
        var grocery = self.suggestedGroceries[indexPath.row]
        cell?.assignGrocery(grocery)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var grocery = self.suggestedGroceries[indexPath.row]
        
        
    }


}
