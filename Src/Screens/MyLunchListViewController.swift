//
//  MyLunchViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 16/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit

class MyLunchListViewController : UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        
    }
    
    
}

