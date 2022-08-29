//
//  ShoppingItemsGroup.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation

class ShoppingItemsGroup : DatabaseModel {

    
    override var id: Int {
        return item.id
    }
    
    private(set) var item: ShoppingItem
    private(set) var quantity: Int
    
    var isChecked = false
    
    
    init(item: ShoppingItem, quantity: Int = 1) {
        
        if quantity < 1 {
            preconditionFailure()
        }
        
        self.item = item
        self.quantity = quantity
    }
    
    
    func addQuantity(nb: Int) {
        
        if nb < 0 {
            preconditionFailure()
        }
        
        if quantity >= 99 {
            return
        }
        
        quantity += nb
    }
    
    func removeQuantity(nb: Int) {
        
        if nb < 0 {
            preconditionFailure()
        }
        
        quantity -= nb
        
        if (quantity < 1) {
            quantity = 1
        }
    }
    
}
