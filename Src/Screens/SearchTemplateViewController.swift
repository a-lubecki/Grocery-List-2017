//
//  SearchTemplateViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 14/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class SearchTemplateViewController : UITableViewController {

    
    @IBOutlet internal weak var searchBar: UISearchBar!
    @IBOutlet internal weak var buttonDone: UIBarButtonItem!
    
    
    var checkedTemplates: NSMutableSet! //use a NSSet to keep the reference between screens
    
    private var lastSearch = ""
    
    private var sortedCategories = [ShoppingCategory]()
    private var sortedTemplates = [ShoppingCategory : [ShoppingItem]]() // category => base template
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        
        navigationItem.rightBarButtonItem = buttonDone
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(UINib(nibName: "BaseTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "BaseTemplateTableViewCell")
        tableView.register(UINib(nibName: "RedefinedTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "RedefinedTemplateTableViewCell")
        
        //fix a bug with searchbar height
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSearch(text: searchBar.text ?? "")
        
        searchBar.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //release keyboard
        searchBar.endEditing(true)
        
    }
    
    
    private func updateSearch(text: String) {
        
        sortedCategories.removeAll()
        sortedTemplates.removeAll()
        
        //load data in list
        
        let isBlankSearch = ItemsTemplatesManager.sharedInstance.isBlank(search: text)
        
        var templates = ItemsTemplatesManager.sharedInstance.find(search: text)
        
        if !isBlankSearch {
            
            var hasExactMatch = false
            
            for item in templates {
                
                if ItemsTemplatesManager.sharedInstance.isExactMatch(search: text, text: item.title) {
                    hasExactMatch = true
                    break
                }
            }
            
            if !hasExactMatch {
                
                //add custom item in the beginning
                templates.insert(ItemsTemplatesManager.sharedInstance.newCustomTemplate(title: text), at: 0)
            }
        }
        
        for t in templates {
            
            let category = t.category
            
            var array: [ShoppingItem]! = sortedTemplates[category]
            if array == nil {
                array = [t]
            } else {
                array.append(t)
            }
            
            //append redefined templates just after the parent template
            array.append(contentsOf: ItemsTemplatesManager.sharedInstance.getRedefinedTemplates(parentTemplate: t))
            
            //save templates
            sortedTemplates[category] = array
            
            //save category
            if !sortedCategories.contains(category) {
                sortedCategories.append(category)
            }
        }
        
        
        if isBlankSearch {
            
            sortedCategories = sortedCategories.sorted {
                $0.name < $1.name
            }
            
            //add all custom redefined templates
            var customTemplates = [ShoppingItem]()
            var customRedefinedTemplates = [ShoppingItem: [ShoppingItem]]()
            
            for t in ItemsTemplatesManager.sharedInstance.getRedefinedTemplates(category: ShoppingCategory.custom) {
                
                let parentTemplate = t.template!
                
                if !customTemplates.contains(parentTemplate) {
                    
                    customTemplates.append(parentTemplate)
                    customRedefinedTemplates[parentTemplate] = [t]
                    
                } else {
                    
                    customRedefinedTemplates[parentTemplate]!.append(t)
                }
            }
            
            customTemplates = customTemplates.sorted {
                $0.title < $1.title
            }
            
            var allCustomTemplates = [ShoppingItem]()
            
            for t in customTemplates {
                
                allCustomTemplates.append(t)
                allCustomTemplates.append(contentsOf: customRedefinedTemplates[t]!)
            }
            
            //add the custom category if there are any templates
            if (allCustomTemplates.count > 0) {
            
                sortedTemplates[ShoppingCategory.custom] = allCustomTemplates
                
                //add custom first and sort the other categories
                sortedCategories = [ShoppingCategory.custom] + sortedCategories
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    
    private func getCategory(section: Int) -> ShoppingCategory {
        return sortedCategories[section]
    }
    
    private func getItemTemplate(indexPath: IndexPath) -> ShoppingItem {
        return sortedTemplates[getCategory(section: indexPath.section)]![indexPath.row]
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let actionEdit = UITableViewRowAction(style: .default, title: "Modifier") { (action, indexPath) in
            
            self.performSegue(withIdentifier: "showItem", sender: self.getItemTemplate(indexPath: indexPath))
        }
        
        actionEdit.backgroundColor = UIColor.lightGray
        
        if getItemTemplate(indexPath: indexPath).isBaseTemplate {
            return [actionEdit]
        }
        
        //can only delete the non-base-template :
        
        let actionDelete = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, indexPath) in
            
            let item = self.getItemTemplate(indexPath: indexPath)
            ItemsTemplatesManager.sharedInstance.removeRedefinedTemplate(parentTemplate: item.template!, description: item.description)
            
            self.sortedTemplates[self.getCategory(section: indexPath.section)]!.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        actionDelete.backgroundColor = UIColor.red
        
        return [actionDelete, actionEdit]
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        searchBar.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTemplates[getCategory(section: section)]!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = getItemTemplate(indexPath: indexPath)
        
        var cell: UITableViewCell!
        
        if item.isBaseTemplate {
            
            let cellTemplate = tableView.dequeueReusableCell(withIdentifier: "BaseTemplateTableViewCell") as! BaseTemplateTableViewCell
            cell = cellTemplate
            
            cellTemplate.updateCheckedTemplates(set: checkedTemplates)
            cellTemplate.updateItemTemplate(t: item)
            
        } else {
            
            let cellTemplate = tableView.dequeueReusableCell(withIdentifier: "RedefinedTemplateTableViewCell") as! RedefinedTemplateTableViewCell
            cell = cellTemplate
            
            cellTemplate.updateCheckedTemplates(set: checkedTemplates)
            cellTemplate.updateItemTemplate(t: item)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return ThemeManager.getTableViewSectionHeaderView(title: getTitleForHeader(section: section), isTableViewPlain: true)
    }
    
    private func getTitleForHeader(section: Int) -> String? {
        return getCategory(section: section).name
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = getItemTemplate(indexPath: indexPath)
        
        if ShoppingUtils.nsSet(checkedTemplates, containsEquatable: item) {
            ShoppingUtils.nsSet(checkedTemplates, removeEquatable: item)
        } else {
            checkedTemplates.add(item)
        }
        
        UIView.setAnimationsEnabled(false)
        tableView.reloadRows(at: [indexPath], with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showItem" {
            
            let vc = segue.destination as! EditItemViewController
            vc.canUpdateSearchManually = false
            vc.item = sender as! ShoppingItem
        }
        
    }
    
    @IBAction func dismissSelf() {
    
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

extension SearchTemplateViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let newText = searchBar.text {
            
            let newLength = newText.count + text.count - range.length
            
            return newLength <= 20
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if lastSearch == searchText {
            //avoid doing the same request
            return
        }
        
        lastSearch = searchText
        
        updateSearch(text: searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        //stop scrolling or the search bar can't become first responder
        tableView.setContentOffset(tableView.contentOffset, animated: false)
        
        return true
    }
    
}

