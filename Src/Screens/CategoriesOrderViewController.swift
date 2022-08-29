//
//  CategoriesOrderViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 23/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class CategoriesOrderViewController : UITableViewController {
    
    
    private var sortedCategories = [ShoppingCategory]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = ThemeManager.Color.themeSecondary
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        
        tableView.isEditing = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //retrieve visible categories order
        sortedCategories = DatabaseManager.sharedInstance.dbCategories.selectAll()
        
        
        tableView.reloadData()
        
    }

    
    private func updateDatabase() {
    
        let dbCategories = DatabaseManager.sharedInstance.dbCategories
        dbCategories.clear()
        
        dbCategories.insertOrReplace(newEntries: sortedCategories)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        
        cell.updateCategory(c: sortedCategories[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let category = sortedCategories.remove(at: sourceIndexPath.row)
        sortedCategories.insert(category, at: destinationIndexPath.row)
        
        updateDatabase()
    }
    
    
}
