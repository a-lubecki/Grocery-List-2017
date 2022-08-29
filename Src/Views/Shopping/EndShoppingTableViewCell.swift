//
//  EndShoppingTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 24/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol EndShoppingTableViewCellDelegate : NSObjectProtocol {
    
    func endShoppingCellDidRequireEnd(cell: EndShoppingTableViewCell)
    
}


class EndShoppingTableViewCell: UITableViewCell {

    
    @IBOutlet internal weak var labelNbElems: UILabel!
    @IBOutlet internal weak var buttonEnd: UIButton!
    
    
    weak var delegate: EndShoppingTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        
    }
    
    func updateNbCheckedGroups(nb: Int) {
        
        buttonEnd.backgroundColor = ThemeManager.Color.neutral
        
        if nb <= 0 {
            
            labelNbElems.text = "Courses terminées"
            buttonEnd.backgroundColor = ThemeManager.Color.positive
            
        } else if nb == 1 {
            
            labelNbElems.text = "Plus que 1 article"
            
        } else {
            
            labelNbElems.text = "Encore " + nb.description + " articles"
        }
        
    }
    
    @IBAction func buttonEndDidTouch(_ sender: Any) {
        
        delegate?.endShoppingCellDidRequireEnd(cell: self)
    }

}
