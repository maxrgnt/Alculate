//
//  Constants.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let menuButton = "Show Drink Library"
    static let valueUnit = "per shot"
    static let effectUnit = "shots"
    static let drinkLibraryHeader = "Drink Library"
    
    struct UserAgreement {
        static let title = "User Agreement"
        static let message = """
                             \nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.
                             """
        static let action = "Agree"
    }
    
    struct Header {
        static let appName = "Alculate"
        static let valueCategory = "Highest Value"
        static let valueUnit = "per shot"
        static let effectCategory = "Most Effective"
        static let effectUnit = "shots"
    }
    
    struct Scroll {
        static let empty = "Add a drink above!"
    }
    
    struct Total {
        static let main = "Total:"
        static let spentUnit = "spent"
        static let shotUnit = "shots"
    }
    
    struct Container {
        static let add = "+"
        static let beerHeader = "Beer"
        static let liquorHeader = "Liquor"
        static let wineHeader = "Wine"
    }
    
    struct TextEntry {
        static let titles = ["begin typing a name..","abv","size","oz","ml","price"]
        static let defaults = ["begin typing a name..","abv","size","price"]
        static let defaultSizeUnit = "oz"
        static let otherSizeUnit = "ml"
        static let navigators = ["back","next","done"]
    }
    
    struct Undo {
        static let confirm = "Undo"
        static let cancel = "X"
    }
    
    struct Key {
        static let userHasAgreed = "userAgreedToLegalAgreement"
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let keyboardMetricSaved = "keyboardMetricSaved"
        static let keyboardHeight = "keyboardHeight"
        static let keyboardAnimateDuration = "keyboardAnimateDuration"
        static let keyboardAnimateCurve = "keyboardAnimateCurve"
        static let attributedMessage = "attributedMessage"
    }
    
    struct CellIdentifiers {
        static let drinkLibraryCell = "DrinkLibraryCell"
        static let containerCell = "ContainerCell"
    }
    
    struct MoveTo {
        static let hidden = "hidden"
        static let visible = "visible"
    }
    
    struct Animate {
        static let moving = "moving"
        static let still = "still"
    }
    
    struct Constraint {
        static let dismissSecondary: CGFloat = 0.7
        static let secondaryHidden: CGFloat = 0.0
        static let secondaryVisible: CGFloat = -UI.Sizing.Secondary.height
        static let undoOffScreen: CGFloat = 0.0
        static let undoOnScreen: CGFloat = -UI.Sizing.Menu.height
        
    }
    
}
