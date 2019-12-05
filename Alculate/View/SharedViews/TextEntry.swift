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
    func reloadTable(table: String, realculate: Bool)
    func updateComparison(for: String, ofType: String, wABV: String)
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
    
    //MARK: Definitions
    // Delegate object for Protocol above
    var textEntryDelegate: TextEntryDelegate?
    // Constraints
    var top: NSLayoutConstraint!
    var inputsHeight: NSLayoutConstraint!
    // Objects
    let field = TextEntryField()
    let navigator = TextNavigator()
    let inputs = TextEntryInputs()
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: UIBlurEffect.Style.dark)))
    // Variables
    var maxLevel = 0
    var inputLevel = 0
    var defaults = Constants.TextEntry.defaults
    var output: [String] = []
    var sizeUnit = Constants.TextEntry.defaultSizeUnit
    var entryType = ""
    var suggestedName = ""
    var oldComparison: (name: String, abv: String, size: String, price: String) = (name: "", abv: "", size: "", price: "")
    var outputSafe = true
    
    //MARK: Initialization
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        output = defaults
        clipsToBounds = true
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.TextEntry.radii)
        layer.borderWidth = UI.Sizing.TextEntry.border
        layer.borderColor = UI.Color.lightAccent.cgColor
        objectSettings()
        constraints()
    }
    
    //MARK: Object Settings
    func objectSettings() {
        // Required for textView delegates to work
        addSubview(field)
        field.delegate = self
        field.textFieldDelegate = self
        field.autocorrectionType = .no
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Blur object settings
        addSubview(blurEffectView)
        // Vibrancy object settings
        blurEffectView.contentView.addSubview(vibrancyView)
        // Initialize gesture recognizer to dismiss view
        let sudheerSwipe = UISwipeGestureRecognizer(target: self, action: #selector(reactToSwipe))
        sudheerSwipe.direction = .down
        addGestureRecognizer(sudheerSwipe)
        let sudheerPan = UIPanGestureRecognizer(target: self, action: #selector(reactToPan))
        addGestureRecognizer(sudheerPan)
        vibrancyView.contentView.addSubview(navigator)
        navigator.setup()
        navigator.suggestion.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        navigator.backward.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        navigator.forward.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        navigator.done.addTarget(self, action: #selector(changeInputLevel), for: .touchUpInside)
        addSubview(inputs)
        for fields in [inputs.name, inputs.abv, inputs.size, inputs.price] {
            fields.addTarget(self, action: #selector(jumpToLevel), for: .touchUpInside)
        }
        inputs.oz.addTarget(self, action: #selector(setSizeUnit), for: .touchUpInside)
        inputs.ml.addTarget(self, action: #selector(setSizeUnit), for: .touchUpInside)
        inputs.setup()
        TapDismiss.dismiss.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    //MARK: Constraints
    func constraints() {
        inputConstraints()
        navigatorConstraints()
        blurEffectConstraints()
        vibrancyEffectConstraints()
    }

}
