//
//  ThemeCell.swift
//  GameTrade
//
//  Created by Stuart Kumar on 14/11/2015.
//  Copyright © 2015 Stuart Kumar. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    
    @IBOutlet weak var themeNameLabel: UILabel!
    
    @IBOutlet weak var themeColorIcon: UIView!
    
    var themeColorPrimary: UIColor!{
        didSet{
            themeColorIcon.backgroundColor = themeColorPrimary
            themeColorIcon.layer.borderWidth = 5
            themeColorIcon.layer.cornerRadius = 5
            
        }
    }
    
    var themeColorSecondary: UIColor!{
        didSet{
            themeColorIcon.layer.borderColor = themeColorSecondary.CGColor
            
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
