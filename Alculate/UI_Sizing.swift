//
//  UI_Sizing.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

struct UI {
    
    // main size ratios
    static let headerRatio: CGFloat = 0.07
    static let topLineRatio: CGFloat = 0.1225
    static let tableViewRatio: CGFloat = (1-(headerRatio*2)-topLineRatio) // 0.84
    static let userInputRatio: CGFloat = 0.75 // 0.84
    
    struct Keyboard {
        static var duration: Double!
        static var curve: UInt!
    }
    
    //MARK: Sizing
    struct Sizing {
        // key screen dimensions
        static let bounds = UIScreen.main.bounds
        static let height = bounds.height - statusBar.height
        static let width = bounds.width
        static let keyWindow = UIApplication.shared.windows[0]
        static let statusBar = keyWindow.windowScene!.statusBarManager!.statusBarFrame
        static let objectPadding = statusBar.height/2
        static let widthObjectPadding = width-statusBar.height
        static var keyboard: CGFloat = height*0.3532863849765258 {
            didSet {
                TextEntry.top = -(keyboard+TextEntry.Input.height+TextEntry.Navigator.height)
                TextEntry.height = keyboard+TextEntry.Input.height+TextEntry.Navigator.height
                TextNavigator.bottom.constant = -keyboard
            }
        }
        
        struct Ratio {
            static let header: CGFloat = 0.07
            static let summary: CGFloat = 0.1225
            static let comparison: CGFloat = (1-header-summary-menu)
            static let menu: CGFloat = header
        }
        
        //MARK: Primary
        struct Primary {
            static let height = bounds.height
        }
        
        //MARK: StatusBar
        struct StatusBar {
            static let width = UI.Sizing.width
            static let height = statusBar.height
        }
        
        //MARK: Header
        struct Header {
            static let radii = width/10
            static let width = UI.Sizing.width
            static let height = Ratio.header*Sizing.height + StatusBar.height + Summary.height + radii*(2/3)
            static let heightMinimized = Ratio.header*Sizing.height + StatusBar.height + radii*(2/3)
            struct appName {
                static let width = Header.width
                static let height = Ratio.header*Sizing.height
            }
        }
        
        //MARK: Summary
        struct Summary {
            static let width = UI.Sizing.width/2 - padding - (padding * 0.5)
            static let xOffset = width/2 + (padding * 0.5)
            static let height = Ratio.summary*Sizing.height
            static let padding = objectPadding
            static let categoryHeight = height/6
            static let nameHeight = height/3
            static let statHeight = height/3
            static let statUnitHeight = height/6
        }
        
        //MARK: Comparison
        struct Comparison {
            static let padding = objectPadding
            static let radii = width/20
            static let border = padding/4
            static let separator = border/2
            struct Scroll {
                static let width = widthObjectPadding
                static let heightEmpty = bounds.height-Menu.height-UI.Sizing.Header.heightMinimized
                static let heightFull = bounds.height-Menu.height-UI.Sizing.Header.height
            }
            struct Container {
                static let height: CGFloat = Header.height
            }
            struct Empty {
                static let mainHeight = bounds.height
                static let containerHeight = padding*3 + Container.height*3
                static let headerHeight = UI.Sizing.Header.height
                static let menuHeight = UI.Sizing.Menu.height
                static let totalHeight = Total.height + padding
                static let height = mainHeight-containerHeight-headerHeight-menuHeight
            }
            struct Header {
                static let height = widthObjectPadding/8
                static let contentWidth = Scroll.width - padding*2
            }
            struct Row {
                static let height = Header.height - separator
                static let width = Comparison.Scroll.width
                static let statHeight = height*(2/3)
                static let unitHeight = height*(1/3)
                static let nameWidth = (width-padding*2)*(2/3)
                static let valueWidth = (width-padding*2)*(1/6)
                static let effectWidth = (width-padding*2)*(1/6)
                static let unitOffset = -height/6
            }
            struct Total {
                static let height = width/16
                static let width = Comparison.Scroll.width
                static let statHeight = height
                static let nameHeight = height
                static let nameWidth = (width-padding*2)*(1/2)
                static let spentWidth = (width-padding*2)*(1/3)
                static let shotsWidth = (width-padding*2)*(1/6)
                static let unitOffset = -statHeight/2
            }
        }
        
        //MARK: Menu
        struct Menu {
            static let height = Header.appName.height*1.25
            static let width = UI.Sizing.width
            static let radii = width/10
            static let buttonHeight = height*(2/3)
        }
        
        //MARK: Secondary
        struct Secondary {
            static let height = bounds.height
        }
        
        //MARK: DrinkLibrary
        struct DrinkLibrary {
            static let height = bounds.height
            static let width = UI.Sizing.width
            static let radii = width/20
            struct Header {
                static let height = DrinkLibrary.height - statusBar.height - Table.height
                static let width = widthObjectPadding
            }
            struct Table {
                static let height = Row.height*11
            }
            struct Row {
                static let height = UI.Sizing.Header.appName.height*1.2
                static let headerHeight = DrinkLibrary.Row.height*(2/3)
                static let stubHeight = DrinkLibrary.Row.height*(1/3)
                static let contentWidth = DrinkLibrary.width-DrinkLibrary.Header.height-objectPadding*(3/2)
            }
            struct Icon {
                static let diameter = Row.height * (1/2)
            }
        }
        
        //MARK: Undo
        struct Undo {
            static let height = Menu.height
            static let bounceBuffer = objectPadding
            static let radii = height/10
            static let cancelDiameter = height * (2/3)
            static let confirmHeight = height * (2/3)
            static let confirmWidth = widthObjectPadding-cancelDiameter
        }
        
        //MARK: TextEntry
        struct TextEntry {
            static var top = -(keyboard+Input.height)
            static let padding = objectPadding
            static let topPartial = -(keyboard+(2*Field.height)+Navigator.height+padding)
            static var height = Input.height + Navigator.height + keyboard
            static let border = padding/4
            static let bounceBuffer = padding
            static let radii = width/10
            static let gesture = top*(5/6)
            struct Input {
                static let height = (4*Field.height)+padding
                static let heightPartial = (2*Field.height)+padding
            }
            struct Field {
                static let height = Header.appName.height
                static let width = widthObjectPadding-Icon.diameter
                static let sizeWidth = width - Icon.diameter
            }
            struct Icon {
                static let diameter = ((width/3) - padding)*(2/3)*(2/3)
            }
            struct Navigator {
                static let height = Field.height
                static let width = widthObjectPadding
                static let buttonWidth = Icon.diameter
            }
        }
        
    }

}
