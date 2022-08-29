//
//  ShoppingItemSliderTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 13/09/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol ShoppingItemSliderTableViewCellDelegate : NSObjectProtocol {
    
    func sliderTableViewCell(cell: ShoppingItemSliderTableViewCell, didChangeStateOfGroup currentGroup: ShoppingItemsGroup)
    
}


class ShoppingItemSliderTableViewCell: UITableViewCell {

    
    @IBOutlet internal weak var imageIllustration: UIImageView!
    @IBOutlet internal weak var labelTitle: UILabel!
    @IBOutlet internal weak var labelDescription: UILabel!
    
    @IBOutlet internal weak var scrollView: UIScrollView!
    @IBOutlet internal weak var viewSpace: UIView!
    @IBOutlet internal weak var viewSlider: UIView!
    
    @IBOutlet internal weak var imageViewSwipe: UIImageView!
    
    
    weak var delegate: ShoppingItemSliderTableViewCellDelegate?
    
    private var currentGroup: ShoppingItemsGroup!

    private var canScroll = false//fixed a bug with paging scroll
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //fix a bug with iOS 11 : incorrect size on load => problem with setting the contentOffset of the scrollview
        bounds = UIScreen.main.bounds
        layoutIfNeeded()

        selectionStyle = .none
        
        labelTitle.text = nil
        labelDescription.text = nil
        
        imageIllustration.layer.cornerRadius = 4
        viewSlider.layer.cornerRadius = 4
    }
    
    func updateItemsGroup(g: ShoppingItemsGroup, isFirst: Bool) {
        
        currentGroup = g
        
        imageIllustration.image = g.item.illustration
        
        if g.quantity <= 1 {
            labelTitle.text = g.item.title
        } else {
            labelTitle.text = g.item.title + " x" + g.quantity.description
        }
        
        labelDescription.text = g.item.description
        
        
        imageViewSwipe.isHidden = !isFirst
        
        //disable delegate before setting the offset to not notify any changes
        scrollView.delegate = nil
        
        if g.isChecked {
            scrollView.contentOffset = CGPoint()
        } else {
            scrollView.contentOffset = CGPoint(x: viewSpace.bounds.width, y: 0)
        }
        
        scrollView.delegate = self
        
        updateBackgroundColor()
    
    }
    
    private func updateBackgroundColor() {
        
        var percentage = scrollView.contentOffset.x / viewSpace.bounds.width
        
        if percentage < 0 {
            percentage = 0
        } else if percentage > 1 {
            percentage = 1
        }
        
        //min : disabled, max : enabled
        var minR = CGFloat(0)
        var minG = CGFloat(0)
        var minB = CGFloat(0)
        var minA = CGFloat(0)
        ThemeManager.Color.transparentDark.getRed(&minR, green: &minG, blue: &minB, alpha: &minA)
        
        var maxR = CGFloat(0)
        var maxG = CGFloat(0)
        var maxB = CGFloat(0)
        var maxA = CGFloat(0)
        ThemeManager.Color.transparentLight.getRed(&maxR, green: &maxG, blue: &maxB, alpha: &maxA)
        
        viewSlider.backgroundColor = UIColor(
            red: lerpColorValue(val1: minR, val2: maxR, percentage: percentage),
            green: lerpColorValue(val1: minG, val2: maxG, percentage: percentage),
            blue: lerpColorValue(val1: minB, val2: maxB, percentage: percentage),
            alpha: lerpColorValue(val1: minA, val2: maxA, percentage: percentage))
    }
    
    private func lerpColorValue(val1: CGFloat, val2: CGFloat, percentage: CGFloat) -> CGFloat {
        return val1 + (val2 - val1) * percentage
    }
    
}

extension ShoppingItemSliderTableViewCell : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        canScroll = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        canScroll = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //disable scroll when the view hasn't been dragged by the user (occuring when touching the view because the page width is smaller than the scrollview width)
        if !canScroll {
            scrollView.contentOffset = CGPoint(x: viewSpace.bounds.width, y: 0)
        }
        
        updateBackgroundColor()
        
        if scrollView.contentOffset.x <= 0 {
            
            if !currentGroup.isChecked {
            
                currentGroup.isChecked = true
                
                delegate?.sliderTableViewCell(cell: self, didChangeStateOfGroup: currentGroup)
            }
            
        } else if scrollView.contentOffset.x >= viewSpace.bounds.width {
            
            if currentGroup.isChecked {
                
                currentGroup.isChecked = false
                
                delegate?.sliderTableViewCell(cell: self, didChangeStateOfGroup: currentGroup)
            }
        }
        
    }
    
}

