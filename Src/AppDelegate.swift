//
//  AppDelegate.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 11/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ThemeManager.applyGlobalTheme()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        
        
        //TODO TEST
        let tOlive = ItemsTemplatesManager.sharedInstance.find(search: "olive")[0]
        let tRaisin = ItemsTemplatesManager.sharedInstance.find(search: "raisin")[0]
        let tPoulet = ItemsTemplatesManager.sharedInstance.find(search: "poulet")[0]
        let tAneth = ItemsTemplatesManager.sharedInstance.find(search: "aneth")[0]
        let tAvocat = ItemsTemplatesManager.sharedInstance.find(search: "avocat")[0]
        
        let l = ShoppingList()
        
        l.add(itemsGroup: ShoppingItemsGroup(item: tOlive, quantity: 2))
        l.add(itemsGroup: ShoppingItemsGroup(item: tRaisin, quantity: 3))
        l.add(itemsGroup: ShoppingItemsGroup(item: tPoulet))
        l.add(itemsGroup: ShoppingItemsGroup(item: tAneth))
        l.add(itemsGroup: ShoppingItemsGroup(item: tAvocat, quantity: 4))
        l.setAsArchived()
        
        DatabaseManager.sharedInstance.dbShoppingLists.insertOrReplace(newEntry: l)
        
/*
        //TODO TEST
        let baseTemplate = ItemsTemplatesManager.sharedInstance.find(search: "Cabill")[0]

        let item1 = ItemsTemplatesManager.sharedInstance.addRedefinedTemplate(parentTemplate: baseTemplate, description: "Atlantique")
        let item2 = ItemsTemplatesManager.sharedInstance.addRedefinedTemplate(parentTemplate: baseTemplate, description: "Bien frais")

        let db = DatabaseManager.sharedInstance.dbStock
        
        let stockedItem1 = StockedItem(item: item1, dateBought: Date(timeIntervalSince1970: 1484922183))
        stockedItem1.changeExpiring(dateExpired: Date(timeIntervalSince1970: 1485181383))
        db.insertOrReplace(newEntry: stockedItem1)
        
        let stockedItem2 = StockedItem(item: item2, dateBought: Date(timeIntervalSince1970: 1505913783))
        stockedItem2.changeExpiring(dateExpired: Date(timeIntervalSince1970: 1506345783))
        db.insertOrReplace(newEntry: stockedItem2)
        
        db.insertOrReplace(newEntry: StockedItem(item: baseTemplate, dateBought: Date()))
         //TODO TEST
        */
 
        
        AppTabsManager.updateMyStockTabBadge()
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

