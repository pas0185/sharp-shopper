//
//  SuggestedTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/8/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class SuggestedTableViewController: UITableViewController, GroceryListUpdateDelegate {

    var suggestedGroceries: [Grocery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")

        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.fetchNetworkGroceries()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchNetworkGroceries() {

        var client = WalmartAPI()
        client.searchByProductName("crackers")
        
        
//        var apiClient = SupermarketAPI()
//        var groceries = apiClient.searchByProductName("apple")
//        
//        println("fetched \(groceries.count) groceries")
//        
//        self.suggestedGroceries = groceries as AnyObject as! [Grocery]
//        println("converted \(self.suggestedGroceries.count) groceries")
//        self.tableView.reloadData()
        
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
