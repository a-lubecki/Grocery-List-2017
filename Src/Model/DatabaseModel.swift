//
//  DatabaseModel.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 20/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class DatabaseModel {
    
    //override this
    var id: Int {
        get {
            return -1
        }
    }
    
    
}

extension DatabaseModel : Hashable {
    
    var hashValue: Int {
        get {
            return id.hashValue
        }
    }
    
}

extension DatabaseModel : Equatable {
    
    static func ==(lhs: DatabaseModel, rhs: DatabaseModel) -> Bool {
        
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        
        return lhs.id == rhs.id
    }
    
}
