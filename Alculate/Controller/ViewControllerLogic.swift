//
//  ViewControllerLogic.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Navigate App
    @objc func navigateApp(sender: UIButton) {
        // Buttons with Tag greater than 20 are for text entry
        (sender.tag >= 20) ? showTextEntry(forType: Data.IDs[sender.tag-20], fullView: true) : nil
        // Button tag == 1 for showing DrinkLibrary
        if sender.tag == 1 {
            // Stop long name animations
            nukePrimaryAnimations()
            // Hide the primary menu
            primary.moveMenu(to: Constants.MoveTo.hidden)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Show the drink library after a delay
                self.moveDrinkLibrary(to: Constants.MoveTo.visible)
            }
        }
    }
    
    //MARK: Animations
    func nukePrimaryAnimations() {
        // Stop long names from animating in primary view
        primary.subviews.forEach({$0.layer.removeAllAnimations()})
        primary.layer.removeAllAnimations()
        primary.layoutIfNeeded()
    }
    
    func moveDrinkLibrary(to state: String) {
        // if state is hidden then set constant as 0 (top of drink library to bottom of screen)
        // if state is visible then set as -height of view (top of drink library to top of screen)
        let new: CGFloat = (state == Constants.MoveTo.hidden)
            ? Constants.Constraint.secondaryHidden
            : Constants.Constraint.secondaryVisible
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut
            , animations: ({
                self.secondaryTop.constant = new
                self.view.layoutIfNeeded()
            }), completion: { (completed) in
                // if DrinkLibrary being hidden, animate the long drink names on primary view
                // if DrinkLibrary being visible, stop animating long drink names on primary view
                let animationType = (state == Constants.MoveTo.hidden)
                    ? Constants.Animate.moving
                    : Constants.Animate.still
                self.animateLongDrinkNames(to: animationType)
        })
    }
    
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        // Hide index titles while moving
        secondary.drinkLibrary.table.isMoving = true
        secondary.drinkLibrary.table.reloadSectionIndexTitles()
        // Move view up/down
        let translation = sender.translation(in: self.view)
        secondaryTop.constant += translation.y
        // If view is fully visible, don't allow movement further up
        let currentConstant = secondaryTop.constant
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        secondaryTop.constant = currentConstant < secondaryViewAtTop ? secondaryViewAtTop : currentConstant
        // Set recognizer to start new drag gesture
        sender.setTranslation(CGPoint.zero, in: secondary.drinkLibrary.header)
        // Move view in/out of view once pan ended
        if sender.state == UIGestureRecognizer.State.ended {
            // Show index titles now that pan has stopped
            secondary.drinkLibrary.table.isMoving = false
            secondary.drinkLibrary.table.reloadSectionIndexTitles()
            // Set temp variables for easier to read ternary operators
            let secondaryAtTop = -UI.Sizing.Secondary.height
            let currentRatio: CGFloat = secondaryTop.constant / secondaryAtTop
            // "Ratio" meaning if more than 70% visible (dismissSecondary), keep on screen
            let dismissRatio = Constants.Constraint.dismissSecondary
            (currentRatio >= dismissRatio)
                ? moveDrinkLibrary(to: Constants.MoveTo.visible)
                : moveDrinkLibrary(to: Constants.MoveTo.hidden)
            (currentRatio >= dismissRatio)
                ? nil
                : primary.moveMenu(to: Constants.MoveTo.visible)
            // If moving view off screen, scroll table back to top
            (currentRatio >= dismissRatio)
                ? nil
                : secondary.drinkLibrary.table.scrollToFirstRow()
        }
    }
    
    @objc func animateUndo(onScreen: Bool = true) {
        let constant = (onScreen == false)
            ? Constants.Constraint.undoOffScreen
            : Constants.Constraint.undoOnScreen
        UIView.animate(withDuration: 0.55, delay: 0.0,usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut,.allowUserInteraction],
                       animations: {
                        self.undo.top.constant = constant
                        self.view.layoutIfNeeded()
        }, completion: {(value: Bool) in
            // pass
           })
    }
    
    // MARK: Show Text Entry
    func showTextEntry(forType id: String, fullView: Bool, forLevel level: Int? = 0) {
        // bring dismissTop into view where 0 means top = top
         TapDismiss.dismissTop.constant = 0
        // set entry id
        textEntry.entryType = id
        // set max level
        textEntry.maxLevel = (fullView==true) ? 3 : 1
        // reset components for first level (name)
        textEntry.setComponents(forLevel: level!)
        // set icon for given type
        textEntry.inputs.icon.image = UIImage(named: id)
        // show keyboard
        textEntry.field.becomeFirstResponder()
        // hide non-essential pieces if partial
        for obj in [textEntry.inputs.size,textEntry.inputs.price] {
            obj.isHidden = (fullView==true) ? false : true
        }
        // adjust height of input view to make space for text navigator if partial
        textEntry.inputsHeight.constant = (fullView==true)
            ? UI.Sizing.TextEntry.Input.height
            : UI.Sizing.TextEntry.Input.heightPartial
        // move app navigator up in input view if partial
        TextNavigator.bottom.constant = (fullView==true)
            ? -UI.Sizing.keyboard
            : -UI.Sizing.keyboard-(2*UI.Sizing.TextEntry.Field.height)
        // set top of text entry to whether full (compare) or partial (savedABV)
        let topConstant = (fullView==true) ? UI.Sizing.TextEntry.top : UI.Sizing.TextEntry.topPartial
        textEntry.animateTopAnchor(constant: topConstant)
    }
        
    //MARK: Confirm Undo (Don't Delete)
    @objc func confirmUndo() {
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        // if secondary view is visible run undo for secondary
        (secondaryTop.constant == Constants.Constraint.secondaryVisible)
            ? undoForSecondary()
            // otherwise run undo for primary
            : undoForPrimary()
        // move the undo button off screen
        animateUndo(onScreen: false)
    }
    
    func undoForPrimary() {
        // toBeDeleted array of arrays [[],[],[]]
        for (i,list) in Data.toBeDeleted.enumerated() {
            // if an array in toBeDeleted is not empty its respective position in Data.IDs is used to refill that table
            if !list.isEmpty {
                for obj in list {
                    Data.saveToList(Data.IDs[i], wName: obj.name, wABV: obj.abv, wSize: obj.size, wPrice: obj.price)
                    insertRowFor(table: Data.IDs[i])
                }
            }
        }
        // reset toBeDeleted
        Data.toBeDeleted = [[],[],[]]
    }
    
    func undoForSecondary() {
        // if the toBeDeleted array is not empty
        if !secondary.drinkLibrary.table.toBeDeleted.isEmpty {
            // for every object in toBeDeleted, add it back to the Data master list
            for info in secondary.drinkLibrary.table.toBeDeleted {
                Data.masterList[info.name] = (type: info.type, abv: info.abv)
            }
            secondary.drinkLibrary.table.reloadData()
        }
        // reset to be deleted
        secondary.drinkLibrary.table.toBeDeleted = []
    }
    
    //MARK: Cancel Undo (Do Delete)
    @objc func cancelUndo() {
        // if secondary visible, delete from master list
        (secondaryTop.constant == Constants.Constraint.secondaryVisible)
            ? removeDrinkFromLibrary()
            // else delete from comparison tables
            : clearTemporaryComparisonData()
        // move the undo button off screen
        animateUndo(onScreen: false)
    }
    
    func removeDrinkFromLibrary() {
        // iterate over every object in the toBeDeleted table
        for info in secondary.drinkLibrary.table.toBeDeleted {
            // make the database editable
            Data.isEditable = true
            // update the database to match the list with now deleted values
            Data.masterList = Data.masterList
            // delete objects in toBeDeleted from coreData
            Data.deleteMaster(wName: info.name, wABV: info.abv, wType: info.type)
        }
    }
    
    func clearTemporaryComparisonData() {
        Data.toBeDeleted = [[],[],[]]
    }

    //MARK: Alculate Logic
    func alculate() {
        // check if comparison tables are empty
        primary.scroll.checkIfEmpty()
        // create framework of array of lists that are not empty
        var topDrinks: [(arr: (name: String, abv: String, size: String, price: String), ind: Int)]! = []
        // iterate through each type list to see if empty
        for (index, drinks) in Data.lists.enumerated() {
            // if the list of drinks for a given type is not empty
            // add the first drink to topDrinks to be compared (already sorted)
            if !drinks.isEmpty {
                topDrinks.append((arr: drinks.first!, ind: index))
            }
        }
        // if topDrinks is not empty, compare them against themselves
        if !topDrinks.isEmpty {
            // make the summary views visible
            primary.moveSummaryAnchor(to: Constants.MoveTo.visible)
            let best = determineBest(from: topDrinks)
            updateSummary(value: best.value, effect: best.effect)
        }
        // if all lists are empty, dont alculate
        else {
            primary.moveSummaryAnchor(to: Constants.MoveTo.hidden)
        }
    }
    
    //MARK: Determine Best Drink
    func determineBest(from topDrinks: [(arr: (name: String, abv: String, size: String, price: String), ind: Int)]) ->
        (value: (name: String, best: String, ind: Int), effect: (name: String, best: String, ind: Int)){
        // create framework of best alcohol of top items from each list
        var bestValue: (name: String, best: String, ind: Int)!
        var bestEffect: (name: String, best: String, ind: Int)!
        // start with first drink in array
        let info = topDrinks.first!.arr
        // determine of the topDrinks which is the best value
        bestValue = (name: info.name,
                     best: String(format: "%.2f", calculateValue(for: info)),
                     ind:  topDrinks.first!.ind)
        for drink in topDrinks {
            let maybeBest = calculateValue(for: drink.arr)
            if maybeBest < Double(bestValue.best)! {
                bestValue = (name: drink.arr.name,
                             best: String(format: "%.2f", maybeBest),
                             ind:  drink.ind)
            }
        }
        bestEffect = (name: info.name,
                     best: String(format: "%.1f", calculateEffect(for: info)),
                     ind:  topDrinks.first!.ind)
        for drink in topDrinks {
            let maybeBest = calculateEffect(for: drink.arr)
            if maybeBest > Double(bestEffect.best)! {
                bestEffect = (name: drink.arr.name,
                              best: String(format: "%.1f", maybeBest),
                              ind: drink.ind)
            }
        }
        return (value: bestValue, effect: bestEffect)
    }
    
    //MARK: Update Summary
    func updateSummary(value: (name: String, best: String, ind: Int), effect: (name: String, best: String, ind: Int)) {
        // update summary header text colors based on which type is best
        let priceColor = UI.Color.Background.drinkTypes[value.ind]
        let effectColor = UI.Color.Background.drinkTypes[effect.ind]
        primary.header.value.category.textColor = priceColor
        primary.header.effect.category.textColor = effectColor
        // update the summary text itself
        primary.header.value.name.text = value.name.capitalized
        primary.header.value.stat.text = "$"+value.best
        primary.header.effect.name.text = effect.name.capitalized
        primary.header.effect.stat.text = effect.best
        // update the total line
        calculateTotalSpent()
        calculateTotalShots()
    }
    
    //MARK: Calculations for Alculate
    func calculateEffect(for info: (name: String, abv: String, size: String, price: String)) -> Double {
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        var correctedSize = Double(info.size.dropLast(2))!
        correctedSize = sizeUnit == Constants.TextEntry.otherSizeUnit ? correctedSize/29.5735296875 : correctedSize
        return ((Double(info.abv)!*0.01)*correctedSize)/0.6
    }
    
    func calculateValue(for info: (name: String, abv: String, size: String, price: String)) -> Double {
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        var correctedSize = Double(info.size.dropLast(2))!
        correctedSize = sizeUnit == Constants.TextEntry.otherSizeUnit ? correctedSize/29.5735296875 : correctedSize
        let price = Double(info.price)! >= 0 ? Double(info.price)! : 1
        return price/(((Double(info.abv)!*0.01)*correctedSize)/0.6)
    }
    
    func calculateTotalSpent() {
        var totalSpent: Double = 0.0
        for list in Data.lists {
            for info in list {
                totalSpent += Double(info.price)!
            }
        }
        let totalSpentText = (totalSpent > 999.0) ? "$$$" : "$"+String(format: "%.2f", totalSpent)
        primary.scroll.total.spent.text = totalSpentText
    }
    
    func calculateTotalShots() {
        var totalShots: Double = 0.0
        for list in Data.lists {
            for info in list {
                // get the unitForSize by dropping the first part of string
                // using length of string minus the last two characters (oz or ml) ex. 24ml
                let sizeUnit = info.size.dropFirst(info.size.count-2)
                // get the size by dropping last two characters (oz or ml) ex. 24ml
                let size = info.size.dropLast(2)
                var correctedSize = Double(size)!
                // if unitForSize is ml, need to convert to oz for calculations
                if sizeUnit == Constants.TextEntry.otherSizeUnit {
                    // convert ml size to ounces using ratio of ml per oz
                    correctedSize = correctedSize/29.5735296875
                }
                // calculate the effectiveness
                let abvAsDecimal = (0.01)*Double(info.abv)!
                let standardShot = (0.4 /*ABV*/ * 1.5 /*oz*/) // = 0.6
                totalShots += (abvAsDecimal*correctedSize)/standardShot
            }
        }
        let totalShotText = (totalShots > 99.0) ? "XXX" : String(format: "%.1f", totalShots)
        primary.scroll.total.shots.text = totalShotText
    }
    
    // MARK: Flip Alculate
    func flipAlculate() {
        // code here the switch of sortByValue() vs sortByEffect()
        alculate()
    }
    
    func sortByValue() {
        for i in 0..<Data.lists.count {
            Data.lists[i] = Data.lists[i].sorted { (drink1, drink2) -> Bool in
                return calculateValue(for: drink1) < calculateValue(for: drink2)
            }
            reloadTable(table: Data.IDs[i], realculate: false)
        }
    }
    
    func sortByEffect() {
        for i in 0..<Data.lists.count {
            Data.lists[i] = Data.lists[i].sorted { (drink1, drink2) -> Bool in
                return calculateEffect(for: drink1) > calculateEffect(for: drink2)
            }
            reloadTable(table: Data.IDs[i], realculate: false)
        }
    }
}
