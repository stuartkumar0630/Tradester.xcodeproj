//
//  OwnedStockCell.swift
//  GameTrade
//
//  Created by Stuart Kumar on 12/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit

class OwnedStockCell: UITableViewCell {
    
    var stock: Stock!{
        didSet{
            stockNameLabel.text = stock.name
            stockPriceLabel.text = "\(stock.sharePrice!)"
        }
    }
    
    
    @IBOutlet weak var stockNameLabel: UILabel!

    @IBOutlet weak var stockPriceLabel: UILabel!
    
    @IBOutlet weak var sellSharesButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sellSharesButton.layer.backgroundColor = UIColor(red: 79.0/255.0, green: 208.0/255.0, blue: 0/255.0, alpha: 1).CGColor
        sellSharesButton.layer.cornerRadius = 5
        
        backgroundColor = themeColorPrimary
        stockNameLabel.textColor = themeColorSecondary
        stockPriceLabel.textColor = themeColorSecondary
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }

}
