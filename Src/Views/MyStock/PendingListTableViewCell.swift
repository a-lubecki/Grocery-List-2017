//
//  ArchivedListTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class PendingListTableViewCell : BaseListTableViewCell {
    
    
    @IBOutlet internal weak var labelNew: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelNew.font = ThemeManager.Font.getFontBold(size: 13)
        
        labelNew.textColor = ThemeManager.Color.themeSecondary
        labelNew.backgroundColor = ThemeManager.Color.notification
        
        labelNew.clipsToBounds = true
        
        labelNew.layoutIfNeeded()
        labelNew.layer.cornerRadius = 0.5 * labelNew.bounds.height
        
    }
    
    
}

