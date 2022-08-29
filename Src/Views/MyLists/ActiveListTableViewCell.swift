//
//  ActiveListTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol ActiveListTableViewCellDelegate {
    
    func activeCell(cell: ActiveListTableViewCell, didRequireStartShopping l: ShoppingList)
    
}

class ActiveListTableViewCell : BaseListTableViewCell {
    
    
    @IBOutlet internal weak var buttonStartShopping: UIButton!

    
    var delegate: ActiveListTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func updateShoppingList(l: ShoppingList) {
        
        super.updateShoppingList(l: l)
        
        buttonStartShopping.isHidden = (currentList.getNbItemsGroups() <= 0)
        
    }

    
    @IBAction func buttonStartDidTouch(_ sender: Any) {
        
        delegate?.activeCell(cell: self, didRequireStartShopping: currentList)
        
    }
    
}

