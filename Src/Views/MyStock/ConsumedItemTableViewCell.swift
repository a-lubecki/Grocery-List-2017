//
//  StockedItemTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 18/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol ConsumedItemTableViewCellDelegate : NSObjectProtocol {
    
    func consumedCell(cell: ConsumedItemTableViewCell, didRequireStock group: StockedItemsGroup)
    
}


class ConsumedItemTableViewCell : BaseStockTableViewCell {
    
    
    @IBOutlet internal weak var buttonStock: UIButton!
    
    weak var delegate: ConsumedItemTableViewCellDelegate?
    
    
    @IBAction func buttonStockDidTouch(_ sender: Any) {
        
        delegate?.consumedCell(cell: self, didRequireStock: currentGroup)
    }
    
}



