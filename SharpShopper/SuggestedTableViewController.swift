//
//  SuggestedTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/8/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class SuggestedTableViewController: UITableViewController, ClientAPIDelegate {

    var suggestedGroceries: [Grocery] = []
    var searchTerm: String?
    
    let walmartClient = WalmartAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")

        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.fetchNetworkGroceries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNetworkGroceries() {
        
        if let term = searchTerm {
            walmartClient.delegate = self
            walmartClient.searchByProductName(term)
        }
    }
    
    //MARK: - SSAPIDelegate Methods

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
        
        cell?.delegate = self
        
        return cell!
    }

    // MARK: - GroceryListUpdateDelegate Methods
    
    func didChooseGrocery(grocery: Grocery) {
        
    }
    
    func groceryListDataDidChange() {
        self.tableView.reloadData()
    }
}
