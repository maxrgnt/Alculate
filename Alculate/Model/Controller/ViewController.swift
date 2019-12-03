//
//  ViewController.swift
//  Alculate
//
//  Created by Max Sergent on 10/12/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit
import CoreData

// Setting protocol?
// Don't forget self.OBJECT.DELEGATE = self

class ViewController: UIViewController, ContainerTableDelegate, TextEntryDelegate, DrinkLibraryTableDelegate {
    
    //MARK: Definitions
    // Constraints
    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!
    static var secondaryTop: NSLayoutConstraint!
    // Objects
    var primaryView = PrimaryView()
    var secondaryView = SecondaryView()
    var tapDismiss = TapDismiss()
    var textEntry = TextEntry()
    var undo = Undo()
    var alert = UIAlertController(title: "title", message: "Hi", preferredStyle: .alert)
    static var typeValue: String! = ""
    static var typeEffect: String! = ""

    //MARK: ViewDidLoad
    override func viewDidLoad() {
        addObservers()
        
        ViewController.leadingAnchor = view.leadingAnchor
        ViewController.topAnchor = view.topAnchor
        ViewController.trailingAnchor = view.trailingAnchor
        ViewController.bottomAnchor = view.bottomAnchor

        view.backgroundColor = UI.Color.ViewController.background
        
        //clearTestData()
        
        let background = DispatchQueue.global()
        background.sync { self.handleOnboarding() }
        background.sync { self.setup()      }
        background.sync { self.handleKeyboard() }
        background.sync { self.primaryView.layoutIfNeeded()     }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
        //    background.sync { self.moveDrinkLibrary(to: "visible") }
        //}
        
    }
    
    //MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "presentLegalAgreement") {
            presentLegalAgreement()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Setup
    func setup() {
        
        view.addSubview(primaryView)
        primaryViewConstraints()
        primaryView.setup()
        
        for obj in [primaryView.comparison.beer,primaryView.comparison.liquor,primaryView.comparison.wine] {
            obj.header.add.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        }
        primaryView.menu.showDrinkLibrary.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        self.primaryView.comparison.beer.table.customDelegate = self
        self.primaryView.comparison.liquor.table.customDelegate = self
        self.primaryView.comparison.wine.table.customDelegate = self

        view.addSubview(secondaryView)
        secondaryViewConstraints()
        secondaryView.setup()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        secondaryView.drinkLibrary.header.addGestureRecognizer(pan)
        secondaryView.drinkLibrary.header.isUserInteractionEnabled = true
        self.secondaryView.drinkLibrary.table.customDelegate = self

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
    
    // MARK: Clear Testing
    func clearTestData(){
        Data.deleteCoreDataFor(entity: Data.masterListID)
        Data.deleteCoreDataFor(entity: Data.beerListID)
        Data.deleteCoreDataFor(entity: Data.liquorListID)
        Data.deleteCoreDataFor(entity: Data.wineListID)
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
        
    //MARK: Life Cycle
    @objc func didEnterBackground() {
        // stop long name animations
        for obj in [primaryView.comparison.beer, primaryView.comparison.liquor, primaryView.comparison.wine,
                    primaryView.header.value, primaryView.header.effect] {
            obj.subviews.forEach({$0.layer.removeAllAnimations()})
            obj.layer.removeAllAnimations()
            obj.layoutIfNeeded()
        }
    }

    @objc func willEnterForeground() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            for id in Data.IDs {
                reloadTable(table: id, realculate: false)
            }
            primaryView.comparison.checkIfEmpty()
            primaryView.comparison.updateContentSize()
            alculate()
        }
    }
    
    // MARK: TraitCollection (Dark Mode)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        var textColor: UIColor!
        let userInterfaceStyle = traitCollection.userInterfaceStyle // Either .unspecified, .light, or .dark
        // Update your user interface based on the appearance
        if userInterfaceStyle == .light || userInterfaceStyle == .light {
            textColor = .black
        }
        if userInterfaceStyle == .dark {
            textColor = UI.Color.Font.standard
        }
        if !UserDefaults.standard.bool(forKey: "presentLegalAgreement") {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let messageText = NSAttributedString(
                string: "\nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor : textColor!,
                    NSAttributedString.Key.font : UI.Font.Comparison.row!
                ]
            )
            alert.setValue(messageText, forKey: "attributedMessage")
        }
    }
    
}

