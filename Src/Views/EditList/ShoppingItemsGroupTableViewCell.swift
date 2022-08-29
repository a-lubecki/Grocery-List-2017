//
//  ShoppingItemsGroupTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol ShoppingItemsGroupTableViewCellDelegate : NSObjectProtocol {
    
    func groupTableViewCellDidRequireDelete(cell: ShoppingItemsGroupTableViewCell)
    
}


class ShoppingItemsGroupTableViewCell: UITableViewCell {

    
    @IBOutlet internal weak var imageIllustration: UIImageView!
    @IBOutlet internal weak var labelTitle: UILabel!
    @IBOutlet internal weak var labelDescription: UILabel!
    @IBOutlet internal weak var labelQuantity: UILabel!
    
    @IBOutlet internal weak var viewQuantityContainer: UIView!
    @IBOutlet internal weak var viewQuantityContainerBottomConstraint: NSLayoutConstraint!
    
    
    weak var delegate: ShoppingItemsGroupTableViewCellDelegate?
    
    private var currentGroup: ShoppingItemsGroup!
    private var isArchived: Bool!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    func updateItemsGroup(g: ShoppingItemsGroup, isArchived: Bool) {
        
        currentGroup = g
        self.isArchived = isArchived
        
        imageIllustration.image = g.item.illustration
        labelDescription.text = g.item.description
        
        viewQuantityContainer.isHidden = isArchived
        
        if isArchived {
            
            labelTitle.text = g.item.title + " x" + g.quantity.description
            
            viewQuantityContainerBottomConstraint.priority = UILayoutPriority(rawValue: 1)
            
        } else {
            
            labelTitle.text = g.item.title
            labelQuantity.text = "x" + g.quantity.description
            
            viewQuantityContainerBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        }
    }
    
    private func updateItemsGroup() {
        updateItemsGroup(g: currentGroup, isArchived: isArchived)
    }
        
    
    @IBAction func buttonMoreDidTouch(_ sender: Any) {
        
        currentGroup.addQuantity(nb: 1)
        
        updateItemsGroup()
    }
    
    @IBAction func buttonLessDidTouch(_ sender: Any) {
        
        if currentGroup.quantity > 1 {
            
            currentGroup.removeQuantity(nb: 1)
            updateItemsGroup()
            
            return
        }
        
        delegate?.groupTableViewCellDidRequireDelete(cell: self)
        
    }
    
    
}
