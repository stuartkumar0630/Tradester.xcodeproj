//
//  StockCell.swift
//  GameTrade
//
//  Created by Stuart Kumar on 10/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {
    
    var stock: Stock!{
        didSet{
            stockNameLabel.text = stock.name
            stockPriceLabel.text = "\(stock.sharePrice!)"
        }
    }
    
    
    @IBOutlet weak var stockNameLabel: UILabel!
    
    @IBOutlet weak var stockPriceLabel: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buyButton.layer.backgroundColor = UIColor(red: 79.0/255.0, green: 208.0/255.0, blue: 0/255.0, alpha: 1).CGColor
        buyButton.layer.cornerRadius = 5
        backgroundColor = themeColorPrimary
        stockNameLabel.textColor = themeColorSecondary
        stockPriceLabel.textColor = themeColorSecondary

        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    
    

}
