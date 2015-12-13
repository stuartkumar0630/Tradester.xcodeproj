//
//  StockTableViewController.swift
//  GameTrade
//
//  Created by Stuart Kumar on 10/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit
import CoreData

class StockTableViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController!
    var userFetchedResultsController: NSFetchedResultsController!
    var tableData = [Stock]()
    var user: User!

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        tableView.separatorColor = themeColorSecondary
        return tableData.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StockCell", forIndexPath: indexPath) as! StockCell

        cell.stock = tableData[indexPath.row]
        cell.buyButton.tag = indexPath.row;
        cell.buyButton.addTarget(self, action: "buyButtonAction:", forControlEvents: .TouchUpInside)
        
        
        
        
        return cell
        
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        coreDataStack.saveMainContext()
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem)
    {
        self.tableView.reloadData()
    }
    
    @IBAction func done(segue: UIStoryboardSegue){
        self.tableView.reloadData()
    }

    //MARK: -ViewController
    
    @IBAction func buyButtonAction(sender: UIButton) {
        
        //let titleString = self.tableData[sender.tag].name
        
        let stock = tableData[sender.tag]
        
        user.buy(stock, balance: (user.cash! as Float) - 999.99)
        
        if (user.cash! as Float) >= 1000{
        
        let indexPath = tableView.indexPathForRowAtPoint(sender.center)!
        tableData.removeAtIndex(sender.tag)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.reloadData()
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableData.count == 0{
        reloadTableDataArray()
        }
        tableView.separatorColor = themeColorSecondary
        
        setUpUser()
        
        
    }
    
    func reloadTableDataArray(){
        
            tableData.removeAll()
            let fetchRequest = NSFetchRequest(entityName: "Stock")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "sharePrice", ascending: false)
            ]
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
            do
            {
                try fetchedResultsController.performFetch()
                let users = fetchedResultsController.fetchedObjects! as! [Stock]
                for user in users{
                    print(user.name)
                    print(user.owned)
                    if user.owned! == 0{
                        tableData.append(user)
                    }
                }
            }
            catch
            {
                fatalError("There was an error fetching the list of fooods!")
            }
            
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

    }
    
    override func viewDidAppear(animated: Bool) {
        reloadTableDataArray()
        if tableView != nil{
            tableView.reloadData()
            reloadTableDataArray()
        }
        //print(tableData[0])
        
    }
    
    func setUpUser(){
        let userfetchRequest = NSFetchRequest(entityName: "User")
        userfetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "cash", ascending: false)
        ]
        
        self.userFetchedResultsController = NSFetchedResultsController(fetchRequest: userfetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try userFetchedResultsController.performFetch()
            let users = userFetchedResultsController.fetchedObjects! as! [User]
            print("Success")
            for usser in users{
                user = usser
                print(user.cash!)
            }
            
        }
        catch
        {
            fatalError("There was an error fetching the list of fooods!")
        }

    }
    
    }
