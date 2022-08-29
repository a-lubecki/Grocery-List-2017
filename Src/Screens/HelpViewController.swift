//
//  HelpViewController.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 23/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


class HelpViewController : UIViewController {

    static let nbPages = 4
    
    
    @IBOutlet internal weak var scrollViewHelp: UIScrollView!
    @IBOutlet internal weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.initViewController(vc: self)
        
        pageControl.numberOfPages = HelpViewController.nbPages
        pageControl.pageIndicatorTintColor = ThemeManager.Color.transparentLight
        pageControl.currentPageIndicatorTintColor = ThemeManager.Color.themeSecondary
        pageControl.tintColor = UIColor.blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if pageControl.currentPage == 0 {
            
            //bounce to indicate the view can be scrolled
            scrollViewHelp.isUserInteractionEnabled = false
            scrollViewHelp.contentOffset = CGPoint(x: 0, y: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.scrollViewHelp.setContentOffset(CGPoint(x: 15, y: 0), animated: true)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.scrollViewHelp.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            })
            
            scrollViewHelp.isUserInteractionEnabled = true
            
        }
        
    }
    
    
    @IBAction func pageControlValueChanged(_ sender: Any) {
        
        scrollViewHelp.setContentOffset(CGPoint(x: CGFloat(pageControl.currentPage) * scrollViewHelp.contentSize.width / CGFloat(HelpViewController.nbPages), y: 0), animated: true)
    }
    
    
}


extension HelpViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let newPage = Int(CGFloat(HelpViewController.nbPages) * scrollView.contentOffset.x / scrollView.contentSize.width)
        
        if newPage != pageControl.currentPage {
            pageControl.currentPage = newPage
        }
        
    }
    
}

