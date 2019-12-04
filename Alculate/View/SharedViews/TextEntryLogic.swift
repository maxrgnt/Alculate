//
//  TextEntryLogic.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

extension TextEntry {
    
    // MARK: - Navigate Input Level
    @objc func changeInputLevel(sender: UIButton) {
        // use navigate button tag to update the input level
        inputLevel += sender.tag
        // if at start, dont move further back
        inputLevel = (inputLevel < 0) ? 0 : inputLevel
        // if using suggestion, update necessary stuff
        (sender.tag == 2) ? useSuggestedName() : nil
        // if not at end, hide done
        outputNotDefaults()
        // if at end finish
//        DispatchQueue.main.async {
//            (self.inputLevel > self.maxLevel && self.maxLevel != 1) ? self.updateComparisonTables() : nil
//            (self.inputLevel > self.maxLevel) ? self.updateSavedABVTable() : nil
//            (self.inputLevel > self.maxLevel) ? self.dismiss() : nil
//        }
        let hapticFeedback = UINotificationFeedbackGenerator()
        (inputLevel > maxLevel) ? hapticFeedback.notificationOccurred(.success) : nil
        (inputLevel > maxLevel && maxLevel != 1) ? updateComparisonTables() : nil
        (inputLevel > maxLevel) ? updateSavedABVTable() : nil
        (inputLevel > maxLevel) ? dismiss() : nil
        
        // set input for new level
        setComponents(forLevel: inputLevel)
    }
    
    @objc func jumpToLevel(sender: UIButton) {
        inputLevel = sender.tag
        // if not at end, hide done
        outputNotDefaults()
        // set input for new level
        setComponents(forLevel: inputLevel)
    }
    
    // MARK: - Set Saved Output
    func outputFromSavedABV(name: String, abv: String) {
        output[0] = name
        output[1] = abv
        inputs.name.setTitle(name.capitalized, for: .normal)
        inputs.abv.setTitle("\(abv)%", for: .normal)
    }
    
    func outputFromComparison(name: String, abv: String, size: String, price: String) {
        oldComparison = (name: name, abv: abv, size: size, price: price)
        output[0] = name
        output[1] = abv
        // using length of string minus the last two characters (oz or ml) ex. 24ml
        sizeUnit = String(size.dropFirst(size.count-2))
        // get the size by dropping last two characters (oz or ml) ex. 24ml
        let tempSize = size.dropLast(2)
        output[2] = String(tempSize)
        output[3] = price
    }
    
