//
//  SuggestedTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/8/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class SuggestedTableViewController: UITableViewController { // GroceryListUpdateDelegate { // For updating purchased status, move to 'My List'

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

        var apiClient = SupermarketAPI()
        var groceries = apiClient.searchByProductName("apple")
        
        println("fetched \(groceries.count) groceries")
        
        self.suggestedGroceries = groceries as AnyObject as! [Grocery]
        println("converted \(self.suggestedGroceries.count) groceries")
        self.tableView.reloadData()
        
//        var xmlObj = XMLParser()
//        var feeder = xmlObj.xmlParse()
//        
//        println(feeder)

//        var data = SupermarketAPI.getGroceryData("apple")
//        var url = SupermarketAPI.getGroceryURL("apple")
//        var fgList = GroceryList(url: url)
//        println("Fetched data: \(data)")
//        
//        var fetchedGroceryList = GroceryList(XMLData: data)
        
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
        
//        cell.delegate = self
        return cell!

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
