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
                textEntryTop = -(keyboard+textEntryInputsHeight+textNavigatorHeight)
                textEntryHeight = keyboard+textEntryInputsHeight+textNavigatorHeight
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
            static let comparison = widthObjectPadding
            static let comparisonHeader = comparison
            static let comparisonType = comparisonHeader-comparisonAdd-Padding.comparisonHeader
            static let comparisonAdd = Height.comparisonHeader
            static let comparisonTable = comparisonHeader-Padding.comparisonHeader
            static let comparisonRowName = comparisonTable*(3/5)
            static let comparisonRowValue = comparisonTable*(1/5)
            static let comparisonRowEffect = comparisonTable*(1/5)
        }
        
        struct Height {
            static let header = Ratio.header*height + statusBar.height + summary + Radii.header
            static let headerAppName = Ratio.header*height
            static let summary = Ratio.summary*height
            static let comparison = height/4
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
            static let comparison = Width.comparison/10
        }
        
        struct Border {
            static let comparison = Padding.comparison/4
            static let comparisonRow = comparison/3
        }
        
        // Header sizing
        static let headerHeight = height*headerRatio
        // Top line sizing
        static let topLineHeight = height*topLineRatio
        static let topLinePieceWidth = width/2
        static let topLineTop = -topLineHeight-subMenuHeight
        // user input sizing
        static let userInputHeight = height*(userInputRatio)
        static let userInputRadius = width/10
        static let inputTextHeight = height*(headerRatio)
        static var inputTop = -(keyboard+(inputTextHeight*2)+userInputRadius)
        
        //
        static let newComparisonHeight = headerHeight+objectPadding
        
        // Comparison Header
        static let comparisonHeaderTop = statusBar.height+headerHeight+topLineHeight
        static let comparisonIconDiameter = ((width/3)-(objectPadding))*(1/2)
        static let comparisonHeaderHeight = (width/3)*(2/3)
        static let comparisonHeaderWidth = width/3
        // Comparison Table
        static let comparisonTableWidth = width/3
        static let comparisonTableHeight = height-headerHeight-topLineHeight-subMenuHeight-newComparisonHeight
        static let comparisonTableTop = statusBar.height + headerHeight
        // Comparison Container
        static var containerConstraints = [(lead: 0.500*objectPadding, trail: -0.250*objectPadding),
                                           (lead: 0.375*objectPadding, trail: -0.375*objectPadding),
                                           (lead: 0.250*objectPadding, trail: -0.500*objectPadding)]
        static let containerBorder = comparisonTableWidth/50
        static let containerDiameter = (width-(objectPadding*2.25))/3//+containerBorder
        static let containerHeight = containerDiameter*(3/4)
        static let comparisonRowHeight = containerHeight + objectPadding/2
        static let containerRadius = containerDiameter/10
        static let containerDeleteSize = UI.Sizing.containerDiameter*0.92
        static let containerDeleteHeight = UI.Sizing.containerHeight*0.92
        // Comparison Remove
        static let comparisonRemoveDiameter = containerDiameter/4
        static let comparisonRemoveRadius = containerDiameter/8
        static let comparisonRemoveOffset = containerDiameter/12
        // Saved ABV
        static let savedABVheight = height
        static let savedABVtop = statusBar.height
        static let savedABVheaderHeight = savedABVheight-savedABVrowHeight*(12.5)
        static let savedABVtableHeight = savedABVrowHeight*(12.5) // savedABVheight-savedABVheaderHeight
        static let savedABVrowHeight = headerHeight
        static let savedABVmainWidth = width-headerHeight-objectPadding*(3/2)-savedABVdeleteDiameter
        static let savedABViconDiameter = UI.Sizing.savedABVrowHeight*(1/2)
        static let savedABVdeleteDiameter = savedABVrowHeight*(2/3)
        static let savedABVdeleteRadius = savedABVdeleteDiameter/2
        static let savedABVtopLineHeight = savedABVrowHeight*(2/3)
        static let savedABVsubLineHeight = savedABVrowHeight*(2/9)
        static let savedABVgestureThreshold = UI.Sizing.width/8
        // App Navigator
        static let subMenuHeight = (headerHeight*1.5)
        static let subMenuBounceBuffer = objectPadding
        static let subMenuConstraints: [CGFloat] = [0.5*objectPadding, 1.125*objectPadding, 1.75*objectPadding]
        // Text Entry
        static var textEntryHeight = textEntryInputsHeight+textNavigatorHeight+keyboard // height*(userInputRatio)
        static let textEntryBounceBuffer = objectPadding
        static let textEntryInputsHeight = (4*textEntryFieldHeight)+objectPadding
        static let textEntryInputsHeightPartial = (2*textEntryFieldHeight)+objectPadding
        static var textEntryTop = -(keyboard+textEntryInputsHeight)
        static let textEntryTopPartial = -(keyboard+(2*textEntryFieldHeight)+textNavigatorHeight+objectPadding)
        static let textEntryFieldHeight = headerHeight
        static let textEntryRadius = width/10
        static let textEntryIconDiameter = ((width/3)-(objectPadding))*(2/3)*(2/3)
        static let textNavigatorHeight = textEntryFieldHeight
        static let textNavigatorWidth = widthObjectPadding
        static let textNavigatorButtonWidth = textEntryIconDiameter
        static let textEntryFieldWidth = widthObjectPadding-textEntryIconDiameter
        static let textEntryFieldWidthForSize = textEntryFieldWidth-textEntryIconDiameter
        static let textEntryGestureThreshold = textEntryTop*(5/6)
        // Undo
        static let undoHeight = subMenuHeight
        static let undoBounceBuffer = objectPadding
        static let undoRadius = undoHeight/10
        static let undoCancelDiameter = subMenuHeight*(2/3)*(1/3)
        static let undoCancelRadius = undoCancelDiameter/2
        static let undoConfirmHeight = subMenuHeight*(2/3)*(1/3)
        static let undoConfirmWidth = widthObjectPadding-undoCancelDiameter
        
    }

    // fonts
    struct Font {
        struct Header {
            static let comparisonType = UIFont(name: "JosefinSans-SemiBold", size: Sizing.Height.comparisonHeader*(1/2))
            static let comparisonAdd = UIFont(name: "JosefinSans-SemiBold", size: Sizing.Height.comparisonHeader*(4/4))
        }
        struct Row {
            static let comparison = UIFont(name: "JosefinSans-Regular", size: Sizing.Height.comparisonHeader*(1/3))
            static let comparisonUnit = UIFont(name: "JosefinSans-Light", size: Sizing.Height.comparisonHeader*(1/4))
        }
        //static let normalFont: UIFont = UIFont.systemFont(ofSize: 30)
        static let headerFont = UIFont(name: "JosefinSans-Bold", size: 30)
        static let cellHeaderFont = UIFont(name: "JosefinSans-SemiBold", size: 18)
        static let topLineCategory = UIFont(name: "JosefinSans-SemiBold", size: 16)
        static let topLinePrimary = UIFont(name: "JosefinSans-SemiBold", size: 24)
        static let topLineSecondary = UIFont(name: "JosefinSans-SemiBold", size: 14)
        static let cellStubFont = UIFont(name: "JosefinSans-Regular", size: 18)
        static let cellStubFont2 = UIFont(name: "JosefinSans-Regular", size: 18)
        static let cellStubFont3 = UIFont(name: "JosefinSans-Light", size: 14)
    }
    
    // colors
    struct Color {
        // static let alculatePurple = UIColor(displayP3Red: 100/255, green: 87/255, blue: 166/255, alpha: 1.0)
        // #35295D
        static let purpleDarkest = UIColor(displayP3Red: 53/255, green: 41/255, blue: 93/255, alpha: 1.0)
        // #4B3F72
        static let purpleDarker = UIColor(displayP3Red: 75/255, green: 63/255, blue: 114/255, alpha: 1.0)
        // #6457A6
        static let purpleDark = UIColor(displayP3Red: 100/255, green: 87/255, blue: 166/255, alpha: 1.0)
        // #6457A6
        static let purpleLight = UIColor(displayP3Red: 100/255, green: 87/255, blue: 166/255, alpha: 1.0)
        // #907AD6
        static let purpleLighter = UIColor(displayP3Red: 144/255, green: 122/255, blue: 214/255, alpha: 1.0)
        
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
        
        static let beer = UIColor(displayP3Red: 91/255, green: 140/255, blue: 90/255, alpha: 1.0)
        static let liquor = UIColor(displayP3Red: 0/255, green: 110/255, blue: 144/255, alpha: 1.0)
        static let wine = UIColor(displayP3Red: 144/255, green: 78/255, blue: 85/255, alpha: 1.0)
        // static let alcoholTypes = [beer, liquor, wine, bgLite]
        // static let lavenderMist = UIColor(displayP3Red: 236/255, green: 229/255, blue: 240/255, alpha: 1.0) // lavender mist
        
        // beer =   (red: 91/255, green: 140/255, blue: 90/255)
        // liquor = (red: 0/255, green: 110/255, blue: 144/255)
        // wine =   (red: 144/255, green: 78/255, blue: 85/255)
        
        static let bgDarkest = darkGunmetal
        static let bgDarker = outerSpace
        static let bgDarkerRGB = [64,78,92]
        static let bgDark = blackCoral
        static let bgDarkRGB = [79,98,114]
        static let bgLite = cadetGrey
        static let value = malachiteGreen
        static let effect = tuftsBlue
        static let best = mustard
        static let fontWhite = honeydew
        static let undo = begonia
        
        struct Border {
            static let comparison = darkGunmetal
            static let comparisonCell = darkGunmetal
        }
        
        struct Background {
            static let summary = darkGunmetal
            static let comparison = blackCoral
            static let comparisonHeader = outerSpace
        }
        
    }
    
    static func printUI() {
        //Color definitions
        // The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
        // Adjust a color it starts you with to match the RGB values above,
        // lock it, hit space bar and watch the suggested matches autopopulate
    }

}
