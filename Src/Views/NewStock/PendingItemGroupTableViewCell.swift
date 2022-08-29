//
//  PendingItemGroupTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 26/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol PendingItemGroupTableViewCellDelegate : NSObjectProtocol {
    
    func pendingCell(cell: PendingItemGroupTableViewCell, didRequireDateAdd group: StockedItemsGroup)
    
    func pendingCellDateAddDidChange(group: StockedItemsGroup)
    
    func pendingCell(cell: PendingItemGroupTableViewCell, didRequireSlit group: StockedItemsGroup)
    
}


class PendingItemGroupTableViewCell: StockedItemTableViewCell {

    
    @IBOutlet internal weak var buttonSplit: UIButton!
    @IBOutlet internal weak var labelChosenDate: UILabel!
    
    
    weak var pendingDelegate: PendingItemGroupTableViewCellDelegate?
    
    
    override internal func updateGroup(g: StockedItemsGroup) {
        super.updateGroup(g: g)
        
        setEditingExpiring(editingExpiring: false)
    }
    
    override internal func updateExpiringViews() {
        super.updateExpiringViews()
        
        labelChosenDate.text = nil
        buttonEdit!.setTitle("Définir la date de péremption", for: .normal)
        buttonSplit.isHidden = true
        
        if let dateExpired = currentGroup.getExpiring() {
            
            if !editingExpiring {
                
                let f = DateFormatter()
                f.dateFormat = "EEE dd/MM/yy"
                labelChosenDate.text = "Expiration : " + f.string(from: dateExpired)
                
                buttonEdit!.setTitle("Changer", for: .normal)
            }
            
            if currentGroup.quantity > 1 {
                buttonSplit.isHidden = false
            }
        }
        
    }
    
    @IBAction func buttonAddDateDidTouch(_ sender: Any) {
        
        pendingDelegate?.pendingCell(cell: self, didRequireDateAdd: currentGroup)
        pendingDelegate?.pendingCellDateAddDidChange(group: currentGroup)
    }
    
    @IBAction func buttonSplitDidTouch(_ sender: Any) {
        
        pendingDelegate?.pendingCell(cell: self, didRequireSlit: currentGroup)
    }
    
    override func datePickerValueChanged(_ sender: Any) {
        super.datePickerValueChanged(sender)
        
        pendingDelegate?.pendingCellDateAddDidChange(group: currentGroup)
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        
        pendingDelegate?.pendingCellDateAddDidChange(group: currentGroup)
    }
    
}
