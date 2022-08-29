//
//  PrivateMethodRevealer.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 19/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import Foundation

@objc protocol PrivateMethodRevealer {
    
    @objc optional func setShowingDeleteConfirmation(_ arg1: Bool)
    
    @objc optional func _endSwipeToDeleteRowDidDelete(_ arg1: Bool)
    
}
