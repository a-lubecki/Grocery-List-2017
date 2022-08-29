//
//  StockedItemTableViewCell.swift
//  Shopping-List
//
//  Created by Aurelien Lubecki on 18/10/2017.
//  Copyright © 2017 Alubecki. All rights reserved.
//

import UIKit


protocol StockedItemTableViewCellDelegate : NSObjectProtocol {
    
    func stockedCell(cell: StockedItemTableViewCell, didRequireConsume group: StockedItemsGroup)
    
}


class StockedItemTableViewCell : BaseStockTableViewCell {
    
    
    @IBOutlet internal weak var viewSeparator: UIView!
    @IBOutlet internal weak var buttonSwap: UIButton!
    @IBOutlet internal weak var labelExpire: UILabel!
    
    @IBOutlet internal weak var datePicker: UIDatePicker!
    @IBOutlet internal weak var pickerPeriod: UIPickerView!
    @IBOutlet internal weak var pickerSeparator1: UIView!
    @IBOutlet internal weak var pickerSeparator2: UIView!
    
    @IBOutlet internal weak var buttonEdit: UIButton?
    
    @IBOutlet internal weak var buttonEditBottomConstraint: NSLayoutConstraint?
    
    
    weak var delegate: StockedItemTableViewCellDelegate?
    
    private(set) var editingExpiring = false
    private let units = [ExpiringUnit.day, .week, .month]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        viewSeparator.backgroundColor = ThemeManager.Color.themeSecondary
        pickerSeparator1.backgroundColor = ThemeManager.Color.transparentLight
        pickerSeparator2.backgroundColor = ThemeManager.Color.transparentLight
        
