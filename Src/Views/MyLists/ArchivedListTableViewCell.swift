//
//  ArchivedListTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol ArchivedListTableViewCellDelegate {
    
    func archivedCell(cell: ArchivedListTableViewCell, didRequireNewListFrom l: ShoppingList)
    
}

class ArchivedListTableViewCell : BaseListTableViewCell {
    
    
    var delegate: ArchivedListTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func buttonDuplicateDidTouch(_ sender: Any) {
        
        delegate?.archivedCell(cell: self, didRequireNewListFrom: currentList)
        
    }

    
}

