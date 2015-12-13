//
//  ViewController.swift
//  GameTrade
//
//  Created by Stuart Kumar on 10/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var yourBalanceIsLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cashLabel: UILabel!
    
    var coreDataStack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController!
    var tableData = [Stock]()
    var user: User!
    var userFetchedResultsController: NSFetchedResultsController!

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OwnedStock", forIndexPath: indexPath) as! OwnedStockCell
        
        cell.stock = tableData[indexPath.row]
        cell.sellSharesButton.tag = indexPath.row;
        cell.sellSharesButton.addTarget(self, action: "sellSharesAction:", forControlEvents: .TouchUpInside)

        
        return cell
    }

    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        code
//    }
//    
    //MARK: -ViewController
    
    @IBAction func sellSharesAction(sender: UIButton) {
        
        //let titleString = self.tableData[sender.tag].name
        
        let stock = tableData[sender.tag]
        user.sell(stock)
        let indexPath = tableView.indexPathForRowAtPoint(sender.center)!
        tableData.removeAtIndex(sender.tag)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        
        cashLabel!.text = "Cash: £\(user.cash!)"
        balanceLabel.text = "£\(getNetWorth())"
        
       tableView.reloadData()
        
        
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        case .Move:
            if indexPath != newIndexPath {
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
        }
    }

    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        coreDataStack.saveMainContext()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.rowHeight = 261
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Stock")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "sharePrice", ascending: false)
        ]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try fetchedResultsController.performFetch()
           // let users = fetchedResultsController.fetchedObjects! as! [Stock]
            
        }
        catch
        {
            fatalError("There was an error fetching the list of fooods!")
        }
        
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
        
        
        cashLabel!.text = "Cash: £\(user.cash!)"
        balanceLabel.text = "£\(getNetWorth())"
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.dataSource = self
        
        let fetchRequest = NSFetchRequest(entityName: "Stock")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "sharePrice", ascending: false)
        ]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try fetchedResultsController.performFetch()
            let users = fetchedResultsController.fetchedObjects! as! [Stock]
            tableData.removeAll()
            for user in users{
                
                if user.owned! != 0{
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
        
        if let _ = cashLabel{
            cashLabel!.text = "Cash: £\(user.cash!)"
            balanceLabel.text = "£\(getNetWorth())"
            self.view.backgroundColor = themeColorPrimary
            
            yourBalanceIsLabel.textColor = themeColorSecondary
            balanceLabel.textColor = themeColorSecondary
            tableView.separatorColor = themeColorSecondary
            tableView.backgroundColor = themeColorPrimary
            cashLabel.textColor = themeColorSecondary
        }
        
        print("Your net worth is " + "\(getNetWorth())" )
    }
    
   
    func getNetWorth()-> Float{
        
        var netWorth: Float = 0
        
        for stock in tableData{
            if let _ = stock.owned{
                
                let stockPrice = stock.sharePrice! as Float
                let sharesOwned = stock.owned! as Float
                print("Equity Holdings of " + stock.name! + ": \((stockPrice * sharesOwned))" +  " cash : \(user.cash!)")
                
                netWorth += (stockPrice * sharesOwned)
            }
        }
        
        netWorth += user.cash! as Float
        print("tableData.count == " + "\(tableData.count)")
        return netWorth
    }

    
}

