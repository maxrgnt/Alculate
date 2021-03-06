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
        primary.scroll.beer.header.add.addTarget(   self, action: #selector(navigateApp), for: .touchUpInside)
        primary.scroll.liquor.header.add.addTarget( self, action: #selector(navigateApp), for: .touchUpInside)
        primary.scroll.wine.header.add.addTarget(   self, action: #selector(navigateApp), for: .touchUpInside)
        primary.menu.showDrinkLibrary.addTarget(    self, action: #selector(navigateApp), for: .touchUpInside)
        self.primary.scroll.beer.table.customDelegate = self
        self.primary.scroll.liquor.table.customDelegate = self
        self.primary.scroll.wine.table.customDelegate = self
        primary.layoutIfNeeded()

        view.addSubview(secondary)
        secondaryViewConstraints()
        secondary.setup()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        secondary.drinkLibrary.header.addGestureRecognizer(pan)
        self.secondary.drinkLibrary.table.customDelegate = self

        view.addSubview(undo)
        undoConstraints()
        undo.setup()
        undo.confirm.addTarget( self, action: #selector(confirmUndo), for: .touchUpInside)
        undo.cancel.addTarget(  self, action: #selector(cancelUndo), for: .touchUpInside)

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
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: Constants.Key.hasLaunchedBefore)
        // if app has not launched before continue
        if !hasLaunchedBefore {
            // set to app has launched
            UserDefaults.standard.set(true, forKey: Constants.Key.hasLaunchedBefore)
            // load csv file of 300+ drinks into core data
            Data.pullCSVfileIntoCoreData()
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
        let keyboardMetricSaved = UserDefaults.standard.bool(forKey: Constants.Key.keyboardMetricSaved)
        if keyboardMetricSaved {
            UI.Sizing.keyboard = CGFloat(UserDefaults.standard.double(forKey: Constants.Key.keyboardHeight))
            UI.Keyboard.duration = UserDefaults.standard.double(forKey: Constants.Key.keyboardAnimateDuration)
            UI.Keyboard.curve = UInt(UserDefaults.standard.double(forKey: Constants.Key.keyboardAnimateCurve))
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
        // did enter background for when app closed out
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        // did enter foreground for when app opened (runs after viewDidLoad if opening cold)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // keyboard metrics that are accesible once keyboard has shown
        let animateDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let animateCurve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // keyboard is set with approximate height prior to running (using ratio of keyboard to screen height)
            let keyboardMetricSaved = UserDefaults.standard.bool(forKey: Constants.Key.keyboardMetricSaved)
            // if the keyboard sizing variable has not been set, the exact height is found once keyboard is shown
            if !keyboardMetricSaved {
                UserDefaults.standard.set(keyboardFrame.cgRectValue.height, forKey: Constants.Key.keyboardHeight)
                UserDefaults.standard.set(animateDuration, forKey: Constants.Key.keyboardAnimateDuration)
                UserDefaults.standard.set(animateCurve, forKey: Constants.Key.keyboardAnimateCurve)
                UserDefaults.standard.set(true, forKey: Constants.Key.keyboardMetricSaved)
                setKeyboardFromCoreData()
            }
        }
    }

    // MARK: Handle Dark/Light Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // If the user has not accepted agreement yet, proceed
        if !UserDefaults.standard.bool(forKey: Constants.Key.userHasAgreed) {
            alert.setValue(updatedAlertText(), forKey: Constants.Key.attributedMessage)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // App background color is dark, whether in light or dark mode make status bar light.
        return .lightContent
    }
    
    //MARK: Legal Agreement
    func presentLegalAgreement() {
        // update alert title and style
        alert = UIAlertController(title: Constants.UserAgreement.title, message: "", preferredStyle: .alert)
        // update alert message, has to be done this way to change font color
        alert.setValue(updatedAlertText(), forKey: Constants.Key.attributedMessage)
        // add the agree action that will stop agreement from showing once pressed
        alert.addAction(UIAlertAction(title: Constants.UserAgreement.action, style: .default, handler: userHasAgreed))
        // present alert
        self.present(alert, animated: true)
    }
    
    func updatedAlertText() -> NSAttributedString {
        // userInterfaceStyle can be either .unspecified .light or .dark
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        // if the style is dark make the font color the same as font color used in app (lighter due to app background being dark)
        // if the style is not dark make the font color black to stand out on white alert
        let textColor: UIColor = (userInterfaceStyle == .dark) ? UI.Color.Font.standard : .black
        // set paragraph style to be left aligned instead of default centered 
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let messageText = NSAttributedString(
            // set the string as the useragreement message
            string: Constants.UserAgreement.message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor : textColor,
                NSAttributedString.Key.font : UI.Font.Comparison.row!
            ]
        )
        return messageText
    }
    
    func displayAlert(alert : UIAlertController) {
        // need to resign first responder for some reason to avoid keyboard from popping up
        textEntry.field.resignFirstResponder()
        present(alert, animated: true, completion: nil)
    }

    func userHasAgreed(action:UIAlertAction) {
        // if the user agrees then the legal agreement will no longer show up
        UserDefaults.standard.set(true, forKey: Constants.Key.userHasAgreed)
    }
    
}
