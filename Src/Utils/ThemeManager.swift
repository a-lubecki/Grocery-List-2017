//
//  ThemeManager.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 09/11/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit
import ChameleonFramework

class ThemeManager {
    
    struct Color {
        
        static let themePrimary = UIColor(hexString: "#192d41")!
        static let themeSecondary = UIColor.white
        
        static let neutral = UIColor(hexString: "#16b1e5")!
        static let positive = UIColor(hexString: "#43bc76")!
        static let negative = UIColor(hexString: "#c43e47")!
        static let warning = UIColor(hexString: "#ffbf3f")!
        static let expired = UIColor(hexString: "#ff5959")!
        static let notification = negative
        
        static let transparentLight = UIColor(white: 1, alpha: 0.4)
        static let transparentDark = UIColor(white: 0, alpha: 0.4)
        
        static let subtitle = UIColor(white: 0.6, alpha: 1)
        static let subtitleLight = UIColor(white: 0.8, alpha: 1)
    }
    
    struct Font {
        
        static let regular = "Futura"
        static let bold = "Futura-Bold"
        
        static func getFontRegular(size: CGFloat) -> UIFont {
            return UIFont(name: regular, size: size)!
        }
        
        static func getFontBold(size: CGFloat) -> UIFont {
            return UIFont(name: bold, size: size)!
        }
        
    }
    
    static func applyGlobalTheme() {
        
        Chameleon.setGlobalThemeUsingPrimaryColor(Color.themePrimary, withSecondaryColor: Color.themeSecondary, usingFontName: Font.regular, andContentStyle: .light)
        
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().isOpaque = true
        UITabBar.appearance().barTintColor = Color.themePrimary
        UITabBar.appearance().tintColor = Color.themeSecondary
        
        for item in AppTabsManager.tabBar.items! {
            item.badgeColor = Color.notification
        }
        
    }
    
    
    static func initViewController(vc: UIViewController) {
        
        vc.view.layer.contents = #imageLiteral(resourceName: "App-Background").cgImage
        vc.view.layer.contentsGravity = kCAGravityResizeAspectFill
        vc.view.layer.masksToBounds = true
        
    }
    
    static func getTableViewSectionHeaderView(title: String?, isTableViewPlain: Bool) -> UIView {
        
        guard let title = title else {
            return UIView()
        }
        
        let size = CGSize(width: UIScreen.main.bounds.width, height: 32)
        
        let res = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if isTableViewPlain {
            res.backgroundColor = ThemeManager.Color.themePrimary
        }
    
        let label = UILabel(frame: CGRect(x: 16, y: 4, width: size.width - 32, height: size.height - 8))
        
        label.font = UIFont(descriptor: label.font.fontDescriptor, size: 14)
        label.text = title
        label.textColor = ThemeManager.Color.themeSecondary
        
        res.addSubview(label)
        
        return res
        
    }
    
}
