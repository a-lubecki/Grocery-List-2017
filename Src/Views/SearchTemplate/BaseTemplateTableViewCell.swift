//
//  BaseTemplateTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

class BaseTemplateTableViewCell: UITableViewCell {
    
    
    @IBOutlet internal weak var imageIllustration: UIImageView!
    @IBOutlet internal weak var labelTitle: UILabel!
    @IBOutlet internal weak var imageCheck: UIImageView!
    
    
    private var checkedTemplates: NSMutableSet!
    private var currentTemplate: ShoppingItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        labelTitle.text = nil
        
    }
    
    
    func updateCheckedTemplates(set: NSMutableSet) {
        checkedTemplates = set
    }
    
    func updateItemTemplate(t: ShoppingItem) {
        
        currentTemplate = t
        
        imageIllustration.image = t.illustration
        labelTitle.text = t.title
        
        if ShoppingUtils.nsSet(checkedTemplates, containsEquatable: t) {
            
            contentView.backgroundColor = ThemeManager.Color.transparentLight
            
            imageCheck.isHidden = false
            
        } else {
            
            contentView.backgroundColor = .clear
            
            imageCheck.isHidden = true
        }
        
    }
    
}
