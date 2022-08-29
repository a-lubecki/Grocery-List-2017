//
//  Toast.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import CRToast


class Toast {
    
    
    static func makeToast(text: String, isNeutral: Bool = true, isNegative: Bool = false) {
        
        let color = isNeutral ? ThemeManager.Color.neutral : (isNegative ? ThemeManager.Color.negative : ThemeManager.Color.positive)
        
        CRToastManager.showNotification(options:
            [
                kCRToastTextKey : text,
                kCRToastFontKey : UIFont.systemFont(ofSize: 14),
                kCRToastTextColorKey : UIColor.white,
                kCRToastBackgroundColorKey : color,
                kCRToastAnimationInTypeKey : NSNumber(value: CRToastAnimationType.gravity.rawValue),
                kCRToastAnimationOutTypeKey : NSNumber(value: CRToastAnimationType.gravity.rawValue),
                kCRToastNotificationTypeKey : NSNumber(value: CRToastType.navigationBar.rawValue),
                kCRToastAnimationInDirectionKey : NSNumber(value: CRToastAnimationDirection.top.rawValue),
                kCRToastAnimationOutDirectionKey : NSNumber(value: CRToastAnimationDirection.top.rawValue),
                kCRToastInteractionRespondersKey : [
                    CRToastInteractionResponder(interactionType: CRToastInteractionType.tap, automaticallyDismiss: true, block: nil) //dismiss interaction
                ]
            ], completionBlock: nil)
        
        
    }
    
    
}
