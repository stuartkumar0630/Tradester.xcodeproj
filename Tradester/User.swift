//
//  User.swift
//  Tradester
//
//  Created by Stuart Kumar on 04/12/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func buy(stock: Stock, balance: Float){
        
        let sharesPurchased = (1000 / (stock.sharePrice! as Float))
        print("\(sharesPurchased)" + "of" + (stock.name! as String))
        
        let floatBalance : Float = cash!.floatValue
        //let floatStockPrice: Float = stock.sharePrice!.floatValue
        
        if floatBalance >= Float(1000) {
            
            
            
            if let _ = stock.owned{
                
                let shareOwnedBefoew = stock.owned!.floatValue
                
                stock.owned = NSNumber(float: (shareOwnedBefoew + sharesPurchased))
                
                
            }else{
                
                stock.owned = sharesPurchased
            }
            
            let cashBefore: Int = cash!.integerValue
            cash = NSDecimalNumber(integer: (cashBefore - 1000))
            
        }
        
    }
    
    
    func sell(stock: Stock){
        
        
        let amountSold = stock.owned!.floatValue * stock.sharePrice!.floatValue
        let cashBefore = cash!.floatValue
        cash = NSDecimalNumber(float: (cashBefore + amountSold))
        stock.owned = nil
        
    }
    
    
    
}
