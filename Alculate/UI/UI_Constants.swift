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
    
    static let userAgreementTitle   = "User Agreement"
    static let userAgreementMessage = """
                                    \nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.
                                    """
    
    struct Key {
        static let userHasAgreed = "userAgreedToLegalAgreement"
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let keyboardMetricSaved = "keyboardMetricSaved"
        static let keyboardHeight = "keyboardHeight"
        static let keyboardAnimateDuration = "keyboardAnimateDuration"
        static let keyboardAnimateCurve = "keyboardAnimateCurve"
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
        static let secondaryHidden: CGFloat = 0.0
        static let secondaryVisible: CGFloat = -UI.Sizing.Secondary.height
        static let undoOffScreen: CGFloat = 0.0
        static let undoOnScreen: CGFloat = -UI.Sizing.Menu.height
        
    }
    
}
