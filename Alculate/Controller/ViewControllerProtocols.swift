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
    
    // MARK: Protocol Delegate Functions
    func resetHeight(for table: String) {
        primary.scroll.updateHeight(for: table)
        primary.scroll.updateContentSize()
        primary.scroll.checkIfEmpty()
    }
    
    func animateComparisonLabels(to state: String) {
        (state == "moving") ? willEnterForeground() : nukeBothComparisonLabels()
    }
    
    func nukeBothComparisonLabels() {
        primary.header.value.nukeAllAnimations()
        primary.header.effect.nukeAllAnimations()
    }
    
    func displayAlert(alert : UIAlertController) {
        textEntry.field.resignFirstResponder()
        present(alert, animated: true, completion: nil)
    }
    
    func editSavedABV(name: String, abv: String, type: String) {
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: false)
        // reset output to saved data
        textEntry.outputFromSavedABV(name: name, abv: abv)
        textEntry.changeInputLevel(sender: textEntry.navigator.forward)
        // hide back and done buttons
        textEntry.navigator.backwardBottom.constant = UI.Sizing.Menu.height
    }
    
    func adjustHeaderBackground() {
        if let cell = secondary.drinkLibrary.table.cellForRow(at: secondary.drinkLibrary.table.indexPathsForVisibleRows![0]) {
            secondary.drinkLibrary.gradient2.colors = [cell.backgroundColor!.cgColor,cell.backgroundColor!.cgColor,cell.backgroundColor!.cgColor]
        }
    }
    
    func resetHeader() {
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        if secondaryTop.constant != secondaryViewAtTop {
            secondaryTop.constant = secondaryViewAtTop
            finishScrolling()
        }
    }
    
    func adjustHeaderConstant(to constant: CGFloat) {
        // Allow movement of contact card back/forth when not fully visible
        secondaryTop.constant += -constant
        // If contact card is fully visible, don't allow movement further left
        let currentConstant = secondaryTop.constant
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        secondaryTop.constant = currentConstant < secondaryViewAtTop ? secondaryViewAtTop : currentConstant
        secondary.layoutIfNeeded()
    }
    
    func finishScrolling() {
        let dismissRatio: CGFloat = 0.7
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        let currentRatio: CGFloat = secondaryTop.constant / secondaryViewAtTop
        (currentRatio >= dismissRatio) ? moveDrinkLibrary(to: "visible") : moveDrinkLibrary(to: "hidden")
        (currentRatio >= dismissRatio) ? nil : primary.moveMenu(to: "visible")
    }
    
    func editComparison(type: String, name: String, abv: String, size: String, price: String) {
        // reset output to saved data
        textEntry.outputFromComparison(name: name, abv: abv, size: size, price: price)
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: true)
    }
    
    func reloadTable(table: String, realculate: Bool = true) {
        if table == Data.masterListID {
            secondary.drinkLibrary.table.reloadData()
        }
        else {
            if realculate {
                sortByValue()
                alculate()
            }
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            let tables = [primary.scroll.beer.table,primary.scroll.liquor.table,primary.scroll.wine.table]
            for (i, ID) in Data.IDs.enumerated() {
                if table == ID {
                    //tables[i].reloadData()
                    tables[i].reloadSections(sections as IndexSet, with: .automatic)
                    //tables[i].updateTableContentInset()
                }
            }
        }
    }
    
    func updateComparison(for name: String, ofType type: String, wABV newAbv: String) {
        let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
        let tables = [primary.scroll.beer.table,primary.scroll.liquor.table,primary.scroll.wine.table]
        for (i, ID) in Data.IDs.enumerated() {
            if type == ID {
                for x in 0..<Data.lists[i].count {
                    if Data.lists[i][x].name == name {
                        let abv = Data.lists[i][x].abv
                        let size = Data.lists[i][x].size
                        let price = Data.lists[i][x].price
                        Data.deleteFromList(type, wName: name, wABV: abv, wSize: size, wPrice: price)
                        Data.saveToList(type, wName: name, wABV: newAbv, wSize: size, wPrice: price)
                        alculate()
                        tables[i].reloadSections(sections as IndexSet, with: .automatic)
                        //tables[i].updateTableContentInset()
                    }
                }
            }
        }
        
    }
    
    func insertRowFor(table: String) {
        let tables = [primary.scroll.beer.table,primary.scroll.liquor.table,primary.scroll.wine.table]
        let lists = Data.lists
        for (i, ID) in Data.IDs.enumerated() {
            if table == ID {
                tables[i].beginUpdates()
                let index = (lists[i].count-1 < 0) ? 0 : lists[i].count-1
                tables[i].insertRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
                tables[i].endUpdates()
                //tables[i].updateTableContentInset()
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
