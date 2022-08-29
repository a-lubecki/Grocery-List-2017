//
//  AppTabsManager.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 24/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


enum AppTab : Int {
    case MyLists
    case MyStock
    case MyMeals
    case Help
}


class AppTabsManager {
    
    static var tabBarController: UITabBarController {
        return UIApplication.shared.windows[0].rootViewController as! UITabBarController
    }
    
    static var tabBar: UITabBar {
        return tabBarController.tabBar
    }
    
    static func updateMyStockTabBadge() {
        
        let nb = DatabaseManager.sharedInstance.dbShoppingLists.selectAll().filter {
            $0.isArchived && !$0.hasStockedItems
            }.count
        
        updateTabBadge(tabPos: AppTab.MyStock.rawValue, nb: nb)
        
    }
    
    static func updateTabBadge(tabPos: Int, nb: Int) {
        
        let value = nb <= 0 ? nil : nb.description
        
        AppTabsManager.tabBar.items![tabPos].badgeValue = value
        
    }
    
}
