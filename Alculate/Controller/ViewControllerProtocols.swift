//
//  ViewControllerProtocols.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    //MARK: Reset Comparison Table
    func resetHeight(for table: String) {
        primary.scroll.updateHeight(for: table)
        primary.scroll.updateContentSize()
        primary.scroll.checkIfEmpty()
    }
    
    //MARK: Long Drink Name Logic
    func animateLongDrinkNames(to state: String) {
        (state == "moving") ? willEnterForeground() : endLongDrinkNameAnimations()
    }
    
    func endLongDrinkNameAnimations() {
        primary.header.value.nukeAllAnimations()
        primary.header.effect.nukeAllAnimations()
    }
    
    //MARK: Edit DrinkLibrary Cell
    func editDrinkLibrary(name: String, abv: String, type: String) {
        // present text entry for specific type (partial)
        showTextEntry(forType: type, fullView: false)
        // reset output to saved data
        textEntry.outputFromSavedABV(name: name, abv: abv)
        textEntry.changeInputLevel(sender: textEntry.navigator.forward)
        // hide back and done buttons
        textEntry.navigator.backwardBottom.constant = UI.Sizing.Menu.height
    }
    
    //MARK: Edit Comparison Cell
    func editComparison(type: String, name: String, abv: String, size: String, price: String) {
        // reset output to saved data
        textEntry.outputFromComparison(name: name, abv: abv, size: size, price: price)
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: true)
    }

    //MARK: Secondary Scroll Animations
    func resetHeader() {
        // reset secondary to top if not already there
        if secondaryTop.constant != Constants.Constraint.secondaryVisible {
            secondaryTop.constant = Constants.Constraint.secondaryVisible
            finishScrolling()
        }
    }
    
    func adjustHeaderConstant(to constant: CGFloat) {
        // Allow movement of secondary up/down when not fully visible
        secondaryTop.constant += -constant
        // If secondary is fully visible, don't allow movement further up
        secondaryTop.constant = secondaryTop.constant < Constants.Constraint.secondaryVisible
            ? Constants.Constraint.secondaryVisible
            : secondaryTop.constant
        secondary.layoutIfNeeded()
    }
    
    func finishScrolling() {
        // if current ratio is more than the dismiss ratio the view will stay visible, if less it will be hidden
        let currentRatio: CGFloat = secondaryTop.constant / Constants.Constraint.secondaryVisible
        (currentRatio >= Constants.Constraint.dismissSecondary)
            ? moveDrinkLibrary(to: Constants.MoveTo.visible)
            : moveDrinkLibrary(to: Constants.MoveTo.hidden)
        (currentRatio >= Constants.Constraint.dismissSecondary) ? nil : primary.moveMenu(to: Constants.MoveTo.visible)
    }
        
    //MARK: Reload Comparison Table
    func reloadTable(table: String, realculate: Bool = true) {
        if table == Data.masterListID {
            secondary.drinkLibrary.table.reloadData()
        }
        else {
            realculate ? sortByValue() : nil
            realculate ? alculate() : nil
            // tables only have one section for now, this is simple way to refresh with animation (unlike reloadData)
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            // not putting tables in array variable on purpose
            let tables = [primary.scroll.beer.table,primary.scroll.liquor.table,primary.scroll.wine.table]
            for (i, ID) in Data.IDs.enumerated() {
                if table == ID {
                    tables[i].reloadSections(sections as IndexSet, with: .automatic)
                    // reset height of table after reloading
                    primary.scroll.updateHeight(for: table)
                }
            }
        }
    }
    
    //MARK: Update Comparison Table
    func updateComparison(for name: String, ofType type: String, wABV newAbv: String) {
        // tables only have one section for now, this is simple way to refresh with animation (unlike reloadData)
        let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
        // not putting tables in array variable on purpose
        let tables = [primary.scroll.beer.table,primary.scroll.liquor.table,primary.scroll.wine.table]
        for (i, ID) in Data.IDs.enumerated() {
            if type == ID {
                for x in 0..<Data.lists[i].count {
                    if Data.lists[i][x].name == name {
                        let abv = Data.lists[i][x].abv
                        let size = Data.lists[i][x].size
                        let price = Data.lists[i][x].price
                        // Delete old comparison record
                        Data.deleteFromList(type, wName: name, wABV: abv, wSize: size, wPrice: price)
                        // Insert new comparison record
                        Data.saveToList(type, wName: name, wABV: newAbv, wSize: size, wPrice: price)
                        // Realculate
                        alculate()
                        // Update table
                        tables[i].reloadSections(sections as IndexSet, with: .automatic)
                    }
                }
            }
        }
        
    }
    
    //MARK: Insert to Comparison Table
    func insertRowFor(table: String) {
        // not putting tables in array variable on purpose
        let tables = [primary.scroll.beer.table,primary.scroll.liquor.table,primary.scroll.wine.table]
        let lists = Data.lists
        for (i, ID) in Data.IDs.enumerated() {
            if table == ID {
                tables[i].beginUpdates()
                let index = (lists[i].count-1 < 0) ? 0 : lists[i].count-1
                tables[i].insertRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
                tables[i].endUpdates()
                // update height of table after insert
                primary.scroll.updateHeight(for: table)
                break
            }
        }
        primary.scroll.updateContentSize()
        primary.scroll.checkIfEmpty()
        sortByValue()
        alculate()
    }

    
}
