//
//  Stock+CoreDataProperties.swift
//  Tradester
//
//  Created by Stuart Kumar on 04/12/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Stock {

    @NSManaged var sharePrice: NSDecimalNumber?
    @NSManaged var owned: NSNumber?
    @NSManaged var name: String?

}
