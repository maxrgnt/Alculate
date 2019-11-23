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
            static let summaryCell = width/2 - Padding.summary/2
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
            static let headerCollection = Ratio.header*height + statusBar.height + summary + Radii.header
            static let header = Ratio.header*height + summary + Radii.header
            static let headerMinimized = UI.Sizing.Height.headerAppName + UI.Sizing.Radii.header
            static let headerAppName = Ratio.header*height
            static let summary = Ratio.summary*height
            static let summaryCategory = summary/6
            static let summaryName = summary/3
            static let summaryStat = summary/3
            static let summaryStatUnit = summary/6
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
        static let subMenuHeight = (headerHeight*1.25)
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
        struct Comparison {
//            static let type = UIFont(name: "JosefinSans-SemiBold", size: Sizing.Height.comparisonHeader*(1/2))
//            static let add = UIFont(name: "JosefinSans-SemiBold", size: Sizing.Height.comparisonHeader*(4/4))
//            static let row = UIFont(name: "JosefinSans-Regular", size: Sizing.Height.comparisonHeader*(1/3))
//            static let rowUnit = UIFont(name: "JosefinSans-Light", size: Sizing.Height.comparisonHeader*(1/4))
            static let type = UIFont(name: "RobotoSlab-SemiBold", size: Sizing.Height.comparisonHeader*(1/2))
            static let add = UIFont(name: "RobotoSlab-Regular", size: Sizing.Height.comparisonHeader*(3/4))
            static let row = UIFont(name: "RobotoSlab-Regular", size: Sizing.Height.comparisonHeader*(1/3))
            static let rowUnit = UIFont(name: "RobotoSlab-Light", size: Sizing.Height.comparisonHeader*(1/4))
        }
        struct Summary {
            static let category = Comparison.row
            static let name = Comparison.type
            static let stat = Comparison.type
            static let statUnit = Comparison.row
        }
        
//        static let headerFont = UIFont(name: "JosefinSans-Bold", size: 30)
//        static let cellHeaderFont = UIFont(name: "JosefinSans-SemiBold", size: 18)
//        static let topLineCategory = UIFont(name: "JosefinSans-SemiBold", size: 16)
//        static let topLinePrimary = UIFont(name: "JosefinSans-SemiBold", size: 24)
//        static let topLineSecondary = UIFont(name: "JosefinSans-SemiBold", size: 14)
//        static let cellStubFont = UIFont(name: "JosefinSans-Regular", size: 18)
//        static let cellStubFont2 = UIFont(name: "JosefinSans-Regular", size: 18)
//        static let cellStubFont3 = UIFont(name: "JosefinSans-Light", size: 14)
        
        static let headerFont = UIFont(name: "RobotoSlab-Bold", size: 30)
        static let cellHeaderFont = UIFont(name: "RobotoSlab-SemiBold", size: 18)
        static let topLineCategory = UIFont(name: "RobotoSlab-SemiBold", size: 16)
        static let topLinePrimary = UIFont(name: "RobotoSlab-SemiBold", size: 24)
        static let topLineSecondary = UIFont(name: "RobotoSlab-SemiBold", size: 14)
        static let cellStubFont = UIFont(name: "RobotoSlab-Regular", size: 18)
        static let cellStubFont2 = UIFont(name: "RobotoSlab-Regular", size: 18)
        static let cellStubFont3 = UIFont(name: "RobotoSlab-Light", size: 14)
    }
    
    // colors
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
        // #f5d327
        static let beer = UIColor(displayP3Red: 245/255, green: 211/255, blue: 39/255, alpha: 1.0)
        // #dc8100
        static let liquor = UIColor(displayP3Red: 220/255, green: 129/255, blue: 0/255, alpha: 1.0)
        // #d81e1e
        static let wine = UIColor(displayP3Red: 216/255, green: 30/255, blue: 30/255, alpha: 1.0)
        // #A682FF
        static let lavender = UIColor(displayP3Red: 166/255, green: 130/255, blue: 255/255, alpha: 1.0)
        // #7880B5
        static let glaucous = UIColor(displayP3Red: 120/255, green: 128/255, blue: 181/255, alpha: 1.0)
        // #54428E
        static let violet = UIColor(displayP3Red: 84/255, green: 66/255, blue: 142/255, alpha: 1.0)
                
        static let bgDarkest = violet
        static let bgDarker = lavender
        static let bgDarkerRGB = [84,66,142]
        static let bgDark = glaucous
        static let bgDarkRGB = [166,130,255]
        static let bgLite = cadetGrey
        static let value = malachiteGreen
        static let effect = tuftsBlue
        static let best = mustard
        static let fontWhite = honeydew
        static let undo = begonia
        
        struct Border {
            static let comparison = bgDarkest
            static let comparisonCell = bgDarkest
        }
        
        struct Font {
            static let beerHeader = beer
            static let liquorHeader = liquor
            static let wineHeader = wine
        }
        
        struct Background {
            static let header = bgDarkest
            static let summary = bgDarkest
            static let comparison = bgDarker
            static let comparisonHeader = bgDarkest
            static let beerHeader = bgDarkest
            static let liquorHeader = bgDarkest
            static let wineHeader = bgDarkest
        }
        
    }
    
    static func printUI() {
        //Color definitions
        // The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
        // Adjust a color it starts you with to match the RGB values above,
        // lock it, hit space bar and watch the suggested matches autopopulate
    }

}
