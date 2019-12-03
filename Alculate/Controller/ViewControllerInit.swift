//
//  ViewControllerInit.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Setup
    func setup() {
        
        view.backgroundColor = UI.Color.ViewController.background
        
        view.addSubview(primary)
        primaryViewConstraints()
        primary.setup()
        primary.scroll.beer.header.add.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        primary.scroll.liquor.header.add.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        primary.scroll.wine.header.add.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        primary.menu.showDrinkLibrary.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        self.primary.scroll.beer.table.customDelegate = self
        self.primary.scroll.liquor.table.customDelegate = self
        self.primary.scroll.wine.table.customDelegate = self

        view.addSubview(secondary)
        secondaryViewConstraints()
        secondary.setup()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        secondary.drinkLibrary.header.addGestureRecognizer(pan)
        self.secondary.drinkLibrary.table.customDelegate = self

        view.addSubview(undo)
        undoConstraints()
        undo.setup()
        undo.confirm.addTarget(self, action: #selector(confirmUndo), for: .touchUpInside)
        undo.cancel.addTarget(self, action: #selector(cancelUndo), for: .touchUpInside)

        view.addSubview(tapDismiss)
        tapDismissConstraints()
        tapDismiss.setup()

        view.addSubview(textEntry)
        textEntryConstraints()
        textEntry.setup()
        self.textEntry.textEntryDelegate = self

    }
    
    //MARK: Onboarding
    func determineIfFirstLaunch() {
        // check if launched before
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: Strings.Key.hasLaunchedBefore)
        // if app has not launched before continue
        if !hasLaunchedBefore {
            // set to app has launched
            UserDefaults.standard.set(true, forKey: Strings.Key.hasLaunchedBefore)
            // load csv file of 300+ drinks into core data
            Data.txtFile()
            Data.loadList(for: Data.masterListID)
        }
        else {
            // normal run
            for list in [Data.masterListID,Data.beerListID,Data.liquorListID,Data.wineListID] {
                Data.loadList(for: list)
            }
            sortByValue()
        }
        setKeyboardFromCoreData()
    }

    //MARK: Setting Keyboard Height
    func setKeyboardFromCoreData() {
        // keyboard height
        let keyboardSet = UserDefaults.standard.bool(forKey: "keyboardSet")
        print("keyboardSet: \(keyboardSet)")
        if UserDefaults.standard.bool(forKey: "keyboardSet") {
            let keyboardHeight = UserDefaults.standard.double(forKey: "keyboard")
            UI.Sizing.keyboard = CGFloat(keyboardHeight)
            let keyboardDuration = UserDefaults.standard.double(forKey: "keyboardDuration")
            UI.Keyboard.duration = keyboardDuration
            let keyboardCurve = UserDefaults.standard.double(forKey: "keyboardCurve")
            UI.Keyboard.curve = UInt(keyboardCurve)
        }
    }

    //MARK: Observers
    func addNotificationCenterObservers() {
        // Add keyboard observer to retrieve keyboard height when keyboard shown
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // keyboard is set with approximate height prior to running (using ratio of keyboard to screen height)
            // if the keyboard has not been set, the exact height is found once keyboard is shown
            if !UserDefaults.standard.bool(forKey: "keyboardSet") {
                let keyboardRectangle = keyboardFrame.cgRectValue
                UserDefaults.standard.set(keyboardRectangle.height, forKey: "keyboard")
                UI.Sizing.keyboard = keyboardRectangle.height
                UserDefaults.standard.set(duration, forKey: "keyboardDuration")
                UI.Keyboard.duration = duration
                UserDefaults.standard.set(curve, forKey: "keyboardCurve")
                UI.Keyboard.curve = curve
                UserDefaults.standard.set(true, forKey: "keyboardSet")
            }
        }
    }

    //MARK: Legal Agreement
    func presentLegalAgreement(/*title: String, message: String*/) {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        // Either .unspecified, .light, or .dark
        let textColor: UIColor = (userInterfaceStyle == .dark) ? UI.Color.Font.standard : .black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let messageText = NSAttributedString(
            string: Strings.userAgreementMessage,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor : textColor,
                NSAttributedString.Key.font : UI.Font.Comparison.row!
            ]
        )
        alert = UIAlertController(title: Strings.userAgreementTitle, message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Agree", style: .default, handler: userHasAgreed))
        self.present(alert, animated: true)
    }

    func userHasAgreed(action:UIAlertAction) {
        UserDefaults.standard.set(true, forKey: Strings.Key.userHasAgreed)
    }
    
}
