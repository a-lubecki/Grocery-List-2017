//
//  CategoryTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 24/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class CategoryTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var labelName: UILabel!
    
    
    func updateCategory(c: ShoppingCategory) {
    
        labelName.text = c.name
        
    }
    
    
}


