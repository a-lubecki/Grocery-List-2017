//
//  BaseActionButton.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 09/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

@IBDesignable
class BaseButton : UIButton {
    
    @IBInspectable
    var isNeutral: Bool = true {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable
    var isPositive: Bool = false {
        didSet {
            updateBackgroundColor()
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
        titleLabel?.font = ThemeManager.Font.getFontBold(size: titleLabel!.font.pointSize)
        
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        
        if isNeutral {
            backgroundColor = ThemeManager.Color.neutral
        } else if isPositive {
            backgroundColor = ThemeManager.Color.positive
        } else {
            backgroundColor = ThemeManager.Color.negative
        }
    }
    
}
