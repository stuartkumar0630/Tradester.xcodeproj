//
//  AppDelegate.swift
//  GameTrade
//
//  Created by Stuart Kumar on 10/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var fetchedResultsController: NSFetchedResultsController!


    lazy var coreDataStack = CoreDataStack()
    
    let dowJ = ["JPM", "GOOG", "GS", "FB", "SBUX", "YHOO", "MSFT", "NKE", "MMM", "AXP", "BA", "CAT", "CVX", "CSCO", "KO", "DIS", "DD", "XOM", "GE", "HD", "IBM", "INTC", "JNJ", "MCD", "MRK","PG", "TRV", "VZ", "V", "WMT" ]


    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
      
        
        let fetchRequest = NSFetchRequest(entityName: "Stock")
        //fetchRequest.predicate = NSPredicate(format: "calories >= 200 AND calories <= 400")
        
        
        let sortDescriptor = NSSortDescriptor(key: "sharePrice", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
        
        do {
            let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count == 0 {
                addTestData()
            }else{
                refreshStockPrices()
            }
        } catch {
            fatalError("Error fetching data!")
        }
        
//        do{
//            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Stock]{
//                
//                for result in results{
//                    print(result.name!)
//                    
//                    // + "carbohydrate:\(result.carbohydrate!)-" + "protein:\(result.protein!)-" + "fat:\(result.fat!)-" + "vegetarian:\(result.vegetarian!)")
//                    
//                }
//                
//                
//            }
//        }catch{
//            fatalError("There was a fetch error!")
//        }
        
        
//        if let login = window?.rootViewController! as? StockTableViewController{
//            login.coreDataStack = coreDataStack
//            
//        }

        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let child = child as? UINavigationController, top = child.topViewController {
                    if top.respondsToSelector("setCoreDataStack:") {
                        top.performSelector("setCoreDataStack:", withObject: coreDataStack)
                    }
                }
            }
        }

        
        return true
    }
    
    var b = 0
    
    func refreshStockPrices(){
        
        let fetchRequest = NSFetchRequest(entityName: "Stock")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "sharePrice", ascending: false)
        ]
        
        do
        {
            try fetchedResultsController.performFetch()
            let stocks = fetchedResultsController.fetchedObjects! as! [Stock]
            
            for stock in stocks{
                
                stock.sharePrice = NSDecimalNumber(double: getStockPrice(stock.name!))
            }
            
            
            
        }
        catch
        {
            fatalError("There was an error fetching the list of fooods!")
        }
        
        
    }
    
    func addTestData(){
        
        guard let entity = NSEntityDescription.entityForName("Stock", inManagedObjectContext: coreDataStack.managedObjectContext)
            else{
                fatalError("Could not find entity description!")
        }
        
        guard let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: coreDataStack.managedObjectContext)
            else{
                fatalError("Could not find entity description!")
        }
        
        
        let user = User(entity: userEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        user.cash = 10000.00
        
        for stok in dowJ{
            let stock = Stock(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            stock.name = stok
            stock.sharePrice = NSDecimalNumber(double: getStockPrice(stok))
        }
        
    }
    
    func getDayOfWeek(today:String)->Int? {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
    }
    
    func getNearestTradingDay(weekday: Int)->String{
        
        var value = 0
        
        switch weekday{
        case 1: // Day is Sunday
            value = -2 // Find data for Friday
        case 2: // Day is Monday
            value = -3 // Find data for Friday
            print("Today is Monday")
        case 3: // Day is Tuesday
            value = -1 // Find data for Monday
        case 4: // Day is Wednesday
            value = -1 // Find data for Tuesday
        case 5: // Day is Thursday
            value = -1 // Find data for Wednesday
        case 6: // Day is Friday
            value = -1 // Find data for Thursday
        case 7: // Day is Saturday
            value = -1 // Find data for Friday
        default:
            fatalError("Could not find day of week")
        }
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.Day, value: value, toDate: NSDate(), options: [])
        let dateTimePrefix: String = formatter.stringFromDate(yesterday!)
        
        return dateTimePrefix

    }
    
    func getStockPrice(stock: String)->Double{
        
        var returnValue: Double = 0
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateTimePrefix: String = formatter.stringFromDate(NSDate())
        
        var endpoint = NSURL()
        
        if let weekday = getDayOfWeek(dateTimePrefix) {
            
            dateTimePrefix = getNearestTradingDay(weekday)
            
        } else {
            print("bad input")
        }
        
        print("Today's nearest trading day is" + dateTimePrefix)
        
        
         endpoint = NSURL(string: "https://www.quandl.com/api/v3/datasets/WIKI/" + stock + "/data.json?start_date=" + dateTimePrefix)!
        
        let data = NSData(contentsOfURL: endpoint)
        
        
        do
        {
            if data != nil{
                
                let object:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                let dict = object as! NSDictionary
                
                print(object!)
                
                let outmostDictionary = object as! NSDictionary
                let datasetData = outmostDictionary.valueForKey("dataset_data") as! NSDictionary
                let stockDataArray = datasetData.valueForKey("data") as! NSArray
                print(stockDataArray)
                let stockPriceData = stockDataArray[0] as! NSArray
                let quote = stockPriceData[11] as! NSNumber
                returnValue = quote as! Double
                print(quote)
                
                
                
                
            }else{
                print("data == nil")
            }
            
        } catch let caught as NSError {
            print(caught)
        } catch {
            // Something else happened.
            // Insert your domain, code, etc. when constructing the error.
            let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
            print(error)
            
        }
        
        return returnValue
        
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveMainContext()
    }

    // MARK: - Core Data stack

//    lazy var applicationDocumentsDirectory: NSURL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "The-Kumar-Corporation.GameTrade" in the application's documents Application Support directory.
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls[urls.count-1]
//    }()
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = NSBundle.mainBundle().URLForResource("GameTrade", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
//        var failureReason = "There was an error creating or loading the application's saved data."
//        do {
//            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)//l
//        } catch {
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//
//            dict[NSUnderlyingErrorKey] = error as NSError
//            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
//            abort()
//        }
//        
//        return coordinator
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
//        }
//    }
//
}

