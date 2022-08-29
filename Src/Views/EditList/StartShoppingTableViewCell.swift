//
//  CreateListTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol StartShoppingTableViewCellDelegate {
    
    func startShoppingCellDidTouch(cell: StartShoppingTableViewCell)
    
}

class StartShoppingTableViewCell : UITableViewCell {
    
 
    @IBOutlet internal weak var buttonStart: UIButton!
    
    
    var delegate: StartShoppingTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    func updateShoppingList(l: ShoppingList) {
        
        var someItemsChecked = false
        
        for g in l.getItemsGroups() {
            
            if g.isChecked {
                someItemsChecked = true
                break
            }
        }
        
        if someItemsChecked {
            buttonStart.setTitle("Continuer les achats", for: .normal)
        } else {
            buttonStart.setTitle("Commencer les achats", for: .normal)
        }
        
    }
    
    
    @IBAction func buttonStartShoppingDidTouch(_ sender: Any) {
        
        delegate?.startShoppingCellDidTouch(cell: self)
        
    }
    
}


