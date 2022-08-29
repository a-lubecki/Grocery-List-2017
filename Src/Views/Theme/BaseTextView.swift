//
//  BaseTextView.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 09/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

@IBDesignable
class BaseTextView : UITextView {
    
    
    @IBInspectable
    var isThemeDark: Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    private func initialize() {
        
        layer.cornerRadius = 4
        layer.borderWidth = 2
        
        backgroundColor = .clear
        
        updateTextColor()
    }
    
    private func updateTextColor() {
        
        if isThemeDark {
            
            textColor = ThemeManager.Color.subtitleLight
            layer.borderColor = ThemeManager.Color.transparentLight.cgColor
            
        } else {
            
            textColor = ThemeManager.Color.subtitle
            layer.borderColor = ThemeManager.Color.subtitle.cgColor
        }
        
    }
    
}


