//
//  Input.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Input: UIView, UITextFieldDelegate {
    
    var inputDelegate : InputDelegate!
    
    var inputTop = NSLayoutConstraint()
    //
    let textField = UITextField()
    //
    let type = UILabel()
    let name = UIButton()
    let suggestion = UIButton()
    let abv = UIButton()
    let size = UIButton()
    let oz = UIButton()
    let ml = UIButton()
    let price = UIButton()
    //
    var fields = [UIButton]()
    //
    var nameTop = NSLayoutConstraint()
    var suggestionHeight = NSLayoutConstraint()
    //
    var level: Int = 0
    let defaults = ["NAME","ABV","SIZE","PRICE"]
    //
    let inputNavigation = InputNavigation()
    //
    var output = ["NAME","ABV","SIZE","PRICE"]
    //
    var useThisSuggestion = ""
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        clipsToBounds = true
        roundCorners(corners: [.topLeft, .topRight], radius: UI.Sizing.userInputRadius)
        // Object settings
        addSubview(textField)
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        //
        type.translatesAutoresizingMaskIntoConstraints = false
        type.textColor = .white
        type.textAlignment = .center
        addSubview(type)
        //
        let buttons = [name,abv,size,price]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(defaults[i], for: .normal)
            buttons[i].contentHorizontalAlignment = .left
            addSubview(buttons[i])
            buttons[i].tag = i
            fields.append(buttons[i])
        }
        //
        suggestion.translatesAutoresizingMaskIntoConstraints = false
        suggestion.contentHorizontalAlignment = .right
        suggestion.setTitle("Use 'NAME'?", for: .normal)
        suggestion.addTarget(self, action: #selector(useSuggestion), for: .touchUpInside)
        addSubview(suggestion)
        //
        addSubview(inputNavigation)
        inputNavigation.build()
        inputNavigation.left.addTarget(self, action: #selector(navigateInput), for: .touchUpInside)
        inputNavigation.middle.addTarget(self, action: #selector(navigateInput), for: .touchUpInside)
        inputNavigation.right.addTarget(self, action: #selector(navigateInput), for: .touchUpInside)
        
        // MARK: - NSLayoutConstraints
        inputTop = topAnchor.constraint(equalTo: ViewController.bottomAnchor)
        nameTop = name.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.userInputRadius)
        suggestionHeight = suggestion.heightAnchor.constraint(equalToConstant: UI.Sizing.inputTextHeight)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.userInputHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            inputTop,
            type.topAnchor.constraint(equalTo: topAnchor),
            type.centerXAnchor.constraint(equalTo: centerXAnchor),
            type.heightAnchor.constraint(equalToConstant: UI.Sizing.userInputRadius),
            type.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            nameTop,
            suggestionHeight,
            suggestion.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            suggestion.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            suggestion.topAnchor.constraint(equalTo: name.bottomAnchor),
            abv.topAnchor.constraint(equalTo: suggestion.bottomAnchor),
            size.topAnchor.constraint(equalTo: abv.bottomAnchor),
            price.topAnchor.constraint(equalTo: size.bottomAnchor),
            textField.bottomAnchor.constraint(equalTo: topAnchor)
            ])
        for i in 0..<buttons.count {
            NSLayoutConstraint.activate([
                buttons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
                buttons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.inputTextHeight),
                buttons[i].leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            ])
        }
    }
    
    // MARK: - Functions (Input)
    @objc func navigateInput(sender: UIButton) {
        let fieldText = fields[level].titleLabel!.text!
        let inputDefault = defaults[level]
        if sender.tag == 0 {
            resetAndExit()
        }
        // moving forward and input != default || moving backward and not at beginning
        else if sender.tag == 1 && fieldText != inputDefault || sender.tag == -1 && level != 0 {
            // set output for level as field input before shifting level
            output[level] = fields[level].titleLabel!.text!
            // calculate new level
            let newLevel = level+sender.tag
            // if newLevel not before beginning or after end, move on
            if newLevel >= 0 && newLevel <= 4 {
                // calculate constant to move inputView up or down based on level
                let newConstant = UI.Sizing.inputTop - (UI.Sizing.inputTextHeight * CGFloat(newLevel))
                shiftInput(by: newConstant, toLevel: newLevel)
            }
        }
    }
    
    func shiftInput(by newConstant: CGFloat, toLevel newLevel: Int) {
        // set keyboard for number entry
        textField.keyboardType = .decimalPad
        // if first level (name) then set keyboard for text entry
        if newLevel == 0 {
            textField.keyboardType = .default
            // reset suggestion height
            suggestionHeight.constant = UI.Sizing.inputTextHeight
        }
        // need to reload the input view to update keyboard type
        textField.reloadInputViews()
        // if first level (ABV) then hide the suggestion bar
        if newLevel == 1 {
            suggestionHeight.constant = 0
            suggestion.setTitle("", for: .normal)
        }
        // if fourth level (doesn't exist, after price) exit
        if newLevel == 4 {
            /* SAVE ANSWERS */
            
            /* UPDATE ALC LIST IF NEW */
            saveAndExit()
            return
        }
        // if made it this far, update the level
        level = newLevel
        // update constraint to move input view
        inputTop.constant = newConstant
        // update field for new level
        fields[level].setTitle(output[level], for: .normal)
        // reset text field
        textField.text = ""
        // layout changes made to constants
        /* ANIMATE */
        layoutIfNeeded()
    }
    
    func saveAndExit() {
        let name = output[0]
        let abv = output[1]
        if let info = AlculateData.alcoholData[name] {
            let savedAbv = info.abv
            if savedAbv != abv {
                let title = "Reset \(name)'s ABV?"
                //let message = "\nfrom \(savedAbv)% to \(abv)%?"
                let changeAbv = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                changeAbv.addAction(UIAlertAction(title: "Update to \(abv)%", style: .destructive, handler: { action in
                    AlculateData.saveNewAlcohol(ofType: self.type.text!, named: self.output[0], withABVof: self.output[1])
                    self.resetAndExit()
                }))
                changeAbv.addAction(UIAlertAction(title: "Use \(savedAbv)%", style: .default, handler: { action in
                    self.resetAndExit()
                }))
                self.inputDelegate.displayAlert(alert: changeAbv)
            }
        }
        else {
            AlculateData.saveNewAlcohol(ofType: self.type.text!, named: self.output[0], withABVof: self.output[1])
            self.inputDelegate.reloadTable()
            self.resetAndExit()
        }
    }
        
    func resetAndExit() {
        // reset to NAME
        level = 0
        inputTop.constant = 0
        // reset textField
        textField.text = ""
        textField.resignFirstResponder()
        textField.keyboardType = .default
        textField.reloadInputViews()
        // reset output array
        output = ["NAME","ABV","SIZE","PRICE"]
        // reset field labels
        for i in 0..<fields.count {
            fields[i].setTitle(defaults[i], for: .normal)
        }
    }
    
    // MARK: - Functions (Suggestion)
    @objc func useSuggestion() {
        output[0] = useThisSuggestion
        output[1] = AlculateData.alcoholData[useThisSuggestion]!.abv
        name.setTitle(useThisSuggestion, for: .normal)
        abv.setTitle(output[1], for: .normal)
        // hide suggestion bar
        suggestionHeight.constant = 0
        suggestion.setTitle("", for: .normal)
        let inputWithSize = inputTop.constant-UI.Sizing.inputTextHeight
        // move on to SIZE
        shiftInput(by: inputWithSize, toLevel: 2)
    }
    
    func hideSuggestion() {
        // hide suggestion bar
        suggestionHeight.constant = 0
        suggestion.setTitle("", for: .normal)
        // reset to NAME
        inputTop.constant = UI.Sizing.inputTop
        layoutIfNeeded()
    }
    
    // MARK: - Functions (TextField)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // pass
    }
        
    @objc func textFieldDidChange(_ textField: UITextField) {
        // if NAME
        // update with textField text
        fields[level].setTitle(textField.text!, for: .normal)
        // if textfield gets reset to "" set to default
        if textField.text! == "" {
            fields[level].setTitle(defaults[level], for: .normal)
            // if reset to NAME, hide suggestion
            if level == 0 {
                hideSuggestion()
            }
        }
        if level == 0 {
            let textLower = textField.text!.lowercased()
            var arrNames: [String] = []
            for key in AlculateData.alcoholData.keys {
                if type.text! == AlculateData.alcoholData[key]!.type {
                    arrNames.append(key.lowercased())
                }
            }
            let filtered = arrNames.filter({ $0.contains(textLower) })
            if !filtered.isEmpty {
                inputTop.constant = UI.Sizing.inputTop - (UI.Sizing.inputTextHeight)
                suggestionHeight.constant = UI.Sizing.inputTextHeight
                layoutIfNeeded()
                // update suggestion with new text
                useThisSuggestion = filtered[0].capitalizingFirstLetter()
                let newSuggestion = "Use '\(filtered[0].capitalizingFirstLetter())'?"
                suggestion.setTitle(newSuggestion, for: .normal)
            }
            // hide suggestion
            else {
                hideSuggestion()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol InputDelegate {
    // called when user taps subview/delete button
    func displayAlert(alert: UIAlertController)
    func reloadTable()
}
