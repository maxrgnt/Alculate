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
        
        // Setting protocol?
        // Don't forget self.OBJECT.DELEGATE = self
        
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

    //MARK: Keyboard Metrics
    func setKeyboardFromCoreData() {
        // keyboard height
        let keyboardMetricSaved = UserDefaults.standard.bool(forKey: Strings.Key.keyboardMetricSaved)
        if keyboardMetricSaved {
            UI.Sizing.keyboard = CGFloat(UserDefaults.standard.double(forKey: Strings.Key.keyboardHeight))
            UI.Keyboard.duration = UserDefaults.standard.double(forKey: Strings.Key.keyboardAnimateDuration)
            UI.Keyboard.curve = UInt(UserDefaults.standard.double(forKey: Strings.Key.keyboardAnimateCurve))
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
        let animateDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let animateCurve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // keyboard is set with approximate height prior to running (using ratio of keyboard to screen height)
            let keyboardMetricSaved = UserDefaults.standard.bool(forKey: Strings.Key.keyboardMetricSaved)
            // if the keyboard has not been set, the exact height is found once keyboard is shown
            if !keyboardMetricSaved {
                UserDefaults.standard.set(keyboardFrame.cgRectValue.height, forKey: Strings.Key.keyboardHeight)
                UserDefaults.standard.set(animateDuration, forKey: Strings.Key.keyboardAnimateDuration)
                UserDefaults.standard.set(animateCurve, forKey: Strings.Key.keyboardAnimateCurve)
                UserDefaults.standard.set(true, forKey: Strings.Key.keyboardMetricSaved)
                setKeyboardFromCoreData()
            }
        }
    }

    // MARK: Handle Dark/Light Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // If the user has not accepted agreement yet, proceed
        if !UserDefaults.standard.bool(forKey: Strings.Key.userHasAgreed) {
            alert.setValue(updatedAlertText(), forKey: "attributedMessage")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // App background color is dark, whether in light or dark mode make status bar light.
        return .lightContent
    }
    
    //MARK: Legal Agreement
    func presentLegalAgreement(/*title: String, message: String*/) {
        alert = UIAlertController(title: Strings.userAgreementTitle, message: "", preferredStyle: .alert)
        alert.setValue(updatedAlertText(), forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Agree", style: .default, handler: userHasAgreed))
        self.present(alert, animated: true)
    }
    
    func updatedAlertText() -> NSAttributedString {
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
        return messageText
    }

    func userHasAgreed(action:UIAlertAction) {
        UserDefaults.standard.set(true, forKey: Strings.Key.userHasAgreed)
    }
    
}
