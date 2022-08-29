//
//  BaseTextField.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 10/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

@IBDesignable
class BaseTextField : UITextField {
    
    @IBInspectable
    var isThemeDark: Bool = false {
        didSet {
            updateColors()
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
        
        layer.cornerRadius = 4
        layer.borderWidth = 2
        
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : ThemeManager.Color.subtitleLight])
        }
        
        updateColors()
    }
    
    private func updateColors() {
        
        if isThemeDark {
            
            textColor = ThemeManager.Color.themeSecondary
            layer.borderColor = ThemeManager.Color.transparentLight.cgColor
            
        } else {
            
            textColor = ThemeManager.Color.themePrimary
            layer.borderColor = ThemeManager.Color.subtitle.cgColor
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 8)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 8)
    }
}
