//
//  UI_Font.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

extension UI {

    //MARK: Font
    struct Font {
        
        struct Header {
            static let appName = UIFont(name: "RobotoSlab-Bold", size: 30)
        }
        struct Comparison {
            static let empty = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Comparison.Header.height*(1/2))
            static let type = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Comparison.Header.height*(1/2))
            static let add = UIFont(name: "RobotoSlab-Regular", size: Sizing.Comparison.Header.height*(3/4))
            static let row = UIFont(name: "RobotoSlab-Regular", size: Sizing.Comparison.Header.height*(1/3))
            static let rowUnit = UIFont(name: "RobotoSlab-Light", size: Sizing.Comparison.Header.height*(1/4))
            static let total = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Comparison.Header.height*(1/2))
            static let totalStat = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Comparison.Header.height*(1/3))
            static let totalUnit = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Comparison.Header.height*(1/4))
        }
        struct Summary {
            static let category = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Comparison.Header.height*(1/3))
            static let name = Comparison.type
            static let stat = Comparison.type
            static let statUnit = Comparison.row
        }
        
        struct TextEntry {
            static let field = UIFont(name: "RobotoSlab-SemiBold", size: 18)
            static let navigator = UIFont(name: "RobotoSlab-SemiBold", size: 18)
        }
        
        struct DrinkLibrary {
            static let header = UIFont(name: "RobotoSlab-Bold", size: 30)
            static let rowHeader = UIFont(name: "RobotoSlab-SemiBold", size: 18)
            static let rowStub = UIFont(name: "RobotoSlab-Regular", size: 16)
        }

        struct Menu {
            static let button = UIFont(name: "RobotoSlab-SemiBold", size: 18)
        }
        
        struct Undo {
            static let button = UIFont(name: "RobotoSlab-SemiBold", size: 18)
        }

    }
    
}
