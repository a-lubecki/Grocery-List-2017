//
//  BaseListTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class BaseListTableViewCell : UITableViewCell {
    
    
    @IBOutlet internal weak var labelTitle: UILabel!
    @IBOutlet internal weak var labelSubtitle: UILabel!
    
    
    private(set) var currentList: ShoppingList!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        labelTitle.text = nil
        labelSubtitle.text = nil
        
    }
    
    
    func updateShoppingList(l: ShoppingList) {
        
        currentList = l
        
        labelTitle.text = l.getDisplayableTitle()
        
        //set subtitle
        let f = DateFormatter()
        f.dateFormat = "EEE dd MMM yyyy"
        
        var strSubtitle = f.string(from: l.modificationDate)
        
        let strNb = l.getDisplayableNbItemsGroups()
        if strNb.count > 0 {
            strSubtitle += " - " + strNb
        }
        
        labelSubtitle.text = strSubtitle
    }
    
}

