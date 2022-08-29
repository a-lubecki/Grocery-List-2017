//
//  ShoppingItem.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation
import UIKit


class ShoppingItem : DatabaseModel {
    
    
    private var generatedId: Int!
    override var id: Int {
        get {
            return generatedId
        }
    }
    
    let template: ShoppingItem?
    
    var isBaseTemplate: Bool {
        return template == nil
    }
    
    private var newCategory: ShoppingCategory?
    var category: ShoppingCategory {
        
        get {
            if isBaseTemplate {
                return newCategory! //can't be null
            }
            
            return template!.category //template can't be null
        }
    }
    
    private var newTitle: String?
    var title: String {
        
        get {
            if isBaseTemplate {
                return newTitle! //can't be null
            }
            
            return template!.title //template can't be null
        }
        set {
            newTitle = newValue
        }
    }
    
    private var newDescription: String?
    var description: String {
        
        get {
            
            if let newDescription = newDescription, newDescription.count > 0 {
                return newDescription
            }
            
            return template?.description ?? ""
        }
        set {
            newDescription = newValue
        }
    }
    
    private var newIllustration: UIImage?
    var illustration: UIImage {
        
        get {
            
            if isBaseTemplate {
                return newIllustration! //can't be null
            }
            
            return template!.illustration //template can't be null
        }
        set {
            newIllustration = newValue
        }
    }
    
    
    /**
     Init as template
    */
    init(category: ShoppingCategory, title: String, illustration: UIImage) {
        
        self.template = nil
        
        self.newCategory = category
        
        self.newTitle = title
        self.newDescription = nil
        self.newIllustration = illustration
        
        super.init()
        
        generatedId = category.hashValue ^ title.hashValue ^ description.hashValue
        
    }
    
    /**
     Init with a template
     */
    init(template: ShoppingItem, newDescription: String? = nil) {
        
        if template.isBaseTemplate {
            self.template = template
        } else {
            
            //find top template
            var t: ShoppingItem! = template
            while t.template != nil {
                t = t.template
            }
            
            self.template = t
        }
        
        super.init()
        
        self.newDescription = newDescription
        
        generatedId = category.hashValue ^ title.hashValue ^ description.hashValue
        
    }
    
    
}
