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
    var secondaryTop: NSLayoutConstraint!
    // Objects
    var primary     = PrimaryView()
    var secondary   = SecondaryView()
    var tapDismiss  = TapDismiss()
    var textEntry   = TextEntry()
    var undo        = Undo()
    var alert       = UIAlertController(title: "", message: "", preferredStyle: .alert)

    //MARK: ViewDidLoad
    override func viewDidLoad() {
        // Clear data while testing
        let clearTestData = "no"
        (clearTestData == "yes") ? clearAllDataForTesting() : nil
        // Syncronously setup the app, running next line only after previous completed
        let background = DispatchQueue.global()
        background.sync { self.setup()                          }
        background.sync { self.determineIfFirstLaunch()         }
        background.sync { self.primary.layoutIfNeeded()         }
        background.sync { self.addNotificationCenterObservers() }
    }
    
    //MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        // Present user agreement if hasn't been agreed to yet
        let userHasAgreed = UserDefaults.standard.bool(forKey: Strings.Key.userHasAgreed)
        userHasAgreed ? nil : presentLegalAgreement()
    }
        
    // MARK: Clear Testing
    func clearAllDataForTesting(){
        // Delete core data entities
        Data.deleteCoreDataFor(entity: Data.masterListID )
        Data.deleteCoreDataFor(entity: Data.beerListID   )
        Data.deleteCoreDataFor(entity: Data.liquorListID )
        Data.deleteCoreDataFor(entity: Data.wineListID   )
        // Delete onboarding/keyboard/userAgreement user default data
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
        
    //MARK: Life Cycle
    @objc func didEnterBackground() {
        // Stop movement of long drink names when app enters background
        primary.subviews.forEach({$0.layer.removeAllAnimations()})
        primary.layer.removeAllAnimations()
        primary.layoutIfNeeded()
    }

    @objc func willEnterForeground() {
        // If the app has launched before
        let hasLaunched = UserDefaults.standard.bool(forKey: Strings.Key.hasLaunchedBefore)
        if hasLaunched {
            // Update tables to include saved drink data
            for id in Data.IDs {
                reloadTable(table: id, realculate: false)
            }
            // Check if the tables have data in them
            primary.scroll.checkIfEmpty()
            // Set the scroll view content size to fit tables after adjusting height to fit rows
            primary.scroll.updateContentSize()
            // Update the alculate header
            alculate()
        }
    }
    
    // MARK: TraitCollection (Dark Mode)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        // Either .unspecified, .light, or .dark
        let textColor: UIColor = (userInterfaceStyle == .dark) ? UI.Color.Font.standard : .black
        // If the user has not accepted agreement yet, proceed
        if !UserDefaults.standard.bool(forKey: Strings.Key.userHasAgreed) {
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
            alert.setValue(messageText, forKey: "attributedMessage")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // App background color is dark, whether in light or dark mode make status bar light.
        return .lightContent
    }
}

