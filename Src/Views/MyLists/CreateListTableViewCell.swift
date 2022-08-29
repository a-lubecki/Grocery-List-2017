//
//  CreateListTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol CreateListTableViewCellDelegate {
    
    func createCellDidTouch(cell: CreateListTableViewCell)
    
}

class CreateListTableViewCell : UITableViewCell {
    
 
    
    var delegate: CreateListTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    
    @IBAction func buttonCreateDidTouch(_ sender: Any) {
        
        delegate?.createCellDidTouch(cell: self)
        
    }
    
}


