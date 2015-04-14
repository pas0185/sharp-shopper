//
//  GroceryTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class GroceryTableViewController: UITableViewController, /* GroceryListUpdateDelegate, */ NSFetchedResultsControllerDelegate {
    
    var groceryList = GroceryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groceryList.fetchGroceries()
        
//        groceryList.makeDummyList()
        
        
//        var userGroceryList = GroceryList.restoreFromCoreData(self)

        // Add an 'add group' button to navbar
        var addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addGrocery")
        self.navigationItem.rightBarButtonItem = addButton

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func addGrocery() {
        
        // Prompt user for name of new grocery
        let alert = UIAlertController(title: "New Grocery", message: "Add a new grocery to your list", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            
            textField.autocapitalizationType = .Words
            textField.autocorrectionType = .Yes
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
            let textField = alert.textFields![0] as! UITextField
            
            var grocery = Grocery()
            grocery.name = textField.text
            
            self.groceryList.addGrocery(grocery)
            self.tableView.reloadData()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func changedPurchasedStatus() {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func testGetGroceryData() {
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        if section == 0 {
            return self.groceryList.unpurchasedGroceries().count
        }
        else if section == 1 {
            return self.groceryList.purchasedGroceries().count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let identifier = "groceryTableCell"
        var cell: GroceryTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? GroceryTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? GroceryTableViewCell
        }
        
        
        if indexPath.section == 0 {
            cell.assignGrocery(self.groceryList.unpurchasedGroceries()[indexPath.row])
        }
            
        else if indexPath.section == 1 {
            cell.assignGrocery(self.groceryList.purchasedGroceries()[indexPath.row])
        }
        
//        cell.delegate = self
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        
        // Return true because we will allow users to add and delete groceries
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Delete grocery from array
//            groceryList.removeAtIndex(indexPath.row)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            var newGrocery = Grocery()
            newGrocery.name = "Bacon"
            newGrocery.points = 50
//            groceryList.append(newGrocery)
            
            tableView.reloadData()
            
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
