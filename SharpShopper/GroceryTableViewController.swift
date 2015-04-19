//
//  GroceryTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController, GroceryListUpdateDelegate {
    
    let UN_PURCHASED_SECTION = 0
    let YES_PURCHASED_SECTION = 1
    let SUGGESTED_SECTION = 2
    
    var groceryList = GroceryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")
        
        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.groceryList.delegate = self
        self.groceryList.fetchGroceriesFromCoreData()

        // 'Edit' and 'Add' buttons
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addGrocery")
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
            
            var groceryName = textField.text
            if let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                var grocery = Grocery.createInManagedObjectContext(moc, itemID: "", itemName: groceryName, itemDescription: "", itemCategory: "", itemImageURL: "", purchased: false, price: 0)
                
                self.groceryList.addGrocery(grocery)
                self.tableView.reloadData()
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        if section == UN_PURCHASED_SECTION {
            return self.groceryList.unpurchasedGroceries.count
        }
        else if section == YES_PURCHASED_SECTION {
            return self.groceryList.purchasedGroceries.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell") as? GroceryTableViewCell
        
        if indexPath.section == UN_PURCHASED_SECTION {
            var grocery = self.groceryList.unpurchasedGroceries[indexPath.row]
            cell?.assignGrocery(grocery)
        }
            
        else if indexPath.section == YES_PURCHASED_SECTION {
            var grocery = self.groceryList.purchasedGroceries[indexPath.row]
            cell?.assignGrocery(grocery)
        }
        
        cell?.delegate = self
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == UN_PURCHASED_SECTION {
            var grocery = self.groceryList.unpurchasedGroceries[indexPath.row]
        }
            
        else if indexPath.section == YES_PURCHASED_SECTION {
            var grocery = self.groceryList.purchasedGroceries[indexPath.row]
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return true because we will allow users to add and delete groceries
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the grocery from the list
            
            if indexPath.section == UN_PURCHASED_SECTION {
                let grocery = self.groceryList.unpurchasedGroceries[indexPath.row]
                self.groceryList.deleteGrocery(grocery)
                
            }
                
            else if indexPath.section == YES_PURCHASED_SECTION {
                let grocery = self.groceryList.purchasedGroceries[indexPath.row]
                self.groceryList.deleteGrocery(grocery)
            }
            
            tableView.reloadData()
        }
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
//            var newGrocery = Grocery()
//            groceryList.append(newGrocery)
            
            tableView.reloadData()
            
        }    
    }
    
    // MARK: - GroceryListUpdateDelegate Methods
    
    func didAddToList(grocery: Grocery) {
        
        self.groceryList.addGrocery(grocery)
    }
    
    func didPurchase(grocery: Grocery) {
        //FIXME unimplemented didPurchase function
    }
    
    func didUnPurchase(grocery: Grocery) {
        //FIXME unimplemented didUnPurchase function
    }
    
    
    func didChooseGrocery(grocery: Grocery) {
        
        grocery.purchased = !grocery.purchased
        self.tableView.reloadData()
    }
    
    func groceryListDataDidChange() {
        self.tableView.reloadData()
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
    
}
