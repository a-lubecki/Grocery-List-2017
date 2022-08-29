//
//  NewStockViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 17/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class NewStockViewController : UIViewController {
    
    
    @IBOutlet internal weak var tableViewItems: UITableView!
    @IBOutlet internal weak var labelExpiringItems: UILabel!
    @IBOutlet internal weak var labelDateBought: UILabel!
    
    @IBOutlet internal weak var viewHeader: UIView!
    @IBOutlet internal weak var viewFooter: UIView!
    @IBOutlet internal weak var viewSeparator: UIView!
    
    
    var shoppingListId: Int!
    private var shoppingList: ShoppingList!
    
    private var sortedCategories: [ShoppingCategory]!
    private var itemsGroups = [ShoppingCategory : [StockedItemsGroup]]()
    
    private var currentEditingGroup: StockedItemsGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        shoppingList = DatabaseManager.sharedInstance.dbShoppingLists.select(id: shoppingListId)
        
        if shoppingList == nil {
            
            Toast.makeToast(text: "La liste ne peut pas être consultée")
            
            navigationController?.popViewController(animated: true)
            
            return
        }
        
        navigationItem.title = shoppingList.getDisplayableTitle()
        
        
        tableViewItems.separatorStyle = .none
        tableViewItems.tableFooterView = UIView()
        tableViewItems.rowHeight = UITableViewAutomaticDimension
        tableViewItems.estimatedRowHeight = 250
        tableViewItems.delaysContentTouches = false
        
        tableViewItems.register(UINib(nibName: "PendingItemGroupTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingItemGroupTableViewCell")
        
        tableViewItems.tableHeaderView = viewHeader
        
        viewSeparator.backgroundColor = ThemeManager.Color.transparentLight
        viewFooter.backgroundColor = ThemeManager.Color.transparentDark
        
        let f = DateFormatter()
        f.dateFormat = "EEE dd/MM/yy"
        labelDateBought.text = "Articles achetés le " + f.string(from: shoppingList.modificationDate)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //create stocked items
        var newStockedItems = [StockedItemsGroup]()
        
        for g in shoppingList.getItemsGroups() {
            
            newStockedItems.append(StockedItemsGroup(group: g, dateBought: shoppingList.modificationDate))
            
        }
        
        newStockedItems = newStockedItems.sorted {
            
            if $0.item.title < $1.item.title {
                return true
            }
            if $0.item.title > $1.item.title {
                return false
            }
            
            return $0.item.description < $1.item.description
        }
        
        itemsGroups.removeAll()
        
        for g in newStockedItems {
            
            let category = g.item.category
            
            if itemsGroups.keys.contains(category) {
                itemsGroups[category]!.append(g)
            } else {
                itemsGroups[category] = [g]
            }
            
        }
        
        sortedCategories = DatabaseManager.sharedInstance.dbCategories.selectAll().filter {
            itemsGroups.keys.contains($0)
        }
        
        tableViewItems.reloadData()
        
        updatePendingNbGroups()
    }
    
    
    @IBAction func buttonStockDidTouch(_ sender: Any) {
        
        
        shoppingList.hasStockedItems = true
        
        //save new stocked items in db
        let itemsToStock = itemsGroups.flatMap {
            $0.value
        }
        
        DatabaseManager.sharedInstance.dbStock.insertOrReplace(newEntries: itemsToStock)
        
    
        AppTabsManager.updateMyStockTabBadge()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
}


extension NewStockViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsGroups[sortedCategories[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingItemGroupTableViewCell") as! PendingItemGroupTableViewCell
        cell.pendingDelegate = self
        
        let group = itemsGroups[sortedCategories[indexPath.section]]![indexPath.row]
        cell.updateGroup(g: group)
        
        if currentEditingGroup == group {
            cell.setEditingExpiring(editingExpiring: true)
        }
        
        return cell
    }
    
}

extension NewStockViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return ThemeManager.getTableViewSectionHeaderView(title: getTitleForHeader(section: section), isTableViewPlain: true)
    }
    
    private func getTitleForHeader(section: Int) -> String? {
        
        
        return sortedCategories[section].name
    }
    
}

extension NewStockViewController : PendingItemGroupTableViewCellDelegate {
    
    func pendingCell(cell: PendingItemGroupTableViewCell, didRequireDateAdd group: StockedItemsGroup) {

        if group.getExpiring() == nil {
            //add one day
            group.changeExpiring(dateExpired: Date(timeIntervalSinceNow: AppConstants.dayInSec))
        }
        
        //get cells to reload before setting the new editing group
        var indexPaths = [IndexPath]()
        indexPaths.append(tableViewItems.indexPath(for: cell)!)
        
        if let g = currentEditingGroup {
            
            let category = g.item.category
            
            indexPaths.append(IndexPath(row: itemsGroups[category]!.index(of: g)!, section: sortedCategories.index(of: category)!))
        }
        
        currentEditingGroup = group
        
        tableViewItems.reloadRows(at: indexPaths, with: .automatic)
    }
    
    func pendingCellDateAddDidChange(group: StockedItemsGroup) {
        updatePendingNbGroups()
    }
    
    func updatePendingNbGroups() {
        
        let allGroups = itemsGroups.flatMap {
            $0.value
        }
        
        let nbGroupsWithExpiring = allGroups.filter {
            $0.getExpiring() != nil
            }.count
        
        labelExpiringItems.text = "Articles périssables : " + nbGroupsWithExpiring.description + "/" + allGroups.count.description
        
    }
    
    func pendingCell(cell: PendingItemGroupTableViewCell, didRequireSlit group: StockedItemsGroup) {
        
        //remove editing
        currentEditingGroup = nil
        
        let category = group.item.category
        let pos = itemsGroups[category]!.index(of: group)!
        
        itemsGroups[category]!.remove(at: pos)
        
        var newGroups = [StockedItemsGroup]()
        
        for _ in 0..<group.quantity {
            newGroups.append(StockedItemsGroup(other: group, quantity: 1))
        }
        
        itemsGroups[category]!.insert(contentsOf: newGroups, at: pos)
        
        tableViewItems.reloadSections([tableViewItems.indexPath(for: cell)!.section], with: .automatic)
    }
    
}

