//
//  SuggestionsTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/8/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class SuggestionsTableViewController: UITableViewController, ClientAPIDelegate {

    var suggestedGroceries: [Grocery] = []
    
    var suggestionTerm: String?
    
    var walmartClient: WalmartAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("SuggestionsTableViewController viewDidLoad")
        self.walmartClient = WalmartAPI(delegate: self)
        
        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")

        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        self.performSearchForTerm(suggestionTerm)
//        self.fetchNetworkGroceries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performSearchForTerm(term: String?) {
    
        if term != nil && self.walmartClient != nil {
            println("SuggestionsViewController performing search for term")
            walmartClient!.searchByProductName(term!)
        }
        
    }
    

    //MARK: - ClientAPIDelegate Methods

    func foundNetworkGroceries(groceryListData data: NSData) {
     
        // Initialize a GroceryList with the data
        var groceryList = GroceryList(data: data)
        
        // Use the groceries for this TableView
        self.suggestedGroceries = groceryList.items
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

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
        
//        cell?.delegate = self
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    // MARK: - GroceryListUpdateDelegate Methods
    
    func didChooseGrocery(grocery: Grocery) {
        
    }
    
    func groceryListDataDidChange() {
        self.tableView.reloadData()
    }
}
