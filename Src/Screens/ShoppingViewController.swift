//
//  ShoppingViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class ShoppingViewController : UIViewController {
    
    
    @IBOutlet internal weak var tableView: UITableView!
    @IBOutlet internal weak var buttonSortCategories: UIBarButtonItem!
    
    
    var shoppingListId: Int!
    
    private var shoppingList: ShoppingList!
    
    private var sortedCategories: [ShoppingCategory]!
    private var itemsGroups = [ShoppingCategory : [ShoppingItemsGroup]]()
    
    
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
        
        tableView.separatorColor = ThemeManager.Color.themeSecondary
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "ShoppingItemSliderTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingItemSliderTableViewCell")
        tableView.register(UINib(nibName: "EndShoppingTableViewCell", bundle: nil), forCellReuseIdentifier: "EndShoppingTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //load items groups in list
        let groups = shoppingList.getItemsGroups().sorted {
            
            if $0.item.title < $1.item.title {
                return true
            }
            if $0.item.title > $1.item.title {
                return false
            }
            
            return $0.item.description < $1.item.description
        }

        itemsGroups.removeAll()

        for g in groups {
        
            let category = g.item.category
            
            if itemsGroups.keys.contains(category) {
                itemsGroups[category]!.append(g)
            } else {
                itemsGroups[category] = [g]
            }
            
        }
        
        //retrieve visible categories order
        sortedCategories = DatabaseManager.sharedInstance.dbCategories.selectAll().filter {
            itemsGroups.keys.contains($0)
        }
        
        
        tableView.reloadData()
        
        
        //update button category
        if sortedCategories.count <= 1 {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = buttonSortCategories
        }
        
    }
    
    private func areAllItemsChecked() -> Bool {
        
        for array in itemsGroups.values {
            
            for g in array {
                if !g.isChecked {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func updateButtonFinish() {
        
        tableView.reloadSections([getSectionEndShopping()], with: .none)
    }
    
    private func finish() {
        
        shoppingList.setAsArchived()
        
        navigationController?.popToRootViewController(animated: true)
        
        Toast.makeToast(text: "La liste \"" + shoppingList.getDisplayableTitle() + "\" a été archivée")
        
        AppTabsManager.updateMyStockTabBadge()
    }
    
    private func getSectionEndShopping() -> Int {
        return itemsGroups.count
    }
    
}

extension ShoppingViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        //categories + 1 section for the end
        return itemsGroups.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == getSectionEndShopping() {
            return 1
        }
        
        return itemsGroups[sortedCategories[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == getSectionEndShopping() {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EndShoppingTableViewCell") as! EndShoppingTableViewCell
            
            var nb = 0
            for array in itemsGroups.values {
                
                for g in array {
                    if !g.isChecked {
                        nb += 1
                    }
                }
            }
            
            cell.updateNbCheckedGroups(nb: nb)
            
            cell.delegate = self
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemSliderTableViewCell") as! ShoppingItemSliderTableViewCell
        
        cell.delegate = self
        cell.updateItemsGroup(g: itemsGroups[sortedCategories[indexPath.section]]![indexPath.row], isFirst: (indexPath.section == 0 && indexPath.row == 0))
    
        return cell
    }
    
}

extension ShoppingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return ThemeManager.getTableViewSectionHeaderView(title: getTitleForHeader(section: section), isTableViewPlain: true)
    }
    
    private func getTitleForHeader(section: Int) -> String? {
        
        if (section == getSectionEndShopping()) {
            return nil
        }
        
        if sortedCategories.count <= 1 {
            //no title if only one section
            return nil
        }
        
        return sortedCategories[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == getSectionEndShopping()) {
            return 0
        }
        
        return 32
    }
    
}

extension ShoppingViewController : ShoppingItemSliderTableViewCellDelegate {
    
    func sliderTableViewCell(cell: ShoppingItemSliderTableViewCell, didChangeStateOfGroup currentGroup: ShoppingItemsGroup) {
        
        updateButtonFinish()
    }
    
}

extension ShoppingViewController : EndShoppingTableViewCellDelegate {
    
    func endShoppingCellDidRequireEnd(cell: EndShoppingTableViewCell) {
        
        if areAllItemsChecked() {
            
            finish()
            return
        }
        
        
        //display a warning
        let alert = UIAlertController(title: "Attention", message: "Tous les produits ne sont pas validé. Souhaitez-vous tout de même terminer vos achats ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Terminer", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            self.finish()
        }))
        
        present(alert, animated: true, completion: nil)

    }
    
}

