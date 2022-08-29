//
//  ListNameTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class ListNameTableViewCell : UITableViewCell {
    
    
    @IBOutlet internal weak var textFieldTitle: UITextField!
    @IBOutlet internal weak var buttonEdit: UIButton!
    
    
    private var currentList: ShoppingList!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textFieldTitle.text = nil
        textFieldTitle.placeholder = ShoppingList.titlePlaceholder
        
        selectionStyle = .none
        
    }
    
    func updateShoppingList(l: ShoppingList) {
        
        currentList = l
        
        textFieldTitle.text = l.title
        
    }
    
    @IBAction func buttonEditDidTouch(_ sender: Any) {
        
        textFieldTitle.becomeFirstResponder()
        
    }
    
}


extension ListNameTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        buttonEdit.isHidden = true
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        currentList.title = textField.text ?? ""
        
        buttonEdit.isHidden = false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let newText = textField.text {
            
            let newLength = newText.count + string.count - range.length
        
            return newLength <= 20
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
}

