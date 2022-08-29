//
//  EditItemViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 20/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class EditItemViewController : UIViewController {
    
    
    @IBOutlet internal weak var imageIllustration: UIImageView!
    @IBOutlet internal weak var labelTitle: UILabel!
    @IBOutlet internal weak var buttonAddDescription: UIButton!
    @IBOutlet internal weak var textViewDescription: UITextView!
    @IBOutlet internal weak var buttonEdit: UIButton!
    @IBOutlet internal weak var buttonAddToSearch: UIButton!
    @IBOutlet internal weak var labelAddExplanation: UILabel!
    
    
    var canUpdateSearchManually: Bool!
    var shoppingList: ShoppingList?
    var item: ShoppingItem!
    
    
    var isAddedToSearch = false
    var mustAddToSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        imageIllustration.image = item.illustration
        imageIllustration.layer.cornerRadius = 4
        
        labelTitle.text = item.title
        textViewDescription.text = item.description
        
        
        updateDescriptionUI()
        
        updateMustAddToSearch()
        isAddedToSearch = mustAddToSearch
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditItemViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        NotificationCenter.default.removeObserver(self)
        
        
        let newDescription = textViewDescription.text ?? ""
        
        if canUpdateSearchManually {
            
            //the user wants to change the search
            if newDescription.count > 0 {
                
                var parentTemplate: ShoppingItem! = item.template
                if parentTemplate == nil {
                    parentTemplate = item
                }
                
                //add or remove item from the db search before replacing the shopping list
                if isAddedToSearch != mustAddToSearch {
                    
                    if mustAddToSearch {
                        addToSearch(parentTemplate: parentTemplate, newDescription: newDescription)
                    } else {
                        removeFromSearch(parentTemplate: parentTemplate, newDescription: newDescription)
                    }
                }
            }
            
        } else if newDescription != item.description {
            
            //remove previous redefined template
            if let currentTemplate = item.template {
                removeFromSearch(parentTemplate: currentTemplate, newDescription: item.description)
            }
            
            //the description changed, the search must be updated automatically
            if newDescription.count > 0 {
                
                //add new redefined template
                var parentTemplate: ShoppingItem! = item.template
                if parentTemplate == nil {
                    parentTemplate = item
                }
                
                addToSearch(parentTemplate: parentTemplate, newDescription: newDescription)
            }
        }
        
        replaceInShoppingList(newDescription: newDescription)
        
    }
    
    private func addToSearch(parentTemplate: ShoppingItem, newDescription: String) {
        
        let _ = ItemsTemplatesManager.sharedInstance.addRedefinedTemplate(parentTemplate: parentTemplate, description: newDescription)
    }
    
    private func removeFromSearch(parentTemplate: ShoppingItem, newDescription: String) {
        
        ItemsTemplatesManager.sharedInstance.removeRedefinedTemplate(parentTemplate: parentTemplate, description: newDescription)
    }
    
    private func replaceInShoppingList(newDescription: String) {
        
        guard let shoppingList = shoppingList else {
            return
        }
        
        //try to find if exist in the shopping list
        for g in shoppingList.getItemsGroups() {
            
            if g.item.id != item.id && g.item.template == item.template && g.item.title == item.title && g.item.description == newDescription {
                
                //remove if already exist with a different id (duplicate)
                shoppingList.remove(item: item)
                return
            }
        }
        
        
        //replace if don't exist
        var mustReplace = false
        
        //change item group / add new item if not existing
        if item.isBaseTemplate {
            
            if newDescription.count > 0 {
                mustReplace = true
            }
            
        } else if newDescription != item.description {
            mustReplace = true
        }
        
        if mustReplace {
            
            //try to find the item in db
            var newItem = ItemsTemplatesManager.sharedInstance.findTemplate(parentTemplate: item.template, title: item.title, description: newDescription)
            
            if newItem == nil {
                //if not found create it
                var newParentTemplate = item.template
                if newParentTemplate == nil {
                    newParentTemplate = item
                }
                
                newItem = ShoppingItem(template: newParentTemplate!, newDescription: newDescription)
            }
            
            shoppingList.replace(item: item, by: newItem!)
        }
        
    }
    
    
    func updateDescriptionUI() {
        
        let isDescriptionHidden = !textViewDescription.isFirstResponder && textViewDescription.text.count <= 0
        
        textViewDescription.isHidden = isDescriptionHidden
        buttonEdit.isHidden = isDescriptionHidden || textViewDescription.isFirstResponder
        
        buttonAddDescription.isHidden = !isDescriptionHidden
        
    }
    
    func updateMustAddToSearch() {
        
        if canUpdateSearchManually {
            
            let newDescription = textViewDescription.text ?? ""
            
            //try to get from db to know if exists
            mustAddToSearch = (ItemsTemplatesManager.sharedInstance.findTemplate(parentTemplate: item.template, title: item.title, description: newDescription) != nil)
        }
        
        updateAddToSearchUI()
    }
    
    func updateAddToSearchUI() {
        
        if !canUpdateSearchManually || textViewDescription.isFirstResponder {
            
            buttonAddToSearch.isHidden = true
            labelAddExplanation.isHidden = true
            
            return
        }
        
        buttonAddToSearch.isHidden = false
        labelAddExplanation.isHidden = false
        
        if mustAddToSearch {
            
            let newDescription = textViewDescription.text ?? ""
            
            if newDescription.count <= 0 {
                
                //can't remove a base item
                buttonAddToSearch.isHidden = true
                
            } else {
            
                buttonAddToSearch.setTitle("Retirer de la recherche", for: .normal)
                buttonAddToSearch.backgroundColor = ThemeManager.Color.negative
            }
            
            labelAddExplanation.isHidden = true
            
        } else {
            
            buttonAddToSearch.setTitle("Ajouter à la recherche", for: .normal)
            buttonAddToSearch.backgroundColor = ThemeManager.Color.positive
            
            labelAddExplanation.text = "Vous pouvez ajouter ce produit à la liste de la recherche pour le trouver plus rapidement."
        }
        
        
    }
    
    @objc internal func keyboardWillHide() {
        
        DispatchQueue.main.async {
            self.updateDescriptionUI()
        }
        
    }
    
    @IBAction func buttonAddDescriptionDidTouch(_ sender: Any) {
        
        textViewDescription.becomeFirstResponder()
        
        updateDescriptionUI()
    }
    
    @IBAction func buttonEditDidTouch(_ sender: Any) {
        
        textViewDescription.becomeFirstResponder()
        
        updateDescriptionUI()
    }
    
    @IBAction func buttonAddToSearchDidTouch(_ sender: Any) {
        
        //change flag, the search will be updated on vc disappear
        mustAddToSearch = !mustAddToSearch
        
        updateAddToSearchUI()
    }
    
}

extension EditItemViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        updateAddToSearchUI()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        updateMustAddToSearch()
    }
    
}

