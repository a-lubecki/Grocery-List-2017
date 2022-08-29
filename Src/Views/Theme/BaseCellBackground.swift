//
//  BaseCellBackground.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 09/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

class BaseCellBackground : UIView {
    
    
    @IBInspectable
    var isActive: Bool = true {
        didSet {
            updateBackgroundColor()
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
        
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
    
        if isActive {
            backgroundColor = ThemeManager.Color.transparentLight
        } else {
            backgroundColor = ThemeManager.Color.transparentDark
        }
    }
    
    
}
