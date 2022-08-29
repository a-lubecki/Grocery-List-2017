//
//  MyStockViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class MyStockViewController : UITableViewController {
    
    
    @IBOutlet internal weak var buttonExpand: UIBarButtonItem!
    @IBOutlet internal weak var buttonCollapse: UIBarButtonItem!
    @IBOutlet internal weak var buttonStartDelete: UIBarButtonItem!
    @IBOutlet internal weak var buttonEndDelete: UIBarButtonItem!
    
    
    private var newStocks = [ShoppingList]()
    private var items = [StockedItemsGroup]()
    private var consumedItems = [StockedItemsGroup]()
    
    
    private var isEditingExpiring = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        tableView.delaysContentTouches = false
        
        tableView.register(UINib(nibName: "PendingListTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingListTableViewCell")
        tableView.register(UINib(nibName: "StockedItemTableViewCell", bundle: nil), forCellReuseIdentifier: "StockedItemTableViewCell")
        tableView.register(UINib(nibName: "ConsumedItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsumedItemTableViewCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        newStocks = DatabaseManager.sharedInstance.dbShoppingLists.selectAll().filter {
            $0.isArchived && !$0.hasStockedItems
        }
        
        
        let currentItems = DatabaseManager.sharedInstance.dbStock.selectAll()
        
        items = currentItems.filter {
            !$0.isConsumed
        }.sorted {
            isItemGroup($0, lessImportantThan: $1)
        }
        
        consumedItems = currentItems.filter {
            
            if !$0.isConsumed {
                return false
            }
            
            if let expiring = $0.getExpiring() {
                
                //check if expired since more than 10 days
                if expiring > Date(timeIntervalSinceNow: -10 * AppConstants.dayInSec) {
                    return false
                }
                
                return true
            }
            
            //else check if bought since more than 20 days
            return $0.daysBought > Date(timeIntervalSinceNow: -20 * AppConstants.dayInSec)
            
        }.sorted {
            isItemGroup($0, lessImportantThan: $1)
        }
        
        tableView.reloadData()
        
        
        tableView.setEditing(false, animated: false)
        
        isEditingExpiring = false
        updateEditingExpiring(animated: false)
        updateBarButtonItems()
        
    }
    
    private func isItemGroup(_ g0: StockedItemsGroup, lessImportantThan g1: StockedItemsGroup) -> Bool {
        
        guard let expiring0 = g0.getExpiring() else {
            
            guard let _ = g1.getExpiring() else {
                //if no expiring date set, look at the bought date
                return g0.daysBought < g1.daysBought
            }
            
            return false
        }
        
        guard let expiring1 = g1.getExpiring() else {
            return true
        }
        
        return expiring0 < expiring1
    }
    
    
    private func hasNewStocks() -> Bool {
        return newStocks.count > 0
    }
    
    private func hasItems() -> Bool {
        return items.count > 0
    }
    
    private func hasConsumedItems() -> Bool {
        return consumedItems.count > 0
    }
    
    
    private func getSectionNewStocks() -> Int {
        return 0
    }
    
    private func getSectionItems() -> Int {
        return 1
    }
    
    private func getSectionConsumedItems() -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == getSectionNewStocks() {
            return newStocks.count
        }
        if section == getSectionItems() {
            return items.count
        }
        if section == getSectionConsumedItems() {
            return consumedItems.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        var cell: UITableViewCell!
        
        if section == getSectionNewStocks() {
            
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "PendingListTableViewCell") as! PendingListTableViewCell
            currentCell.updateShoppingList(l: newStocks[indexPath.row])
            
            cell = currentCell
            
        } else if section == getSectionItems() {
            
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "StockedItemTableViewCell") as! StockedItemTableViewCell
            currentCell.delegate = self
            currentCell.updateGroup(g: items[indexPath.row])
            
            currentCell.setEditingExpiring(editingExpiring: isEditingExpiring)
            
            cell = currentCell
            
        } else if section == getSectionConsumedItems() {
            
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "ConsumedItemTableViewCell") as! ConsumedItemTableViewCell
            currentCell.delegate = self
            currentCell.updateGroup(g: consumedItems[indexPath.row])
            
            cell = currentCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == getSectionNewStocks() {
            
            if !hasNewStocks() {
                return 0.00001
            }
            
            return 32
        }
        
        if section == getSectionItems() {
            
            if !hasItems() {
                return 0.00001
            }
            
            return 32
        }
        
        if section == getSectionConsumedItems() {
            
            if !hasConsumedItems() {
                return 0.00001
            }
            
            return 32
        }
        
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return ThemeManager.getTableViewSectionHeaderView(title: getTitleForHeader(section: section), isTableViewPlain: false)
    }
    
    private func getTitleForHeader(section: Int) -> String? {
        
        if section == getSectionNewStocks() {
            if hasNewStocks() {
                return "Derniers achats en attente"
            }
        }
        
        if section == getSectionItems() {
            if hasItems() {
                return "Articles en stock"
            }
        }
        
        if section == getSectionConsumedItems() {
            if hasConsumedItems() {
                return "Articles consommés"
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == getSectionNewStocks() {
        
            performSegue(withIdentifier: "showNewStock", sender: newStocks[indexPath.row].id)
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let section = indexPath.section
        
        if section == getSectionItems() || section == getSectionConsumedItems() {
            
            //show/hide the expand button
            updateBarButtonItems()
            
            return true
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let section = indexPath.section
            
            if section == getSectionItems() {
                
                DatabaseManager.sharedInstance.dbStock.delete(entry: items[indexPath.row])
                items.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } else if section == getSectionConsumedItems() {
                
                DatabaseManager.sharedInstance.dbStock.delete(entry: consumedItems[indexPath.row])
                consumedItems.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            tableView.reloadSectionIndexTitles()
            
            
            if items.count <= 0 && consumedItems.count <= 0 {
                
                tableView.setEditing(false, animated: true)
                updateBarButtonItems()
            }
            
            
            //reload after delay to avoid weird animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                var sectionsToReload = IndexSet()
                
                if !self.hasItems() {
                    sectionsToReload.insert(self.getSectionItems())
                }
                
                if !self.hasConsumedItems() {
                    sectionsToReload.insert(self.getSectionConsumedItems())
                }
                
                UIView.setAnimationsEnabled(false)
                self.tableView.reloadSections(sectionsToReload, with: .none)
                UIView.setAnimationsEnabled(true)
            }
        }
        
    }

    
    @IBAction func buttonExpandDidTouch(_ sender: Any) {
        
        isEditingExpiring = true
        
        updateEditingExpiring(animated: true)
        updateBarButtonItems()
    }
    
    @IBAction func buttonCollapseDidTouch(_ sender: Any) {
        
        isEditingExpiring = false
        
        updateEditingExpiring(animated: true)
        updateBarButtonItems()
    }
    
    private func updateEditingExpiring(animated: Bool) {
        
        for c in tableView.visibleCells {
            
            if let c = c as? StockedItemTableViewCell {
                c.setEditingExpiring(editingExpiring: isEditingExpiring)
            }
        }
        
        if animated {
            tableView.reloadSections([getSectionItems()], with: .automatic)
        } else {
            tableView.reloadData()
        }
        
    }
    
    @IBAction func buttonStartDeleteDidTouch(_ sender: Any) {
        
        //release the swiped cells before deletion
        tableView.setEditing(false, animated: true)
        
        tableView.setEditing(true, animated: true)
        
        isEditingExpiring = false
        
        updateEditingExpiring(animated: true)
        updateBarButtonItems()
    }
    
    @IBAction func buttonEndDeleteDidTouch(_ sender: Any) {
        
        tableView.setEditing(false, animated: true)
        
        updateBarButtonItems()
    }
    
    private func updateBarButtonItems() {
        
        var leftButton: UIBarButtonItem?
        
        if items.count > 0 && !tableView.isEditing {
            
            if isEditingExpiring {
                leftButton = buttonCollapse
            } else {
                leftButton = buttonExpand
            }
        }
        
        navigationItem.leftBarButtonItem = leftButton
        
        
        var rightButton: UIBarButtonItem?
        
        if items.count > 0 || consumedItems.count > 0 {
            
            if tableView.isEditing {
                rightButton = buttonEndDelete
            } else {
                rightButton = buttonStartDelete
            }
        }
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showNewStock" {
            
            let vc = segue.destination as! NewStockViewController
            
            vc.shoppingListId = sender as! Int
            
        }
        
    }
    
}


extension MyStockViewController : StockedItemTableViewCellDelegate {
    
    func stockedCell(cell: StockedItemTableViewCell, didRequireConsume group: StockedItemsGroup) {
        
        //release the swiped cells before moving
        tableView.setEditing(false, animated: true)
        updateBarButtonItems()
        
        
        let indexPath = tableView.indexPath(for: cell)!
        
        group.isConsumed = true
        
        items.remove(at: indexPath.row)
        consumedItems.insert(group, at: 0)
        
        
        let newIndexPath = IndexPath(row: 0, section: getSectionConsumedItems())
        tableView.moveRow(at: indexPath, to: newIndexPath)
        
        tableView.reloadSectionIndexTitles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            //reload the moved row in the section + the other section title
            UIView.setAnimationsEnabled(false)
            self.tableView.reloadSections([self.getSectionItems(), self.getSectionConsumedItems()], with: .none)
            UIView.setAnimationsEnabled(true)
            
        }
        
        updateBarButtonItems()
        
    }
    
}

extension MyStockViewController : ConsumedItemTableViewCellDelegate {

    func consumedCell(cell: ConsumedItemTableViewCell, didRequireStock group: StockedItemsGroup) {
                
        //release the swiped cells before moving
        tableView.setEditing(false, animated: true)
        
        
        let indexPath = tableView.indexPath(for: cell)!
        
        group.isConsumed = false
        
        consumedItems.remove(at: indexPath.row)
        items.insert(group, at: 0)
        
        let newIndexPath = IndexPath(row: 0, section: getSectionItems())
        tableView.moveRow(at: indexPath, to: newIndexPath)
        
        tableView.reloadSectionIndexTitles()
        
        //reload the moved row
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            //reload the moved row in the section + the other section title
            UIView.setAnimationsEnabled(false)
            self.tableView.reloadSections([self.getSectionItems(), self.getSectionConsumedItems()], with: .none)
            UIView.setAnimationsEnabled(true)
            
        }
        
        updateBarButtonItems()
        
    }
    
}

