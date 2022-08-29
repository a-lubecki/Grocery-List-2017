//
//  BaseLabel.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 09/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

@IBDesignable
class BaseLabel : UILabel {
    
    
    @IBInspectable
    var isThemeDark: Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    @IBInspectable
    var isTitle: Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
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
        
        updateTextColor()
    }
    
    private func updateTextColor() {
        
        if isThemeDark {
            if isTitle {
                textColor = ThemeManager.Color.themeSecondary
            } else {
                textColor = ThemeManager.Color.subtitleLight
            }
        } else {
            if isTitle {
                textColor = ThemeManager.Color.themePrimary
            } else {
                textColor = ThemeManager.Color.subtitle
            }
        }
    }
    
}

