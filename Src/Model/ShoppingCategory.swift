//
//  ShoppingCategory.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 14/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class ShoppingCategory : DatabaseModel {
    
    static let custom = ShoppingCategory(name: "Perso")
    static let vegetables = ShoppingCategory(name: "Legumes") //artichaud, asperge, aubergine, betterave, brocoli, carottes...  + salade
    static let fruits = ShoppingCategory(name: "Fruits") //abricots, ananas, avocat, banane, cassis, cerises...
    static let condiments = ShoppingCategory(name: "Condiments") //olives, ail, aneth, basilic...
    static let driedFruits = ShoppingCategory(name: "Fruits secs") //cajou, pignons, amandes, raisins sec, abricots secs...
    static let meat = ShoppingCategory(name: "Viande") //boeuf, porc, agneau, veau, dinde, poulet...
    static let fish = ShoppingCategory(name: "Poisson") //bar, cabillaud, calamar, carpe, colin...
    
    static let baseCategoriesOrder: [ShoppingCategory] = [
        .custom,
        .vegetables,
        .fruits,
        .condiments,
        .driedFruits,
        .meat,
        .fish
    ]
    
    
    let generatedId: Int
    override var id: Int {
        
        get {
            return generatedId
        }
    }
    
    let name: String
    
    init(name: String) {
        
        self.name = name
        
        generatedId = name.hashValue
        
    }
    
    
}
