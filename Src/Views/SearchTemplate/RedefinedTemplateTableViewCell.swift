//
//  BaseTemplateTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

class RedefinedTemplateTableViewCell: UITableViewCell {
    
    
    @IBOutlet internal weak var labelDescription: UILabel!
    
    
    private var checkedTemplates: NSMutableSet!
    private var currentTemplate: ShoppingItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelDescription.text = nil
        
    }
    
    
    func updateCheckedTemplates(set: NSMutableSet) {
        checkedTemplates = set
    }
    
    func updateItemTemplate(t: ShoppingItem) {
        
        currentTemplate = t
        
        labelDescription.text = t.title + " - " + t.description
        
        
        if ShoppingUtils.nsSet(checkedTemplates, containsEquatable: t) {
            contentView.backgroundColor = ThemeManager.Color.transparentLight
        } else {
            contentView.backgroundColor = .clear
        }
        
    }
    
}
