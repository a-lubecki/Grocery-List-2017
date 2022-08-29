//
//  BaseNavigationController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 25/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class BaseNavigationController : UINavigationController {
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //find parent before pushing
        let parentVc = viewControllers.last
        
        super.pushViewController(viewController, animated: true)
        
        //the title of the back button can be changed on the parent
        if let parentVc = parentVc {
            parentVc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
    }
    
    
}

