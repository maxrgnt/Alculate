//
//  Input.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol InputDelegate {
    // called when user taps subview/delete button
    func displayAlert(alert: UIAlertController)
    func reloadTable(table: String)
}

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
    var inputUnit = "oz"
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
        clipsToBounds = true
        roundCorners(corners: [.topLeft, .topRight], radius: UI.Sizing.userInputRadius)
        layer.borderWidth = UI.Sizing.cellObjectBorder*2
        layer.borderColor = UI.Color.alculatePurpleDark.cgColor
        // Object settings
        addSubview(textField)
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        //
        type.translatesAutoresizingMaskIntoConstraints = false
        type.textColor = UI.Color.softWhite
        type.textAlignment = .center
        addSubview(type)
        //
        let buttons = [name,abv,size,price]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(defaults[i], for: .normal)
            buttons[i].setTitleColor(UI.Color.softWhite, for: .normal)
            buttons[i].contentHorizontalAlignment = .left
            addSubview(buttons[i])
            buttons[i].tag = i
            fields.append(buttons[i])
        }
        let buttons2 = [oz,ml]
        for i in 0..<buttons2.count {
            buttons2[i].setTitleColor(UI.Color.softWhite, for: .normal)
            buttons2[i].translatesAutoresizingMaskIntoConstraints = false
            buttons2[i].contentHorizontalAlignment = .center
            buttons2[i].addTarget(self, action: #selector(changeSizeUnit(_:)), for: .touchUpInside)
            addSubview(buttons2[i])
            buttons2[i].tag = i
        }
        oz.setTitle("oz", for: .normal)
        ml.setTitle("ml", for: .normal)
        ml.alpha = 0.5
        //
        addSubview(suggestion)
        suggestion.translatesAutoresizingMaskIntoConstraints = false
        suggestion.contentHorizontalAlignment = .right
        suggestion.setTitle("Use 'NAME'?", for: .normal)
        suggestion.addTarget(self, action: #selector(useSuggestion), for: .touchUpInside)
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
            ml.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/5),
            ml.heightAnchor.constraint(equalToConstant: UI.Sizing.inputTextHeight),
            ml.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            ml.centerYAnchor.constraint(equalTo: size.centerYAnchor),
            oz.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/5),
            oz.heightAnchor.constraint(equalToConstant: UI.Sizing.inputTextHeight),
            oz.trailingAnchor.constraint(equalTo: ml.leadingAnchor, constant: -UI.Sizing.objectPadding),
            oz.centerYAnchor.constraint(equalTo: size.centerYAnchor),
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
            // calculate new level
            let newLevel = level+sender.tag
            // set output for level as field input before shifting level
            if level == 1 && sender.tag == 1 {
                output[level] = String(fields[level].titleLabel!.text!.dropLast())
            }
            else if level == 2 && sender.tag == 1 {
                output[level] = fields[level].titleLabel!.text!+inputUnit
            }
            else if level == 3 && sender.tag == 1  {
                output[level] = String(fields[level].titleLabel!.text!.dropFirst())
            }
            else {
                output[level] = fields[level].titleLabel!.text!
            }
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
        textField.keyboardType = .numberPad
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
            fields[0].alpha = 1.0
            changeSizeUnit(oz)
            /* UPDATE ALC LIST IF NEW */
            saveAndExit()
            return
        }
        // if made it this far, update the level
        level = newLevel
        // make all other labels less bright
        for i in 0..<fields.count {
            if i == level {
                fields[i].alpha = 1.0
            }
            else {
                fields[i].alpha = 0.5
            }
        }
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
        let name = output[0].lowercased()
        let abv = output[1]
        if let info = Data.masterList[name] {
            let savedAbv = info.abv
            if savedAbv != abv {
                let title = "Reset \(name)'s ABV?"
                //let message = "\nfrom \(savedAbv)% to \(abv)%?"
                let changeAbv = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                changeAbv.addAction(UIAlertAction(title: "Update to \(abv)%", style: .destructive, handler: { action in
                    Data.saveToMaster(ofType: self.type.text!, named: name, withABVof: abv)
                    self.inputDelegate.reloadTable(table: Data.masterListID)
                    self.resetAndExit()
                }))
                changeAbv.addAction(UIAlertAction(title: "Use \(savedAbv)%", style: .default, handler: { action in
                    self.resetAndExit()
                }))
                self.inputDelegate.displayAlert(alert: changeAbv)
            }
        }
        else {
            Data.saveToMaster(ofType: self.type.text!, named: name, withABVof: abv)
            self.inputDelegate.reloadTable(table: Data.masterListID)
        }
        updateTableTwo()
        self.resetAndExit()
    }
    
    func updateTableTwo() {
        var noMatches = true
        if type.text! == "BEER" {
            for info in Data.beerList {
                print([info.name, info.abv, info.size, info.price],output)
                if [info.name.lowercased(), info.abv, info.size, info.price] == output {
                    print("false")
                    noMatches = false
                }
                if noMatches {
                    Data.saveToList(Data.beerListID, wName: output[0], wABV: output[1], wSize: output[2], wPrice: output[3])
                    self.inputDelegate.reloadTable(table: Data.beerListID)
                }
            }
        }
        if type.text! == "LIQUOR" {
            for info in Data.liquorList {
                if [info.name, info.abv, info.size, info.price] == output {
                    noMatches = false
                }
                if noMatches {
                    Data.saveToList(Data.liquorListID, wName: output[0], wABV: output[1], wSize: output[2], wPrice: output[3])
                    self.inputDelegate.reloadTable(table: Data.liquorListID)
                }
            }
        }
        if type.text! == "WINE" {
            for info in Data.wineList {
                if [info.name, info.abv, info.size, info.price] == output {
                    noMatches = false
                }
                if noMatches {
                    Data.saveToList(Data.wineListID, wName: output[0], wABV: output[1], wSize: output[2], wPrice: output[3])
                    self.inputDelegate.reloadTable(table: Data.wineListID)
                }
            }
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
        let unformatted = Double(Data.masterList[useThisSuggestion]!.abv)!
        output[1] = String(format: "%.1f", unformatted)
        name.setTitle(useThisSuggestion.capitalizingFirstLetter(), for: .normal)
        abv.setTitle(output[1]+"%", for: .normal)
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
            textField.text = textField.text?.removeInvalidNameCharacters()
            fields[level].setTitle(textField.text!, for: .normal)
            let textLower = textField.text!.lowercased()
            var arrNames: [String] = []
            print(textLower, Data.masterList.keys)
            for key in Data.masterList.keys {
                if type.text! == Data.masterList[key]!.type {
                    arrNames.append(key)
                }
            }
            let filtered = arrNames.filter({ $0.contains(textLower) })
            if !filtered.isEmpty {
                inputTop.constant = UI.Sizing.inputTop - (UI.Sizing.inputTextHeight)
                suggestionHeight.constant = UI.Sizing.inputTextHeight
                layoutIfNeeded()
                // update suggestion with new text
                useThisSuggestion = filtered[0].lowercased()
                let newSuggestion = "Use '\(filtered[0].capitalizingFirstLetter())'?"
                suggestion.setTitle(newSuggestion, for: .normal)
            }
            // hide suggestion
            else {
                hideSuggestion()
            }
        }
        if level == 1 && textField.text != "" {
            var unformatted = Double(textField.text!)!/10
            if unformatted > 100 {
                unformatted = 100
            }
            fields[level].setTitle(String(format: "%.1f", unformatted)+"%", for: .normal)
        }
        if level == 2 && textField.text != "" {
            var unformatted = Double(textField.text!)!/10
            if unformatted > 10000 {
                unformatted = 10000
            }
            fields[level].setTitle(String(format: "%.1f", unformatted), for: .normal)
        }
        if level == 3 && textField.text != "" {
            var unformatted = Double(textField.text!)!/100
            if unformatted > 10000 {
                unformatted = 10000
            }
            fields[level].setTitle("$"+String(format: "%.2f", unformatted), for: .normal)
        }
        if textField.text == "" {
            fields[level].setTitle(defaults[level], for: .normal)
        }
    }
    
    @objc func changeSizeUnit(_ sender: UIButton) {
        if sender.tag == 0 {
            oz.alpha = 1.0
            ml.alpha = 0.5
            inputUnit = "oz"
        }
        else if sender.tag == 1 {
            oz.alpha = 0.5
            ml.alpha = 1.0
            inputUnit = "ml"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
