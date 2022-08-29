//
//  ShoppingUtil.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 11/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation



class ShoppingUtils {
    
    
    static func nsSet(_ collection: NSSet, containsEquatable object: ShoppingItem) -> Bool {
        
        for o in collection {
            
            if let o = o as? ShoppingItem, o == object {
                return true
            }
        }
        
        return false
    }
    
    static func set(_ collection: Set<ShoppingItem>, containsEquatable object: ShoppingItem) -> Bool {
        
        for o in collection {
            
            if o == object {
                return true
            }
        }
        
        return false
    }
    
    static func array(_ collection: [ShoppingItemsGroup], containsEquatable object: ShoppingItemsGroup) -> Bool {
        
        for o in collection {
            
            if o == object {
                return true
            }
        }
        
        return false
    }
    
    
    static func nsSet(_ collection: NSMutableSet, removeEquatable object: ShoppingItem) {

        var foundItem: ShoppingItem?
        
        for o in collection {
            
            if let o = o as? ShoppingItem, o == object {
                foundItem = o
                break
            }
        }
        
        if let foundItem = foundItem {
            collection.remove(foundItem)
        }
        
    }
    
    
    
}