        datePicker.setValue(ThemeManager.Color.themeSecondary, forKey: "textColor")
    }
    
    
    override internal func updateGroup(g: StockedItemsGroup) {
        
        datePicker.minimumDate = g.daysBought
        
        super.updateGroup(g: g)
    }
    
    func setEditingExpiring(editingExpiring: Bool) {
        
        self.editingExpiring = editingExpiring
        
        if let buttonEditBottomConstraint = buttonEditBottomConstraint {
            
            if editingExpiring {
                buttonEditBottomConstraint.priority = UILayoutPriority(rawValue: 1)
            } else {
                buttonEditBottomConstraint.priority = UILayoutPriority(rawValue: 999)
            }
        }
        
        updateExpiringViews()
    }
    
    override internal func updateExpiringViews() {
        super.updateExpiringViews()
        
        viewSeparator.isHidden = true
        pickerSeparator1.isHidden = true
        pickerSeparator2.isHidden = true
        buttonSwap.isHidden = true
        labelExpire.isHidden = true
        datePicker.isHidden = true
        pickerPeriod.isHidden = true
        buttonEdit?.isHidden = true
        
        if editingExpiring {
            
            viewSeparator.isHidden = false
            pickerSeparator1.isHidden = false
            pickerSeparator2.isHidden = false
            buttonSwap.isHidden = false
            labelExpire.isHidden = false
            
            if currentGroup.preferDateForExpiring {
                
                buttonSwap.setImage(#imageLiteral(resourceName: "Button-Clock"), for: .normal)
                
                labelExpire.text = "Expire le :"
                
                datePicker.isHidden = false
                
                if let dateExpired = currentGroup.daysExpired {
                    datePicker.date = dateExpired
                } else {
                    datePicker.date = currentGroup.daysBought
                }
                
            } else {
                
                buttonSwap.setImage(#imageLiteral(resourceName: "Button-Calendar"), for: .normal)
                
                labelExpire.text = "Expiration :"
                
                pickerPeriod.isHidden = false
                
                if let period = currentGroup.periodBeforeExpire, let unit = currentGroup.unitBeforeExpire {
                    
                    pickerPeriod.selectRow(period, inComponent: 0, animated: false)
                    pickerPeriod.selectRow(getPickerPos(unit: unit), inComponent: 1, animated: false)
                    
                } else {
                    
                    pickerPeriod.selectRow(0, inComponent: 0, animated: false)
                    pickerPeriod.selectRow(pickerPeriod.selectedRow(inComponent: 1), inComponent: 1, animated: false)
                }
            }
            
        } else {
            
            buttonEdit?.isHidden = false
        }
        
    }
    
    private func getPickerPos(unit: ExpiringUnit) -> Int {
        
        for i in 0..<units.count {
            
            if units[i] == unit {
                return i
            }
        }
        
        return -1
    }
    
    private func getPickerTitle(unit: ExpiringUnit) -> String {
        
        if unit == .day {
            return "jour(s)"
        }
        if unit == .week {
            return "semaine(s)"
        }
        if unit == .month {
            return "mois"
        }
        
        return ""
    }
    
    
    @IBAction func buttonSwapDidTouch(_ sender: Any) {
        
        let oldDate = currentGroup.getExpiring()
        
        currentGroup.preferDateForExpiring = !currentGroup.preferDateForExpiring
        
        updateExpiringViews()
        
        
        //preselect item
        if let oldDate = oldDate {
            
            if currentGroup.preferDateForExpiring {
                
                datePicker.date = oldDate
                
            } else {
                
                let nbDaysDiff = Int((oldDate.timeIntervalSince1970 - currentGroup.daysBought.timeIntervalSince1970) / AppConstants.dayInSec)
                
                var possiblePeriod = 0
                var possibleUnit = ExpiringUnit.day
                
                var minDistance = Int.max
                
                //find the corresponding
                for u in [ExpiringUnit.day, .week, .month] {
                    
                    var previousDistance = Int.max
                    
                    for d in 1...pickerView(pickerPeriod, numberOfRowsInComponent: 0) {
                        
                        let distance = abs(d * u.rawValue - nbDaysDiff)
                        
                        if distance < minDistance {
                            minDistance = distance
                            possiblePeriod = d
                            possibleUnit = u
                        }
                        
                        if distance > previousDistance {
                            //not this unit
                            break
                        }
                        
                        previousDistance = distance
                    }
                    
                    if minDistance <= 0 {
                        //period and unit found
                        break
                    }
                }
                
                pickerPeriod.selectRow(possiblePeriod, inComponent: 0, animated: false)
                pickerPeriod.selectRow(getPickerPos(unit: possibleUnit), inComponent: 1, animated: false)
            }
            
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        
        currentGroup.changeExpiring(dateExpired: datePicker.date)
        
        updateExpiringViews()
    }
    
    
    @IBAction func buttonConsumeDidTouch(_ sender: Any) {
        
        delegate?.stockedCell(cell: self, didRequireConsume: currentGroup)
    }
    
}


extension StockedItemTableViewCell : UIPickerViewDataSource {
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return 11
        }
        
        if component == 1 {
            return units.count
        }
        
        return 0
    }
    
}

extension StockedItemTableViewCell : UIPickerViewDelegate {
 
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        guard let title = getPickerTitle(row: row, component: component) else {
            return nil
        }
        
        return NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor : ThemeManager.Color.themeSecondary])
    }
    
    func getPickerTitle(row: Int, component: Int) -> String? {
        
        if component == 0 {
            
            if row == 0 {
                return "-"
            }
            
            return row.description
        }
        
        if component == 1 {
            return getPickerTitle(unit: units[row])
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let period = pickerView.selectedRow(inComponent: 0)
        let unit = units[pickerView.selectedRow(inComponent: 1)]
        
        currentGroup.changeExpiring(periodBeforeExpire: period, unitBeforeExpire: unit)
        
        updateExpiringViews()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if component == 0 {
            return pickerView.frame.width * 0.25
        }
        
        if component == 1 {
            return pickerView.frame.width * 0.75
        }
        
        return 0
    }
    
}


