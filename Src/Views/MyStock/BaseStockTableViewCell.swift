//
//  BaseStockTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 20/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class BaseStockTableViewCell : UITableViewCell {
    
    
    @IBOutlet internal weak var viewContainer: UIView!
    
    @IBOutlet internal weak var imageIllustration: UIImageView!
    @IBOutlet internal weak var labelTitle: UILabel!
    @IBOutlet internal weak var labelDescription: UILabel!
    
    @IBOutlet internal weak var labelDateBought: UILabel?
    @IBOutlet internal weak var labelDateExpired: UILabel?
    
    
    private(set) var currentGroup: StockedItemsGroup!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    
    func updateGroup(g: StockedItemsGroup) {
        
        currentGroup = g
        
        imageIllustration.image = g.item.illustration
        
        if g.quantity <= 1 {
            labelTitle.text = g.item.title
        } else {
            labelTitle.text = g.item.title + " x" + g.quantity.description
        }
        
        labelDescription.text = g.item.description
        
        let f = DateFormatter()
        f.dateFormat = "EEE dd/MM/yy"
        labelDateBought?.text = f.string(from: g.daysBought)
        
        updateExpiringViews()
        
    }
    
    
    internal func updateExpiringViews() {
        
        if currentGroup.isConsumed || currentGroup.isExpired() {
            viewContainer.backgroundColor = ThemeManager.Color.transparentDark
        } else {
            viewContainer.backgroundColor = ThemeManager.Color.transparentLight
        }
        
        
        if let labelDateExpired = labelDateExpired {
        
            if currentGroup.isConsumed {
                labelDateExpired.textColor = ThemeManager.Color.themeSecondary
            } else if currentGroup.isExpired() {
                labelDateExpired.textColor = ThemeManager.Color.expired
            } else if currentGroup.isAboutToExpire() {
                labelDateExpired.textColor = ThemeManager.Color.warning
            } else {
                labelDateExpired.textColor = ThemeManager.Color.themeSecondary
            }
            
            if let dateExpired = currentGroup.getExpiring() {
                
                let f = DateFormatter()
                f.dateFormat = "EEE dd/MM/yy"
                labelDateExpired.text = f.string(from: dateExpired)
                
            } else {
                
                labelDateExpired.text = "-"
            }
        }
        
    }
    
    
}

