//
//  GroceryTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    
    var groceries = [Grocery]()
    
    var unpurchasedGroceries: [Grocery] {
        return (self.groceries.filter() { $0.purchased == false })
    }
    var purchasedGroceries: [Grocery] {
        return (self.groceries.filter() { $0.purchased == true })
    }
    
    let UN_PURCHASED_SECTION = 0
    let YES_PURCHASED_SECTION = 1
    let SUGGESTED_SECTION = 2
    
    lazy var suggestionsViewController = SuggestionsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Title logo
        let image = UIImage(named: "sharp-shopper-logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
     
        // Background legal pad image
        let backgroundImage = UIImage(named: "legal-pad")
        let bImageView = UIImageView(image: backgroundImage)
        bImageView.frame = self.tableView.frame
        self.tableView.backgroundView = bImageView
        
        
        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")
        
        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // 'Edit' and 'Add' buttons
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addGrocery")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Fetch list from Core Data
        CoreDataManager.sharedInstance.fetchGroceryList() {
            (groceries: [Grocery]) in
            
            println("Fetched My Grocery List from Core Data: \(groceries.count) items")
            
            self.groceries = groceries
            self.tableView.reloadData()
        }
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

            // Pull Grocery's name from the text field
            let textField = alert.textFields![0] as! UITextField
            var text = textField.text
            println("About to save grocery: \(text) into Core Data")
            
            // Save it into Core Data
            CoreDataManager.sharedInstance.saveNewGrocery(text, completionHandler: ({
                (grocery: Grocery) in
            
                println("Saved new Grocery to Core Data: \(grocery)")
                
                // Then reload the data for TableView
                self.groceries.append(grocery)
                self.tableView.reloadData()
                
                // TODO: load the viewcontroller to choose which Grocery from WalmartAPI or SupermarketAPI
            }))
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    // MARK: - TableView Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        if section == UN_PURCHASED_SECTION {
            return self.unpurchasedGroceries.count
        }
        else if section == YES_PURCHASED_SECTION {
            return self.purchasedGroceries.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell") as? GroceryTableViewCell
        
        if indexPath.section == UN_PURCHASED_SECTION {
            
            var grocery = self.unpurchasedGroceries[indexPath.row]
            cell?.assignGrocery(grocery)
        }
            
        else if indexPath.section == YES_PURCHASED_SECTION {
            var grocery = self.purchasedGroceries[indexPath.row]
            cell?.assignGrocery(grocery)
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var grocery: Grocery?
        
        if indexPath.section == UN_PURCHASED_SECTION {
            
            self.suggestionsViewController.grocery = self.unpurchasedGroceries[indexPath.row]
            self.navigationController?.pushViewController(self.suggestionsViewController, animated: true)
        }
            
        else if indexPath.section == YES_PURCHASED_SECTION {
            self.suggestionsViewController.grocery = self.purchasedGroceries[indexPath.row]
            self.navigationController?.pushViewController(self.suggestionsViewController, animated: true)
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
            
            var grocery: Grocery?
            if indexPath.section == UN_PURCHASED_SECTION {
                grocery = self.unpurchasedGroceries[indexPath.row]
            }
                
            else if indexPath.section == YES_PURCHASED_SECTION {
                grocery = self.purchasedGroceries[indexPath.row]
            }
            
            if let g = grocery {
                CoreDataManager.sharedInstance.deleteGrocery(g, completionHandler: ({
                    (error: NSError?) in
                    println("Deleted grocery")
                    if error != nil {
                        println(error!.localizedDescription)
                    }
                    
                    if let index = find(self.groceries, g) {
                        self.groceries.removeAtIndex(index)
                    }
                    
                    // Then reload the data for TableView
                    self.tableView.reloadData()
                }))
            }
        }
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    
}
