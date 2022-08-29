//
//  DatabasesManager.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 20/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class DatabaseManager {
    
    //singleton
    static let sharedInstance = DatabaseManager()
    
    private init() {
        
        
        dbCategories.insertOrReplace(newEntries: ShoppingCategory.baseCategoriesOrder)
        
    }
    
    
    let dbCategories = BaseDatabase<ShoppingCategory>()
    let dbShoppingLists = BaseDatabase<ShoppingList>()
    let dbStock = BaseDatabase<StockedItemsGroup>()
    
    
    
}
