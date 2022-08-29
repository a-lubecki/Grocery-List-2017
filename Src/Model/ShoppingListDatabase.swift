//
//  TDatabase.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 12/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation


class BaseDatabase<T : DatabaseModel> {
    
    
    private var database = [Int : T]()
    private var orderedDatabase = [T]()
    
    
    func select(id: Int) -> T? {
        
        return database[id]
    }
    
    func select(ids: Set<Int>) -> [T] {
        
        var res = [T]()
        
        for id in ids {
            
            if let entry = select(id: id) {
                res.append(entry)
            }
        }
        
        return res
    }
    
    func selectAll() -> [T] {
        return orderedDatabase
    }
    
    func insertOrReplace(newEntry: T) {
        
        if database.keys.contains(newEntry.id) {
            
            for i in 0..<orderedDatabase.count {
                
                if orderedDatabase[i].id == newEntry.id {
                    
                    orderedDatabase[i] = newEntry
                    break
                }
            }
            
        } else {
            
            orderedDatabase.append(newEntry)
        }
        
        database[newEntry.id] = newEntry
        
    }
    
    func insertOrReplace(newEntries: [T]) {
        
        for e in newEntries {
            insertOrReplace(newEntry: e)
        }
        
    }
    
    func delete(entry: T) {
        
        delete(id: entry.id)
    }
    
    func delete(id: Int) {
        
        if !database.keys.contains(id) {
            return
        }
        
        database[id] = nil
        
        for i in 0..<orderedDatabase.count {
            
            if orderedDatabase[i].id == id {
                
                orderedDatabase.remove(at: i)
                break
            }
            
        }
    }
    
    func clear() {
        
        database.removeAll()
        orderedDatabase.removeAll()
    }
    
    
}

