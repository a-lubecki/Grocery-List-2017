//
//  MyListsViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class MyListsViewController : UITableViewController {
    
    
    @IBOutlet internal weak var buttonStartDelete: UIBarButtonItem!
    @IBOutlet internal weak var buttonEndDelete: UIBarButtonItem!
    
    
    private var activeListsArray = [ShoppingList]()
    private var archivedListsArray = [ShoppingList]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delaysContentTouches = false
        
        tableView.register(UINib(nibName: "CreateListTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateListTableViewCell")
        tableView.register(UINib(nibName: "ActiveListTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveListTableViewCell")
        tableView.register(UINib(nibName: "ArchivedListTableViewCell", bundle: nil), forCellReuseIdentifier: "ArchivedListTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //load data in list
        let lists = DatabaseManager.sharedInstance.dbShoppingLists.selectAll()
            .sorted {
                $0.modificationDate > $1.modificationDate
            }
        
        activeListsArray = lists.filter { (list) -> Bool in
            !list.isArchived
        }
        
        archivedListsArray = lists.filter { (list) -> Bool in
            list.isArchived
        }
        
        tableView.reloadData()
        
        
        tableView.setEditing(false, animated: false)
        updateButtonDelete()
        
    }
    
    
    private func hasActiveLists() -> Bool {
        return activeListsArray.count > 0
    }
    
    private func hasArchivedLists() -> Bool {
        return archivedListsArray.count > 0
    }
    
    private func getSectionNewList() -> Int {
        return 0
    }
    
    private func getSectionActiveLists() -> Int {
        return 1
    }
    
    private func getSectionArchivedLists() -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == getSectionNewList() {
            return 1
        }
        if section == getSectionActiveLists() {
            return activeListsArray.count
        }
        if section == getSectionArchivedLists() {
            return archivedListsArray.count
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        var cell: UITableViewCell!
        
        if section == getSectionNewList() {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CreateListTableViewCell")
            
            let cellCreateButton = cell as! CreateListTableViewCell
            cellCreateButton.delegate = self
            
        } else if section == getSectionActiveLists() {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ActiveListTableViewCell")
            
            let cellActive = cell as! ActiveListTableViewCell
            cellActive.delegate = self
            cellActive.updateShoppingList(l: activeListsArray[indexPath.row])
            
        } else if section == getSectionArchivedLists() {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ArchivedListTableViewCell")
            
            let cellArchived = cell as! ArchivedListTableViewCell
            cellArchived.delegate = self
            cellArchived.updateShoppingList(l: archivedListsArray[indexPath.row])
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == getSectionActiveLists() {
            
            if !hasActiveLists() {
                return 0.00001
            }
            
            return 32
        }
        
        if section == getSectionArchivedLists() {
            
            if !hasArchivedLists() {
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
        
        if section == getSectionActiveLists() {
            
            if activeListsArray.count > 0 {
                return "Mes listes en cours"
            }
        }
        
        if section == getSectionArchivedLists() {
            
            if archivedListsArray.count > 0 {
                return "Mes listes archivées"
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        
        if section == getSectionActiveLists() {
            
            showList(l: activeListsArray[indexPath.row])
            
        } else if section == getSectionArchivedLists() {
            
            showList(l: archivedListsArray[indexPath.row])
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let section = indexPath.section
        
        if section == getSectionActiveLists() || section == getSectionArchivedLists() {
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
            
            if section == getSectionActiveLists() {
                
                DatabaseManager.sharedInstance.dbShoppingLists.delete(entry: activeListsArray[indexPath.row])
                activeListsArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            
            } else if section == getSectionArchivedLists() {
                
                DatabaseManager.sharedInstance.dbShoppingLists.delete(entry: archivedListsArray[indexPath.row])
                archivedListsArray.remove(at: indexPath.row)
                
                //the nb has changed
                AppTabsManager.updateMyStockTabBadge()
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            tableView.reloadSectionIndexTitles()
            
            
            if activeListsArray.count <= 0 && archivedListsArray.count <= 0 {
                
                tableView.setEditing(false, animated: true)
                updateButtonDelete()
            }
            
            
            //reload after delay to avoid weird animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                var sectionsToReload = IndexSet()
                
                if !self.hasActiveLists() {
                    sectionsToReload.insert(self.getSectionActiveLists())
                }
                
                if !self.hasArchivedLists() {
                    sectionsToReload.insert(self.getSectionArchivedLists())
                }
                
                UIView.setAnimationsEnabled(false)
                self.tableView.reloadSections(sectionsToReload, with: .none)
                UIView.setAnimationsEnabled(true)
            }
        }
        
    }
    
    
    @IBAction func buttonStartDeleteDidTouch(_ sender: Any) {
        
        //release the swiped cells before deletion
        tableView.setEditing(false, animated: true)
        
        tableView.setEditing(true, animated: true)
        updateButtonDelete()
    }
    
    @IBAction func buttonEndDeleteDidTouch(_ sender: Any) {
        
        tableView.setEditing(false, animated: true)
        updateButtonDelete()
    }
    
    private func updateButtonDelete() {
        
        if activeListsArray.count <= 0 && archivedListsArray.count <= 0 {
        
            navigationItem.rightBarButtonItem = nil
            
        } else if tableView.isEditing {
        
            navigationItem.rightBarButtonItem = buttonEndDelete
            
        } else {
            
            navigationItem.rightBarButtonItem = buttonStartDelete
        }
        
    }
    
    
    private func showList(l: ShoppingList) {
        
        performSegue(withIdentifier: "showList", sender: l)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showList" {
        
            let vc = segue.destination as! EditListViewController
            vc.shoppingListId = (sender as! ShoppingList).id
            
        } else if segue.identifier == "startShopping" {
            
            let vc = segue.destination as! ShoppingViewController
            vc.shoppingListId = (sender as! ShoppingList).id
        }
        
    }
    
    
}

extension MyListsViewController : CreateListTableViewCellDelegate {
    
    func createCellDidTouch(cell: CreateListTableViewCell) {
        
        let l = ShoppingList()
        DatabaseManager.sharedInstance.dbShoppingLists.insertOrReplace(newEntry: l)
        
        //animate
        activeListsArray.insert(l, at: 0)
        
        tableView.insertRows(at: [IndexPath(row: 0, section: getSectionActiveLists())], with: .automatic)
        tableView.reloadSectionIndexTitles()
        
        
        //delay show to show insert animation
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.view.isUserInteractionEnabled = true
            
            self.showList(l: l)
        }
        
    }
    
}

extension MyListsViewController : ActiveListTableViewCellDelegate {
    
    func activeCell(cell: ActiveListTableViewCell, didRequireStartShopping l: ShoppingList) {
        
        performSegue(withIdentifier: "startShopping", sender: l)
        
    }
    
}

extension MyListsViewController : ArchivedListTableViewCellDelegate {
        
    func archivedCell(cell: ArchivedListTableViewCell, didRequireNewListFrom l: ShoppingList) {
        
        let newList = ShoppingList(from: l)
        DatabaseManager.sharedInstance.dbShoppingLists.insertOrReplace(newEntry: newList)
        
        //animate
        activeListsArray.insert(l, at: 0)
        
        tableView.insertRows(at: [IndexPath(row: 0, section: getSectionActiveLists())], with: .automatic)
        tableView.reloadSectionIndexTitles()
        
        
        //delay show to show insert animation
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.view.isUserInteractionEnabled = true
            
            self.showList(l: newList)
        }
        
    }
    
}

