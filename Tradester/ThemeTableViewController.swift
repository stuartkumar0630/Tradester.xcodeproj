//
//  ThemeTableViewController.swift
//  GameTrade
//
//  Created by Stuart Kumar on 14/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit

class ThemeTableViewController: UITableViewController
{
    
    let gold = UIColor(red: 252.0 / 255.0, green:194.0/255.0, blue:0, alpha:1.0)
    
    let themeColors: [(String, UIColor, UIColor)] = [ ("Default", UIColor.whiteColor(), UIColor.blackColor()),
                        ("1985", UIColor.blackColor(), UIColor.greenColor()),
                        ("Sahota", UIColor.brownColor(), UIColor.orangeColor()),
                        ("Blue", UIColor.blueColor(), UIColor.greenColor()),
                        ("Gold", UIColor.whiteColor(), UIColor(red:0.988, green:0.761, blue:0, alpha:1.0)),
                        ("Ballet", UIColor.purpleColor(), UIColor(red:1, green:0.753, blue: 0.796, alpha:1.0)),
                        ("Reverse", UIColor.blackColor(), UIColor.whiteColor()),
                        ("Lava", UIColor.redColor(), UIColor.orangeColor()),
                        ("SpaceShip", UIColor.grayColor(), UIColor.purpleColor())
                        ]
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return themeColors.count
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        themeColorPrimary = themeColors[indexPath.row].1
        themeColorSecondary = themeColors[indexPath.row].2
        
        performSegueWithIdentifier("unwindToStocksAvailable", sender: self)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
                let cell = tableView.dequeueReusableCellWithIdentifier("ThemeCell", forIndexPath: indexPath) as! ThemeCell
        
        
                let theme = themeColors[indexPath.row]
        
                cell.themeNameLabel.text = theme.0
                cell.themeColorPrimary = theme.1
                cell.themeColorSecondary = theme.2
        
                // Configure the cell...
        
                return cell

    }
    
}