    // MARK: - Set Level Components
    func setComponents(forLevel level: Int) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction,.curveEaseOut], animations: {
                        self.setAlpha(forLevel: self.inputLevel)
                        self.superview!.layoutIfNeeded()
        })
        setText(forLevel: inputLevel)
    }
    
    func setAlpha(forLevel level: Int) {
        // Iterate over every input option
        for (i,input) in [inputs.name,inputs.abv,inputs.size,inputs.price].enumerated() {
            // if the input is the current level, make alpha 1, otherwise 0.5
            input.alpha = (i==level) ? 1.0 : 0.5
        }
        // if at level 0 (name) hide the back button
        navigator.backwardBottom.constant = (level == 0) ? UI.Sizing.Menu.height : 0
        // if not at level 0 hide suggestion
        navigator.suggestionBottom.constant = UI.Sizing.Menu.height
        // if at level 2 (size) update the sizeUnits
        inputs.oz.alpha = (sizeUnit=="oz"&&level==2) ? 1.0 : 0.5
        inputs.ml.alpha = (sizeUnit=="ml"&&level==2) ? 1.0 : 0.5
        for unit in [inputs.oz,inputs.ml] {
            unit.isHidden = (level != 2) ? true : false
        }
        // if at level 3 (price) update the "next" button
        navigator.forwardBottom.constant = (level == maxLevel) ? UI.Sizing.Menu.height : 0
    }
    
    func setText(forLevel level: Int) {
        field.keyboardType = (level<1) ? .default : .numberPad
        field.reloadInputViews()
        // Iterate over every input option
        for (i,input) in [inputs.name,inputs.abv,inputs.size,inputs.price].enumerated() {
            // make the input text equal to what is saved as output
            let title = (output[i]==defaults[i]) ? defaults[i] : formatOutput(with: output[i], atLevel: i)
            input.setTitle(title, for: .normal)
        }
        // set the textfield to empty unless non-default output has been entered (think back tracking)
        field.text = ((output[level] != defaults[level]) && (level == 0)) ? output[level] : ""
    }
    
    @objc func setSizeUnit(sender: UIButton) {
        sizeUnit = (sender.tag==3) ? "oz" : "ml"
        inputs.oz.alpha = (sizeUnit=="oz"&&inputLevel==2) ? 1.0 : 0.5
        inputs.ml.alpha = (sizeUnit=="ml"&&inputLevel==2) ? 1.0 : 0.5
    }

    func formatOutput(with changedText: String, atLevel level: Int) -> String {
        var formattedText = ""
        // add the % and $ to percent and price
        (level == 0) ? formattedText = changedText.capitalized : nil
        (level == 1) ? formattedText = "\(changedText)%" : nil
        (level == 2) ? formattedText = changedText : nil
        (level == 3) ? formattedText = "$\(changedText)" : nil
        // if any field is nil, replace with defaults
        (changedText == "") ? formattedText = defaults[level] : nil
        (level == 1 && changedText == "%") ? formattedText = defaults[level] : nil
        (level == 3 && changedText == "$") ? formattedText = defaults[level] : nil
        return formattedText
    }
    
    func outputNotDefaults() {
        for i in 0...maxLevel {
            outputSafe = (output[i] == defaults[i]) ? false : true
            if outputSafe == false {
                break
            }
        }
        navigator.doneBottom.constant = (outputSafe && inputLevel == maxLevel) ? 0 : UI.Sizing.Menu.height
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction,.curveEaseOut], animations: {
                        self.superview!.layoutIfNeeded()
        })
    }
    
    // MARK: - Text Field Did Change
    @objc func textFieldDidChange(_ textField: UITextField) {
        // set changed text and unformatted variables that will get altered
        var changedText = ""
        var unformatted: Double!
        // if it is the name, remove invalid characters and update text field
        if inputLevel == 0 {
            changedText = (field.text?.removeInvalidNameCharacters())!
            changedText = (changedText==" ") ? "" : changedText
            field.text = changedText
            (changedText == "") ? animateSuggestions(to: UI.Sizing.TextEntry.Navigator.height) : nil
            (changedText != "") ? checkSuggestions(for: changedText.lowercased()) : nil
        }
        // if not name and the field isnt empty
        else if textField.text != "" {
            // list of max vals for percent, size, price
            let maxVal = [100.0,1000.0,1000.0]
            // formatting for 100.0% | 12.0 oz | $4.00
            let formats = ["%.1f","%.1f","%.2f"]
            // set the unformatted to the max if over, otherwise whatever it is
            unformatted = (Double(field.text!)!/10 > maxVal[inputLevel-1]) ? maxVal[inputLevel-1] : Double(field.text!)!/10
            // format it using the formats above
            changedText = String(format: formats[inputLevel-1], unformatted)
        }
        // set output level to updated text
        output[inputLevel] = changedText
        (inputLevel == maxLevel) ? outputNotDefaults() : nil
        // format the output
        let formattedText = formatOutput(with: changedText, atLevel: inputLevel)
        // update the field with the new changed text
        inputs.fields[inputLevel].setTitle(formattedText, for: .normal)
    }
    
    func textFieldDidDelete() {
        if field.text == "" {
            output[inputLevel] = defaults[inputLevel]
            inputs.fields[inputLevel].setTitle(defaults[inputLevel], for: .normal)
        }
        outputNotDefaults()
    }
    
    // MARK: - Suggestion Logic
    func checkSuggestions(for changedText: String) {
        var arrNames: [String] = []
        for key in Data.masterList.keys {
            if entryType == Data.masterList[key]!.type {
                arrNames.append(key)
            }
        }
        arrNames = arrNames.sorted()
        let filtered = arrNames.filter({ $0.starts(with: changedText) }) // .contains
        if !filtered.isEmpty {
            // update suggestion with new text
            suggestedName = filtered[0].lowercased()
            navigator.suggestion.setTitle("Use '\(suggestedName.capitalized)'?", for: .normal)
            // animate
            animateSuggestions(to: 0)
        }
        else {
            animateSuggestions(to: UI.Sizing.TextEntry.Navigator.height)
        }
    }
    
    func useSuggestedName() {
        if suggestedName != "" {
            output[0] = suggestedName
            let unformatted = Double(Data.masterList[suggestedName]!.abv)!
            output[1] = String(format: "%.1f", unformatted)
            inputs.abv.setTitle(String(format: "%.1f", unformatted)+"%", for: .normal)
            animateSuggestions(to: UI.Sizing.TextEntry.Navigator.height)
        }
    }
    
    func animateSuggestions(to constant: CGFloat) {
        navigator.suggestionBottom.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction,.curveEaseOut], animations: {
                        self.superview!.layoutIfNeeded()
        })
    }

    // MARK: - Animate Top Anchor
    func animateTopAnchor(constant: CGFloat, withKeyboard: Bool? = true) {
        // update the text entry top anchor
        top.constant = constant
        // if the keyboard duration is nil (on first run) use what was set on iPhone 11
        var duration = (UI.Keyboard.duration==nil) ? 0.25 : UI.Keyboard.duration
        // if the keyboard curve is nil (on first run) use what was set on iPhone 11
        let curve = (UI.Keyboard.curve==nil) ? UInt(7) : UI.Keyboard.curve
        // if not with keyboard (reseting after partial pan, set with some bounce)
        duration = (withKeyboard==false) ? 0.55 : duration
        let damping = (withKeyboard==false) ? CGFloat(0.6) : CGFloat(1.0)
        let velocity = (withKeyboard==false) ? CGFloat(0.6) : CGFloat(1.0)
        // animate the view on screen with keyboard
        UIView.animate(withDuration: duration!, delay: 0.0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: UIView.AnimationOptions(rawValue: curve!),
                       animations: { //Do all animations here
                        self.superview!.layoutIfNeeded()
        }, completion: { (value: Bool) in
            //
        })
    }
    
    // MARK: - Dismiss
    @objc func reactToSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            dismiss()
        }
    }
    
    @objc func reactToPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        // Allow movement of text entry up/down when not fully visible
        top.constant += translation.y
        // If text entry is fully visible, don't allow movement further up
        top.constant = (top.constant < UI.Sizing.TextEntry.top) ? UI.Sizing.TextEntry.top : top.constant
        (top.constant > -UI.Sizing.keyboard) ? dismiss() : nil
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            (top.constant > UI.Sizing.TextEntry.gesture)
                // Auto-scroll down (out of frame) if true
                ? dismiss()
                // Auto-scroll up (in frame) if false
                : animateTopAnchor(constant: UI.Sizing.TextEntry.top, withKeyboard: false)
        }
    }
    
    @objc func dismiss() {
        oldComparison = (name: "", abv: "", size: "", price: "")
        TapDismiss.dismissTop.constant = UI.Sizing.bounds.height
        navigator.doneBottom.constant = UI.Sizing.Menu.height
        //
        sizeUnit = "oz"
        inputLevel = 0
        output = defaults
        setComponents(forLevel: inputLevel)
        //
        field.text = ""
        field.resignFirstResponder()
        //
        animateTopAnchor(constant: 0)
    }
    
    func updateComparisonTables() {
        // update output to include unit
        output[2] = output[2]+sizeUnit
        if oldComparison.name == "" {
            var noMatches = true
            let ids = [Data.beerListID,Data.liquorListID,Data.wineListID]
            for (i, dataList) in Data.lists.enumerated() {
                if ids[i] == entryType {
                    for info in dataList {
                        if [info.name.lowercased(), info.abv, info.size, info.price] == output {
                            noMatches = false
                        }
                    }
                    if noMatches {
                        Data.saveToList(ids[i], wName: output[0].lowercased(), wABV: output[1], wSize: output[2], wPrice: output[3])
                        self.textEntryDelegate!.insertRowFor(table: ids[i])
                    }
                }
            }
        }
        else {
            for id in Data.IDs {
                if id == entryType {
                    let old = oldComparison
                    Data.deleteFromList(id, wName: old.name, wABV: old.abv, wSize: old.size, wPrice: old.price)
                    Data.saveToList(id, wName: output[0].lowercased(), wABV: output[1], wSize: output[2], wPrice: output[3])
//                    (i == 2) ? self.textEntryDelegate!.reloadTable(table: id, realculate: true) : self.textEntryDelegate!.reloadTable(table: id, realculate: false)
                    self.textEntryDelegate!.reloadTable(table: id, realculate: true)
                    oldComparison = (name: "", abv: "", size: "", price: "")
                }
            }
        }
    }
    
    func updateSavedABVTable() {
        let name = output[0].lowercased()
        let abv = output[1]
        if let info = Data.masterList[name] {
            let savedType = info.type
            let savedAbv = info.abv
            if savedAbv != abv && savedType == entryType {
                let title = "Reset \(name)'s ABV?"
                //let message = "\nfrom \(savedAbv)% to \(abv)%?"
                let changeAbv = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                changeAbv.addAction(UIAlertAction(title: "Update to \(abv)%", style: .default, handler: { action in
                    Data.saveToMaster(ofType: self.entryType, named: name, withABVof: abv)
                    self.textEntryDelegate!.reloadTable(table: Data.masterListID, realculate: false)
                    self.textEntryDelegate!.updateComparison(for: name, ofType: self.entryType, wABV: abv)
                }))
                changeAbv.addAction(UIAlertAction(title: "Keep \(savedAbv)%", style: .cancel, handler: { action in
                    // pass
                }))
                self.textEntryDelegate!.displayAlert(alert: changeAbv)
            }
        }
        else {
            Data.saveToMaster(ofType: self.entryType, named: name, withABVof: abv)
            self.textEntryDelegate!.reloadTable(table: Data.masterListID, realculate: false)
            self.textEntryDelegate!.updateComparison(for: name, ofType: entryType, wABV: abv)
        }
    }

    
}
