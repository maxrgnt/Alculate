//
//  TextEntry.swift
//  Alculate
//
//  Created by Max Sergent on 10/14/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol TextEntryDelegate: AnyObject {
    func displayAlert(alert: UIAlertController)
    func hideTextEntry()
    func reloadTable(table: String)
    func insertRowFor(table: String)
}

// MARK: - Text Field Stuff
protocol TextFieldDelegate {
    func textFieldDidDelete()
}

class TextEntryField: UITextField {
    
    var textFieldDelegate: TextFieldDelegate?
    override func deleteBackward() {
       super.deleteBackward()
       textFieldDelegate?.textFieldDidDelete()
    }
    
}

class TextEntry: UIView, UITextFieldDelegate, TextFieldDelegate {
    
    // Delegate object for Protocol above
    var textEntryDelegate: TextEntryDelegate?

    // Constraints
    var top: NSLayoutConstraint!
    var inputsHeight: NSLayoutConstraint!
    
    // Objects
    let field = TextEntryField()
    let navigator = TextNavigator()
    let inputs = TextEntryInputs()
    
    // Variables
    var maxLevel = 0
    var inputLevel = 0
    var defaults = ["begin typing a name","abv","size","price"]
    var output: [String] = []
    var sizeUnit = "oz"
    var entryID = ""

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
        output = defaults
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.textEntryRadius)
        layer.borderWidth = UI.Sizing.containerBorder*2
        layer.borderColor = UI.Color.alculatePurpleLite.cgColor
        // Required for textView delegates to work
        addSubview(field)
        field.delegate = self
        field.textFieldDelegate = self
        field.autocorrectionType = .no
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Blur object settings
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        // Vibrancy object settings
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        // Initialize gesture recognizer to dismiss view
        let sudheerSwipe = UISwipeGestureRecognizer(target: self, action: #selector(reactToSwipe))
        sudheerSwipe.direction = .down
        addGestureRecognizer(sudheerSwipe)
        let sudheerPan = UIPanGestureRecognizer(target: self, action: #selector(reactToPan))
        addGestureRecognizer(sudheerPan)
        //
        vibrancyView.contentView.addSubview(navigator)
        navigator.build()
        navigator.backward.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        navigator.forward.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        navigator.done.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        addSubview(inputs)
        inputs.oz.addTarget(self, action: #selector(setSizeUnit), for: .touchUpInside)
        inputs.ml.addTarget(self, action: #selector(setSizeUnit), for: .touchUpInside)
        inputs.build()
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        TextNavigator.bottom = navigator.bottomAnchor.constraint(equalTo: bottomAnchor)
        inputsHeight = inputs.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryInputsHeight)
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            top,
            TextNavigator.bottom,
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            vibrancyView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            vibrancyView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            inputs.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            inputsHeight,
            inputs.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputs.topAnchor.constraint(equalTo: topAnchor)
            ])
    }

    // MARK: - Navigate Input Level
    @objc func changeInputLevel(sender: UIButton) {
        // use navigate button tag to update the input level
        inputLevel += sender.tag
        // if at start, dont move further back
        inputLevel = (inputLevel < 0) ? 0 : inputLevel
        // if not at end, hide done
        outputNotDefaults()
        // if at end finish
        (inputLevel > maxLevel && maxLevel != 1) ? updateComparisonTables() : nil
        (inputLevel > maxLevel) ? updateSavedABVTable() : nil
        (inputLevel > maxLevel) ? dismiss() : nil
        // set input for new level
        setComponents(forLevel: inputLevel)
    }
    
    // MARK: - Set Saved Output
    func outputFromSavedABV(name: String, abv: String) {
        output[0] = name
        output[1] = abv
        inputs.name.setTitle(name, for: .normal)
        inputs.abv.setTitle("\(abv)%", for: .normal)
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
        navigator.backwardBottom.constant = (level == 0) ? UI.Sizing.appNavigatorHeight : 0
        // if at level 2 (size) update the sizeUnits
        inputs.oz.alpha = (sizeUnit=="oz"&&level==2) ? 1.0 : 0.5
        inputs.ml.alpha = (sizeUnit=="ml"&&level==2) ? 1.0 : 0.5
        // if at level 3 (price) update the "next" button
        navigator.forwardBottom.constant = (level == maxLevel) ? UI.Sizing.appNavigatorHeight : 0
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
        (level == 0) ? formattedText = changedText : nil
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
        var outputSafe = true
        for i in 0...maxLevel {
            outputSafe = (output[i] == defaults[i]) ? false : true
            if outputSafe == false {
                break
            }
        }
        navigator.doneBottom.constant = (outputSafe && inputLevel == maxLevel) ? 0 : UI.Sizing.appNavigatorHeight
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
        }
        // if not name and the field isnt empty
        else if textField.text != "" {
            // list of max vals for percent, size, price
            let maxVal = [100.0,10000.0,10000.0]
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
        top.constant = (top.constant < UI.Sizing.textEntryTop) ? UI.Sizing.textEntryTop : top.constant
        (top.constant > -UI.Sizing.keyboard) ? dismiss() : nil
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            (top.constant > UI.Sizing.textEntryGestureThreshold)
                // Auto-scroll down (out of frame) if true
                ? dismiss()
                // Auto-scroll up (in frame) if false
                : animateTopAnchor(constant: UI.Sizing.textEntryTop, withKeyboard: false)
        }
    }
    
    func dismiss() {
        navigator.doneBottom.constant = UI.Sizing.appNavigatorHeight
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
        self.textEntryDelegate?.hideTextEntry()
    }
    
    func updateComparisonTables() {
        // update output to include unit
        output[2] = output[2]+sizeUnit
        var noMatches = true
        let ids = [Data.beerListID,Data.liquorListID,Data.wineListID]
        for (i, dataList) in [Data.beerList,Data.liquorList,Data.wineList].enumerated() {
            if ids[i] == entryID {
                for info in dataList {
                    if [info.name.lowercased(), info.abv, info.size, info.price] == output {
                        noMatches = false
                    }
                }
                if noMatches {
                    Data.saveToList(ids[i], wName: output[0], wABV: output[1], wSize: output[2], wPrice: output[3])
                    self.textEntryDelegate!.insertRowFor(table: ids[i])
                }
            }
        }
    }
    
    func updateSavedABVTable() {
        let name = output[0]
        let abv = output[1]
        if let info = Data.masterList[name] {
            let savedAbv = info.abv
            if savedAbv != abv {
                let title = "Reset \(name)'s ABV?"
                //let message = "\nfrom \(savedAbv)% to \(abv)%?"
                let changeAbv = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                changeAbv.addAction(UIAlertAction(title: "Update to \(abv)%", style: .default, handler: { action in
                    Data.saveToMaster(ofType: self.entryID, named: name, withABVof: abv)
                    self.textEntryDelegate!.reloadTable(table: Data.masterListID)
                }))
                changeAbv.addAction(UIAlertAction(title: "Keep \(savedAbv)%", style: .cancel, handler: { action in
                    //
                }))
                self.textEntryDelegate!.displayAlert(alert: changeAbv)
            }
        }
        else {
            Data.saveToMaster(ofType: self.entryID, named: name, withABVof: abv)
            self.textEntryDelegate!.reloadTable(table: Data.masterListID)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
