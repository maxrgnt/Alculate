//
//  UI.swift
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
        
        struct Width {
            static let header = UI.Sizing.width
            static let summaryCell = width/2 - Padding.summary/2
            static let comparison = widthObjectPadding
            static let comparisonHeader = comparison
            static let comparisonType = comparisonHeader-comparisonAdd-Padding.comparisonHeader-Padding.comparisonHeader
            static let comparisonAdd = Height.comparisonHeader
            static let comparisonTable = comparisonHeader-Padding.comparisonHeader
            static let comparisonRowName = comparisonTable*(2/3) - Padding.comparisonHeader
            static let comparisonRowValue = comparisonTable*(1/6)
            static let comparisonRowEffect = comparisonTable*(1/6)
        }
        
        struct Height {
            static let headerCollection = Ratio.header*height + statusBar.height + summary + Radii.header
            static let header = Ratio.header*height + summary + Radii.header
            static let headerMinimized = UI.Sizing.Height.headerAppName + UI.Sizing.Radii.header
            static let headerAppName = Ratio.header*height
            static let summary = Ratio.summary*height
            static let summaryCategory = summary/6
            static let summaryName = summary/3
            static let summaryStat = summary/3
            static let summaryStatUnit = summary/6
            static let comparisonCollectionEmpty = height-Menu.height-headerMinimized
            static let comparisonCollectionFull = height-Menu.height-header
            static let comparison = comparisonRow
            static let comparisonHeader = Width.comparison/8
            static let comparisonRow = comparisonRowStat+comparisonRowUnit
            static let comparisonRowStat = comparisonHeader*(2/3)
            static let comparisonRowUnit = comparisonHeader*(1/3)
        }
        
        struct Padding {
            static let summary = objectPadding
            static let comparison = objectPadding
            static let comparisonHeader = Radii.comparison
        }
        
        struct Radii {
            static let header = Width.header/10
            static let comparison = Width.comparison/20
//            static let comparisonEmpty = Width.comparison/20
        }
        
        struct Border {
            static let comparison = Padding.comparison/4
            static let comparisonRow = comparison/3
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
            static let width = UI.Sizing.width
            static let height = Ratio.header*Sizing.height + StatusBar.height + Summary.height + Radii.header/2
            static let heightMinimized = Ratio.header*Sizing.height + StatusBar.height + Radii.header/2
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
                static let height = Height.comparisonRow
            }
            struct Empty {
                static let height = UI.Sizing.height-UI.Sizing.Menu.height-UI.Sizing.Header.height - (padding)*3 - Container.height*3
            }
            struct Header {
                static let height = Width.comparison/8
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
                static let nameWidth = (width-padding*2)*(2/3)
                static let spentWidth = (width-padding*2)*(1/6)
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
            static let topPartial = -(keyboard+(2*Field.height)+Navigator.height+objectPadding)
            static var height = Input.height + Navigator.height + keyboard
            static let bounceBuffer = objectPadding
            static let radii = width/10
            static let gesture = top*(5/6)
            struct Input {
                static let height = (4*Field.height)+objectPadding
                static let heightPartial = (2*Field.height)+objectPadding
            }
            struct Field {
                static let height = Header.appName.height
                static let width = widthObjectPadding-Icon.diameter
                static let sizeWidth = width - Icon.diameter
            }
            struct Icon {
                static let diameter = ((width/3) - objectPadding)*(2/3)*(2/3)
            }
            struct Navigator {
                static let height = Field.height
                static let width = widthObjectPadding
                static let buttonWidth = Icon.diameter
            }
        }
        
    }

    //MARK: Font
    struct Font {
        
        struct Header {
            static let appName = UIFont(name: "RobotoSlab-Bold", size: 30)
        }
        struct Comparison {
            static let empty = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/2))
            static let type = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/2))
            static let add = UIFont(name: "RobotoSlab-Regular", size: Sizing.Height.comparisonHeader*(3/4))
            static let row = UIFont(name: "RobotoSlab-Regular", size: Sizing.Height.comparisonHeader*(1/3))
            static let rowUnit = UIFont(name: "RobotoSlab-Light", size: Sizing.Height.comparisonHeader*(1/4))
            static let total = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/2))
            static let totalStat = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/3))
            static let totalUnit = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/4))
        }
        struct Summary {
            static let category = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/3))
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
    
    //MARK: Color
    struct Color {
        // #0D1F2D
        static let darkGunmetal = UIColor(displayP3Red: 13/255, green: 31/255, blue: 45/255, alpha: 1.0)
        // #404E5C
        static let outerSpace = UIColor(displayP3Red: 64/255, green: 78/255, blue: 92/255, alpha: 1.0)
        // #4F6272
        static let blackCoral = UIColor(displayP3Red: 79/255, green: 98/255, blue: 114/255, alpha: 1.0)
        // #9FA2B2
        static let cadetGrey = UIColor(displayP3Red: 159/255, green: 162/255, blue: 178/255, alpha: 1.0)
        // #61E786
        static let malachiteGreen = UIColor(displayP3Red: 97/255, green: 231/255, blue: 134/255, alpha: 1.0)
        // #3F88C5
        static let tuftsBlue = UIColor(displayP3Red: 63/255, green: 136/255, blue: 197/255, alpha: 1.0)
        // #EDFFEC
        static let honeydew = UIColor(displayP3Red: 237/255, green: 255/255, blue: 236/255, alpha: 1.0)
        // #FFC857
        static let mustard = UIColor(displayP3Red: 255/255, green: 200/255, blue: 87/255, alpha: 1.0)
        // #F56476
        static let begonia = UIColor(displayP3Red: 245/255, green: 100/255, blue: 118/255, alpha: 1.0)
        // #F2A359
        static let beer = UIColor(displayP3Red: 200/255, green: 154/255, blue: 76/255, alpha: 1.0)
        // #FE5F55
        static let liquor = UIColor(displayP3Red: 200/255, green: 122/255, blue: 76/255, alpha: 1.0)
        // #BC475C
        static let wine = UIColor(displayP3Red: 188/255, green: 71/255, blue: 92/255, alpha: 1.0)
        // #A682FF
        static let lavender = UIColor(displayP3Red: 166/255, green: 130/255, blue: 255/255, alpha: 1.0)
        // #7880B5
        static let glaucous = UIColor(displayP3Red: 120/255, green: 128/255, blue: 181/255, alpha: 1.0)
        // #54428E
        static let violet = UIColor(displayP3Red: 84/255, green: 66/255, blue: 142/255, alpha: 1.0)
        // #92C9B1
        static let etonBlue = UIColor(displayP3Red: 146/255, green: 201/255, blue: 177/255, alpha: 1.0)
        // #3F7C50
        static let amazon = UIColor(displayP3Red: 63/255, green: 124/255, blue: 80/255, alpha: 1.0)
        // #7492ab
        static let blueBG = UIColor(displayP3Red: 116/255, green: 146/255, blue: 171/255, alpha: 1.0)
        // #dfdfe0
        static let grayBG = UIColor(displayP3Red: 223/255, green: 223/255, blue: 224/255, alpha: 1.0)
        // #C9DBBA
        static let paleSilver = UIColor(displayP3Red: 201/255, green: 219/255, blue: 186/255, alpha: 1.0)
        // #3d4b60
        static let bleh = UIColor(displayP3Red: 61/255, green: 75/255, blue: 96/255, alpha: 1.0)
        // #f4f4f4
        static let bleh2 = UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        
        static let bgDarkest = bleh
        static let bgDarker = blackCoral
        static let bgDarkerRGB = [61,75,96] //[63,124,80]
        static let bgDark = glaucous
        static let bgDarkRGB = [79,98,114] //[146,201,177]
        static let bgLite = cadetGrey
        
        struct Border {
            static let comparison = bgDarkest
            static let comparisonCell = bgDarker
        }
        
        struct Font {
            static let standard = bleh2
            static let beerHeader = standard
            static let liquorHeader = standard
            static let wineHeader = standard
            static let comparisonCell = standard
            static let comparisonTotal = bgDarkest
        }
        
        struct Background {
            static let header = bgDarkest
            static let summary = bgDarkest
            static let comparison = bgDarkest
            static let comparisonHeader = bgDarkest
            static let beerHeader = beer
            static let liquorHeader = liquor
            static let wineHeader = wine
        }
        
        struct Header {
            static let background = bgDarkest
            static let font = Font.standard
        }
        
        struct Comparison {
            static let background = bgDarkest
            static let border = bgDarkest
        }
        
        struct Secondary {
            static let background = bgDarkest
        }
        
        struct Undo {
            static let background = begonia
        }
        
    }
    
    static func printUI() {
        //Color definitions
        // The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
        // Adjust a color it starts you with to match the RGB values above,
        // lock it, hit space bar and watch the suggested matches autopopulate
    }

}
