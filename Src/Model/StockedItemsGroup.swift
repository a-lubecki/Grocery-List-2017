//
//  StockedItemGroup.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 18/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class StockedItemsGroup : DatabaseModel {
    
    
    let currentId: Int
    override var id: Int {
        
        get {
            return currentId
        }
    }
    
    private(set) var item: ShoppingItem
    private(set) var quantity: Int
    
    private(set) var daysBought: Date
    
    private(set) var daysExpired: Date?
    
    private(set) var periodBeforeExpire: Int?
    private(set) var unitBeforeExpire: ExpiringUnit?
    
    var preferDateForExpiring = true
    
    var isConsumed = false
    
    
    init(group: ShoppingItemsGroup, dateBought: Date) {
        
        currentId = arc4random().hashValue
        
        item = group.item
        quantity = group.quantity
        
        daysBought = StockedItemsGroup.getDateWithoutTime(date: dateBought)
    }
    
    init(item: ShoppingItem, dateBought: Date, quantity: Int = 1) {
        
        if quantity < 1 {
            preconditionFailure()
        }
        
        currentId = arc4random().hashValue
        
        self.item = item
        self.quantity = quantity
        
        daysBought = StockedItemsGroup.getDateWithoutTime(date: dateBought)
    }
    
    init(other: StockedItemsGroup, quantity: Int = 1) {
        
        if quantity < 1 {
            preconditionFailure()
        }
        
        currentId = arc4random().hashValue
        
        item = other.item
        self.quantity = quantity
        
        daysBought = other.daysBought
        
        daysExpired = other.daysExpired
        
        periodBeforeExpire = other.periodBeforeExpire
        unitBeforeExpire = other.unitBeforeExpire
        
        preferDateForExpiring = other.preferDateForExpiring
        isConsumed = other.isConsumed
        
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
    
    func isAboutToExpire() -> Bool {
        
        if let dateExpiring = getExpiring() {
            
            let daysBefore = StockedItemsGroup.getDateWithoutTime(date: Date(timeIntervalSince1970: dateExpiring.timeIntervalSince1970 - 3 * AppConstants.dayInSec))
            
            if daysBefore <= StockedItemsGroup.getDateWithoutTime(date: Date()) {
                return true
            }
        }
        
        return false
    }
    
    func isExpired() -> Bool {
        
        let currentDay = StockedItemsGroup.getDateWithoutTime(date: Date())
        
        if let dateExpiring = getExpiring(), dateExpiring < currentDay {
            return true
        }
        
        return false
    }
    
    func resetExpiring() {
        
        daysExpired = nil
        periodBeforeExpire = nil
        unitBeforeExpire = nil
    }
    
    func changeExpiring(dateExpired: Date) {
        
        resetExpiring()
        
        if dateExpired <= daysBought {
            return
        }
        
        daysExpired = StockedItemsGroup.getDateWithoutTime(date: dateExpired)
    }
    
    func changeExpiring(periodBeforeExpire: Int, unitBeforeExpire: ExpiringUnit) {
        
        resetExpiring()
        
        if periodBeforeExpire <= 0 {
            return
        }
        
        self.periodBeforeExpire = periodBeforeExpire
        self.unitBeforeExpire = unitBeforeExpire
    }
    
    func getExpiring() -> Date? {
        
        if preferDateForExpiring {
            
            if let date = getExpiringWithDate() {
                return date
            }
            
            if let date = getExpiringWithPeriod() {
                return date
            }
            
            return nil
        }
        
        if let date = getExpiringWithPeriod() {
            return date
        }
        
        if let date = getExpiringWithDate() {
            return date
        }
        
        return nil
    }
    
    private func getExpiringWithDate() -> Date? {
        return daysExpired
    }
    
    private func getExpiringWithPeriod() -> Date? {
        
        if let periodBeforeExpire = periodBeforeExpire, let unitBeforeExpire = unitBeforeExpire {
            return daysBought.addingTimeInterval(TimeInterval(periodBeforeExpire * unitBeforeExpire.rawValue) * AppConstants.dayInSec)
        }
        
        return nil
    }
    
    
    private static func getDateWithoutTime(date: Date) -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    }
    
}


enum ExpiringUnit : Int {
    case day = 1
    case week = 7
    case month = 30
}
