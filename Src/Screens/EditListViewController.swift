//
//  EditListViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class EditListViewController : UITableViewController {
    
    
    @IBOutlet internal weak var searchBar: UISearchBar!
    @IBOutlet internal weak var buttonScanItem: UIBarButtonItem!
    
    
    var shoppingListId: Int!
    
    private var shoppingList: ShoppingList!
    private var itemsGroups = [ShoppingItemsGroup]()
    
    private var hasSectionName: Bool {
        get {
            return !shoppingList.isArchived
        }
    }
    
    private var hasSectionStart: Bool {
        get {
            return !shoppingList.isArchived && shoppingList.getNbItemsGroups() > 0
        }
    }
    
    private var checkedTemplates: NSMutableSet! //use a NSSet to keep the reference between screens
    private var previouslyCheckedTemplates: NSSet!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        shoppingList = DatabaseManager.sharedInstance.dbShoppingLists.select(id: shoppingListId)
        
        if shoppingList == nil {
            
            Toast.makeToast(text: "La liste ne peut pas être consultée")
            
            navigationController?.popViewController(animated: true)
            
            return
        }
        
        if !hasSectionName {
            title = shoppingList.getDisplayableTitle()
        }
        
        if shoppingList.isActive {
            navigationItem.titleView = searchBar
            navigationItem.rightBarButtonItem = buttonScanItem
        }
        
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delaysContentTouches = false
        
        tableView.register(UINib(nibName: "ListNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ListNameTableViewCell")
        tableView.register(UINib(nibName: "StartShoppingTableViewCell", bundle: nil), forCellReuseIdentifier: "StartShoppingTableViewCell")
        tableView.register(UINib(nibName: "ShoppingItemsGroupTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingItemsGroupTableViewCell")
        
        //fix a bug with searchbar height
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if checkedTemplates != nil && previouslyCheckedTemplates != nil {
        
            //update items in the list by doing a diff
            for t in previouslyCheckedTemplates {
                
                if !ShoppingUtils.nsSet(checkedTemplates, containsEquatable: t as! ShoppingItem) {
                    //remove group
                    shoppingList.remove(item: t as! ShoppingItem)
                }
            }
            
            for t in checkedTemplates {
                
                if !ShoppingUtils.nsSet(previouslyCheckedTemplates, containsEquatable: t as! ShoppingItem) {
                    //add group
                    shoppingList.add(itemsGroup: ShoppingItemsGroup(item: t as! ShoppingItem))
                }
            }
            
            //diff done, the set is not necessary any more
            checkedTemplates = nil
            previouslyCheckedTemplates = nil
        }
        
        //load data in list
        itemsGroups = shoppingList.getItemsGroups()
            .sorted {
                
                if $0.item.title < $1.item.title {
                    return true
                }
                if $0.item.title > $1.item.title {
                    return false
                }
                
                return $0.item.description < $1.item.description
            }
        
        tableView.reloadData()
        
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        view.endEditing(true)
    }
    
    
    private func getSectionName() -> Int {
        return 0
    }
    
    private func getSectionStart() -> Int {
        return 1
    }
    
    private func getSectionGroups() -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == getSectionName() {
            
            if hasSectionName {
                return 1
            }
            
            return 0
        }
        
        if section == getSectionStart() {
            
            if hasSectionStart {
                return 1
            }
            
            return 0
        }
        
        if section == getSectionGroups() {
            return itemsGroups.count
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        var cell: UITableViewCell!
        
        if section == getSectionName() {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ListNameTableViewCell")
            
            let currentCell = cell as! ListNameTableViewCell
            currentCell.updateShoppingList(l: shoppingList)
            
        } else if section == getSectionStart() {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "StartShoppingTableViewCell")
            
            let currentCell = cell as! StartShoppingTableViewCell
            currentCell.delegate = self
            currentCell.updateShoppingList(l: shoppingList)
            
        } else if section == getSectionGroups() {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemsGroupTableViewCell")
            
            let currentCell = cell as! ShoppingItemsGroupTableViewCell
            currentCell.delegate = self
            currentCell.updateItemsGroup(g: itemsGroups[indexPath.row], isArchived: shoppingList.isArchived)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return ThemeManager.getTableViewSectionHeaderView(title: getTitleForHeader(section: section), isTableViewPlain: false)
    }
    
    private func getTitleForHeader(section: Int) -> String? {
        
        if section == getSectionStart() {
            
            if hasSectionStart {
                return itemsGroups.count.description + " produits sélectionnés"
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == getSectionGroups() {
            
            //cant modify the item if the list is archived
            if !shoppingList.isArchived {
                performSegue(withIdentifier: "showItem", sender: itemsGroups[indexPath.row].item)
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if shoppingList.isArchived {
            return false
        }
        
        let section = indexPath.section
        
        if section == getSectionGroups() {
            return true
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteItem(indexPath: indexPath)
            
        }
        
    }
    
    private func deleteItem(indexPath: IndexPath) {
        
        if indexPath.section != getSectionGroups() {
            return
        }
        
        let group = itemsGroups[indexPath.row]
        shoppingList.remove(itemsGroup: group)
        itemsGroups.remove(at: indexPath.row)
        
        tableView.beginUpdates()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadSections([getSectionStart()], with: .fade)
        
        tableView.endUpdates()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == getSectionName() {
            
            if !hasSectionName {
                return 0.00001
            }
            
        } else if section == getSectionStart() {
            
            if !hasSectionStart {
                return 0.00001
            }
            
            return 32
        }
        
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "search" {
            
            let vc = (segue.destination as! UINavigationController).viewControllers[0] as! SearchTemplateViewController
            
            //init checked once with the items list
            checkedTemplates = NSMutableSet()
            
            for g in itemsGroups {
                checkedTemplates.add(g.item)
            }
            
            previouslyCheckedTemplates = NSMutableSet(set: checkedTemplates)
            vc.checkedTemplates = checkedTemplates
            
        } else if segue.identifier == "showItem" {
            
            let vc = segue.destination as! EditItemViewController
            vc.canUpdateSearchManually = true
            vc.shoppingList = shoppingList
            vc.item = sender as! ShoppingItem
      
        } else if segue.identifier == "startShopping" {
            
            let vc = segue.destination as! ShoppingViewController
            vc.shoppingListId = shoppingList.id
        }
    
    }

}

extension EditListViewController : ShoppingItemsGroupTableViewCellDelegate {
    
    func groupTableViewCellDidRequireDelete(cell: ShoppingItemsGroupTableViewCell) {
        
        let alert = UIAlertController(title: nil, message: "Supprimer de la liste ?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: { (action) in
            
            self.deleteItem(indexPath: self.tableView.indexPath(for: cell)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension EditListViewController : StartShoppingTableViewCellDelegate {
    
    func startShoppingCellDidTouch(cell: StartShoppingTableViewCell) {
        
        performSegue(withIdentifier: "startShopping", sender: nil)
    }
    
}

extension EditListViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "search", sender: nil)
        
        return false
    }
}

