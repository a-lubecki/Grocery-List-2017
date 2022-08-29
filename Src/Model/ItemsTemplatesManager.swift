//
//  ItemsTemplateManager.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 14/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class ItemsTemplatesManager {

    
    //singleton
    static let sharedInstance = ItemsTemplatesManager()
    
    
    private var templates = [ShoppingItem]()
    private var redefinedTemplates = [ShoppingItem]()
    
    
    private init() {
        
        //init all templates
        
        templates.append(ShoppingItem(category: .vegetables, title: "Artichaud", illustration: #imageLiteral(resourceName: "Item-Artichaud")))
        templates.append(ShoppingItem(category: .vegetables, title: "Asperge", illustration: #imageLiteral(resourceName: "Item-Asperge")))
        templates.append(ShoppingItem(category: .vegetables, title: "Aubergine", illustration: #imageLiteral(resourceName: "Item-Aubergine")))
        templates.append(ShoppingItem(category: .vegetables, title: "Betterave", illustration: #imageLiteral(resourceName: "Item-Betterave")))
        templates.append(ShoppingItem(category: .vegetables, title: "Brocoli", illustration: #imageLiteral(resourceName: "Item-Brocoli")))
        templates.append(ShoppingItem(category: .vegetables, title: "Carotte", illustration: #imageLiteral(resourceName: "Item-Carotte")))
        templates.append(ShoppingItem(category: .vegetables, title: "Salade", illustration: #imageLiteral(resourceName: "Item-Salade")))
        
        templates.append(ShoppingItem(category: .fruits, title: "Abricot", illustration: #imageLiteral(resourceName: "Item-Abricot")))
        templates.append(ShoppingItem(category: .fruits, title: "Ananas", illustration: #imageLiteral(resourceName: "Item-Ananas")))
        templates.append(ShoppingItem(category: .fruits, title: "Avocat", illustration: #imageLiteral(resourceName: "Item-Avocat")))
        templates.append(ShoppingItem(category: .fruits, title: "Banane", illustration: #imageLiteral(resourceName: "Item-Banane")))
        templates.append(ShoppingItem(category: .fruits, title: "Cassis", illustration: #imageLiteral(resourceName: "Item-Cassis")))
        templates.append(ShoppingItem(category: .fruits, title: "Cerise", illustration: #imageLiteral(resourceName: "Item-Cerise")))
        
        templates.append(ShoppingItem(category: .condiments, title: "Olive", illustration: #imageLiteral(resourceName: "Item-Olive")))
        templates.append(ShoppingItem(category: .condiments, title: "Ail", illustration: #imageLiteral(resourceName: "Item-Ail")))
        templates.append(ShoppingItem(category: .condiments, title: "Aneth", illustration: #imageLiteral(resourceName: "Item-Aneth")))
        templates.append(ShoppingItem(category: .condiments, title: "Basilic", illustration: #imageLiteral(resourceName: "Item-Basilic")))
        
        templates.append(ShoppingItem(category: .driedFruits, title: "Cajou", illustration: #imageLiteral(resourceName: "Item-Cajou")))
        templates.append(ShoppingItem(category: .driedFruits, title: "Pignon", illustration: #imageLiteral(resourceName: "Item-Pignon")))
        templates.append(ShoppingItem(category: .driedFruits, title: "Amande", illustration: #imageLiteral(resourceName: "Item-Amande")))
        templates.append(ShoppingItem(category: .driedFruits, title: "Raisin sec", illustration: #imageLiteral(resourceName: "Item-Raisin-Sec")))
        templates.append(ShoppingItem(category: .driedFruits, title: "Abricot secs", illustration: #imageLiteral(resourceName: "Item-Abricot-Sec")))
        
        templates.append(ShoppingItem(category: .meat, title: "Boeuf", illustration: #imageLiteral(resourceName: "Item-Boeuf")))
        templates.append(ShoppingItem(category: .meat, title: "Porc", illustration: #imageLiteral(resourceName: "Item-Porc")))
        templates.append(ShoppingItem(category: .meat, title: "Agneau", illustration: #imageLiteral(resourceName: "Item-Agneau")))
        templates.append(ShoppingItem(category: .meat, title: "Veau", illustration: #imageLiteral(resourceName: "Item-Veau")))
        templates.append(ShoppingItem(category: .meat, title: "Dinde", illustration: #imageLiteral(resourceName: "Item-Dinde")))
        templates.append(ShoppingItem(category: .meat, title: "Poulet", illustration: #imageLiteral(resourceName: "Item-Poulet")))
        
        templates.append(ShoppingItem(category: .fish, title: "Bar", illustration: #imageLiteral(resourceName: "Item-Bar")))
        templates.append(ShoppingItem(category: .fish, title: "Cabillaud", illustration: #imageLiteral(resourceName: "Item-Cabillaud")))
        templates.append(ShoppingItem(category: .fish, title: "Calamar", illustration: #imageLiteral(resourceName: "Item-Calamar")))
        templates.append(ShoppingItem(category: .fish, title: "Carpe", illustration: #imageLiteral(resourceName: "Item-Carpe")))
        templates.append(ShoppingItem(category: .fish, title: "Colin", illustration: #imageLiteral(resourceName: "Item-Colin")))
        
    }
    
    
    func getTemplates() -> [ShoppingItem] {
        return templates
    }
    
    func findTemplate(parentTemplate: ShoppingItem?, title: String, description: String) -> ShoppingItem? {
        
        //find in redefined if there is a description
        if description.count > 0 {
            
            for t in redefinedTemplates {
                
                if isCorrectTemplate(t: t, title: title, description: description) {
                    return t
                }
            }
            
            return nil
            
        }
        
        //base or custom template
        for t in templates {
            
            if isCorrectTemplate(t: t, title: title, description: description) {
                return t
            }
        }
        
        //if don't exist, create custom template
        return newCustomTemplate(title: title)
    }
    
    private func isCorrectTemplate(t: ShoppingItem, title: String, description: String) -> Bool {
        return (t.title == title && t.description == description)
    }
    
    
    func isBlank(search: String) -> Bool {
        
        return search.range(of: "^\\s*$", options: [String.CompareOptions.regularExpression, String.CompareOptions.anchored], range: nil, locale: nil) != nil
    }
    
    func isExactMatch(search: String, text: String) -> Bool {
        
        return search.compare(text,
            options: [
                String.CompareOptions.diacriticInsensitive,
                String.CompareOptions.caseInsensitive
            ],
            range: nil,
            locale: nil) == .orderedSame
    }
    
    func find(search: String) -> [ShoppingItem] {
        
        if isBlank(search: search) {
            
            //if string is empty or blank, return all
            return templates.sorted {
                $0.title < $1.title
            }
        }
        
        var weights = [(ShoppingItem, Int)]()
        
        var foundTemplates = Set<ShoppingItem>()
        
        
        //find by title + category in templates
        for item in templates {
            
            let newWeight = getWeight(search: search, item: item)
            
            if newWeight > 0 {
                weights.append((item, newWeight))
                foundTemplates.insert(item)
            }
        }
        
        //find by redefined items descriptions
        for item in redefinedTemplates {
            
            let baseTemplate = item.template!
            
            //use closure because of equality redefinition
            if ShoppingUtils.set(foundTemplates, containsEquatable: baseTemplate) {
                //already in the result
                continue
            }
            
            let newWeight = Int(Float(getWeight(search: search, text: item.description)) * 0.25)
            
            if newWeight > 0 {
                weights.append((baseTemplate, newWeight))
                foundTemplates.insert(item)
            }
        }
            
        return weights.sorted(by: {
                $0.1 > $1.1
            }).flatMap({ array in
                array.0
            })
    }
    
    private func getWeight(search: String, item: ShoppingItem) -> Int {
        
        return getWeight(search: search, text: item.title) + Int(Float(getWeight(search: search, text: item.category.name)) * 0.5)
    }
    
    private func getWeight(search: String, text: String) -> Int {
        
        if isExactMatch(search: search, text: text) {
            //exact match
            return 100000
        }
        
        
        var nbMatchingCharsSearch = 0
        var nbMatchingCharsTitle = 0
        
        //ex : search = oor / title = foobar
        
        var index = 0
        
        for ics in 0..<search.count { // o.o.r
            
            let cs = String(search[search.index(search.startIndex, offsetBy: ics)..<search.index(search.startIndex, offsetBy: ics+1)])
            
            for ict in index..<text.count { // o => f.o.o.b.a.r / o => f.o.o.b.a.r / r => f.o.o.b.a.r
                
                let ct = String(text[text.index(text.startIndex, offsetBy: ict)..<text.index(text.startIndex, offsetBy: ict+1)])
                
                let result = cs.compare(
                    ct,
                    options: [
                        String.CompareOptions.diacriticInsensitive,
                        String.CompareOptions.caseInsensitive
                    ],
                    range: nil,
                    locale: nil)
                
                if result == .orderedSame { // o => f.o / o => o / r => b.a.r
                    nbMatchingCharsSearch += 1
                    index += 1
                    break
                }
            }
        }
        
        index = 0
        
        for ict in 0..<text.count { // f.o.o.b.a.r
            
            let ct = String(text[text.index(text.startIndex, offsetBy: ict)..<text.index(text.startIndex, offsetBy: ict+1)])
            
            for ics in index..<search.count { // f => o.o.r / o => o.o.r / o => o.o.r / b => o.o.r / a => o.o.r / r => o.o.r
                
                let cs = String(text[search.index(search.startIndex, offsetBy: ics)..<search.index(search.startIndex, offsetBy: ics+1)])
                
                let result = ct.compare(
                    cs,
                    options: [
                        String.CompareOptions.diacriticInsensitive,
                        String.CompareOptions.caseInsensitive
                    ],
                    range: nil,
                    locale: nil)
                
                if result == .orderedSame { // f => o.o.r / o => o / o => o / b => r / a => r / r => r
                    nbMatchingCharsTitle += 1
                    index += 1
                    break
                }
            }
        }
        
        
        let nbMatchingChars = Int(Float(nbMatchingCharsSearch + nbMatchingCharsTitle) * 0.5)
        
        if nbMatchingChars >= Int(Float(text.count + search.count) * 0.5) {
            
            var weight = nbMatchingChars * 10
            
            if text.localizedCaseInsensitiveContains(search) {
                weight += 200
            }
            
            let diff = search.count - text.count
            if diff > 0 {
                weight -= diff * 20
            }
            
            if weight < 0 {
                return 0
            }
            
            return weight
        }
        
        if search.count >= 2 && search.count >= text.count - 3 && text.localizedCaseInsensitiveContains(search) {
            return 100
        }
        
        if search.count >= 4 && text.localizedCaseInsensitiveContains(search) {
            return 50
        }
        
        return 0
    }
    
    /**
     Get or create if not existing (create and store it to keep the same id through the navigation)
     */
    func newCustomTemplate(title: String) -> ShoppingItem {
        
        //capitalize first title character to simplify search
        let newTitle = title.capitalized
        
        //if not found, create an store it
        return ShoppingItem(category: ShoppingCategory.custom, title: newTitle, illustration: #imageLiteral(resourceName: "Item-Custom"))
    }
    
    
    func addRedefinedTemplate(parentTemplate: ShoppingItem, description: String) -> ShoppingItem {
        
        if !parentTemplate.isBaseTemplate {
            //problem, can't add non-base template
            preconditionFailure()
        }
        
        if let existingTemplate = findTemplate(parentTemplate: parentTemplate, title: parentTemplate.title, description: description) {
            //already exist
            return existingTemplate
        }
        
        let newItem = ShoppingItem(template: parentTemplate, newDescription: description)
        redefinedTemplates.append(newItem)
        
        return newItem
    }
    
    func removeRedefinedTemplate(parentTemplate: ShoppingItem, description: String) {
        
        if findTemplate(parentTemplate: parentTemplate, title: parentTemplate.title, description: description) == nil {
            //already removed
            return
        }

        redefinedTemplates = redefinedTemplates.filter {
            $0.template != parentTemplate || $0.description != description
        }
    }
 
    func getRedefinedTemplates(parentTemplate: ShoppingItem) -> [ShoppingItem] {
        
        return redefinedTemplates.filter {
            $0.template == parentTemplate
        }.sorted {
            $0.description < $1.description
        }
    }
    
    func getRedefinedTemplates(category: ShoppingCategory) -> [ShoppingItem] {
        
        return redefinedTemplates.filter {
            $0.category == category
        }.sorted {
            $0.description < $1.description
        }
    }
    
}

