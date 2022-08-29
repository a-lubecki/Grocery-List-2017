//
//  ShoppingList.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class ShoppingList : DatabaseModel {
    
    static let titlePlaceholder = "Ma liste"
    
    let currentId: Int
    override var id: Int {
        
        get {
            return currentId
        }
    }
    
    var title = "" {
        
        didSet {
            modificationDate = Date()
        }
    }
    
    private(set) var isArchived = false {
        didSet {
            modificationDate = Date()
        }
    }
    
    var isActive: Bool {
        get {
            return !isArchived
        }
    }
    
    //used to know if the items in the list has been put in the stock or not
    var hasStockedItems = false
    
    
    private var itemsGroups = [ShoppingItemsGroup]()
    
    private(set) var modificationDate: Date
    
    
    override init() {
        
        currentId = arc4random().hashValue
        
        modificationDate = Date()
    }
    
    init(from other: ShoppingList) {
        
        currentId = arc4random().hashValue
        
        title = other.title
        isArchived = false
        itemsGroups = other.itemsGroups
        
        modificationDate = Date()
    }
    
    
    func getDisplayableTitle() -> String {
        
        if title.count > 0 {
            return title
        }
        
        return ShoppingList.titlePlaceholder
    }
    
    func getDisplayableNbItemsGroups() -> String {
        
        let nb = getNbItemsGroups()
        
        if nb <= 0 {
            return ""
        }
        if nb == 1 {
            return "1 élément"
        }
        
        return nb.description + " éléments"
    }
    

    func setAsArchived() {
        
        if isArchived {
            return
        }
        
        isArchived = true
        
        updateModificationDate()
    }
    
    
    func getItemsGroups() -> [ShoppingItemsGroup] {
        return itemsGroups
    }
    
    func getNbItemsGroups() -> Int {
        return itemsGroups.count
    }
    
    func getItemsGroupAt(pos: Int) -> ShoppingItemsGroup {
        return itemsGroups[pos]
    }
    
    func add(itemsGroup: ShoppingItemsGroup) {
        
        if isArchived {
            return
        }
        
        if ShoppingUtils.array(itemsGroups, containsEquatable: itemsGroup) {
            return
        }
        
        itemsGroups.append(itemsGroup)
        
        updateModificationDate()
    }
    
    func remove(itemsGroup: ShoppingItemsGroup) {
        
        if isArchived {
            return
        }
        
        itemsGroups = itemsGroups.filter { $0 != itemsGroup }
        
        updateModificationDate()
    }
    
    func remove(item: ShoppingItem) {
        
        if isArchived {
            return
        }
        
        itemsGroups = itemsGroups.filter { $0.item != item }
        
        updateModificationDate()
    }
    
    func replace(item: ShoppingItem, by other: ShoppingItem) {
        
        if other == item {
            return
        }
        
        if isArchived {
            return
        }
        
        //find group of item
        var foundGroup: ShoppingItemsGroup?
        
        for g in itemsGroups {
            
            if g.item == item {
                foundGroup = g
                break
            }
        }
        
        if foundGroup == nil {
            return
        }
        
        //replace with the same quantity
        remove(item: item)
        add(itemsGroup: ShoppingItemsGroup(item: other, quantity: foundGroup!.quantity))
        
    }
    
    func updateModificationDate() {
        
        if isArchived {
            return
        }
        
        modificationDate = Date()
    }
    
}

