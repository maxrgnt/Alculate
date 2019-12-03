//
//  Identifiers.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation

struct Strings {
    
    static let userAgreementTitle   = "User Agreement"
    static let userAgreementMessage = """
                                    \nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.
                                    """
    
    struct Key {
        static let userHasAgreed = "userAgreedToLegalAgreement"
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }
    
}
