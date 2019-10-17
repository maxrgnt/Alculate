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
        // Header sizing
        static let headerHeight = height*headerRatio
        // Top line sizing
        static let topLineHeight = height*topLineRatio
        static let topLinePieceWidth = width/2
        static let topLineTop = statusBar.height + headerHeight
        // user input sizing
        static let userInputHeight = height*(userInputRatio)
        static let userInputRadius = width/10
        static let inputTextHeight = height*(headerRatio)
        static var inputTop = -(keyboard+(inputTextHeight*2)+userInputRadius)
        
        // Comparison Header
        static let comparisonHeaderTop = statusBar.height+headerHeight+topLineHeight
        static let comparisonIconDiameter = ((width/3)-(objectPadding))*(2/3)
        static let comparisonHeaderHeight = (width/3)*(2/3)
        static let comparisonHeaderWidth = width/3
        // Comparison Table
        static let comparisonTableWidth = width/3
        static let comparisonTableHeight = height-headerHeight-topLineHeight-comparisonHeaderHeight
        static let comparisonTableTop = comparisonHeaderTop + comparisonHeaderHeight
        // Comparison Container
        static var containerConstraints = [(lead: 0.500*objectPadding, trail: -0.250*objectPadding),
                                           (lead: 0.375*objectPadding, trail: -0.375*objectPadding),
                                           (lead: 0.250*objectPadding, trail: -0.500*objectPadding)]
        static let containerBorder = comparisonTableWidth/50
        static let containerDiameter = (width-(objectPadding*2.25))/3//+containerBorder
        static let comparisonRowHeight = containerDiameter + objectPadding/2
        static let containerRadius = containerDiameter/10
        static let containerDeleteSize = UI.Sizing.containerDiameter*0.92
        // Comparison Remove
        static let comparisonRemoveDiameter = containerDiameter/4
        static let comparisonRemoveRadius = containerDiameter/8
        static let comparisonRemoveOffset = containerDiameter/12
        // Saved ABV
        static let savedABVheight = height-(headerHeight)
        static let savedABVtop = statusBar.height+headerHeight
        static let savedABVheaderHeight = savedABVrowHeight*(3/2)
        static let savedABVtableHeight = bounds.height-savedABVtop
        static let savedABVrowHeight = headerHeight
        static let savedABVmainWidth = width-headerHeight-objectPadding*(3/2)-savedABVdeleteDiameter
        static let savedABViconDiameter = UI.Sizing.savedABVrowHeight*(2/3)
        static let savedABVdeleteDiameter = savedABVrowHeight/2
        static let savedABVdeleteRadius = savedABVdeleteDiameter/2
        static let savedABVtopLineHeight = savedABVrowHeight*(2/3)
        static let savedABVsubLineHeight = savedABVrowHeight*(2/9)
        static let savedABVgestureThreshold = UI.Sizing.width/8
        // App Navigator
        static let appNavigatorHeight = (headerHeight*2.5)
        static let appNavigatorBounceBuffer = objectPadding
        static let appNavigatorConstraints: [CGFloat] = [0.5*objectPadding, 1.125*objectPadding, 1.75*objectPadding]
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
        static let undoHeight = appNavigatorHeight
        static let undoBounceBuffer = objectPadding
        static let undoRadius = undoHeight/10
        static let undoCancelDiameter = appNavigatorHeight*(2/3)*(1/3)
        static let undoCancelRadius = undoCancelDiameter/2
        static let undoConfirmHeight = appNavigatorHeight*(2/3)*(1/3)
        static let undoConfirmWidth = widthObjectPadding-undoCancelDiameter
        
    }

    // fonts
    struct Font {
        //static let normalFont: UIFont = UIFont.systemFont(ofSize: 30)
        static let headerFont = UIFont.systemFont(ofSize: 30)
        static let cellHeaderFont = UIFont.systemFont(ofSize: 18)
        static let cellStubFont = UIFont.systemFont(ofSize: 14)
    }
    
    // colors
    struct Color {
//        static let alculatePurple = UIColor(displayP3Red: 100/255, green: 87/255, blue: 166/255, alpha: 1.0)
//        static let beer = UIColor(displayP3Red: 255/255, green: 180/255, blue: 0/255, alpha: 1.0)
//        static let liquor = UIColor(displayP3Red: 38/255, green: 196/255, blue: 133/255, alpha: 1.0)
//        static let wine = UIColor(displayP3Red: 232/255, green: 63/255, blue: 111/255, alpha: 1.0)
        static let alculatePurpleDark = UIColor(displayP3Red: 75/255, green: 63/255, blue: 114/255, alpha: 1.0)
        static let alculatePurpleLite = UIColor(displayP3Red: 100/255, green: 87/255, blue: 166/255, alpha: 1.0)
        static let beer = UIColor(displayP3Red: 91/255, green: 140/255, blue: 90/255, alpha: 1.0)
        static let liquor = UIColor(displayP3Red: 0/255, green: 110/255, blue: 144/255, alpha: 1.0)
        static let wine = UIColor(displayP3Red: 144/255, green: 78/255, blue: 85/255, alpha: 1.0)
        static let softWhite = UIColor(displayP3Red: 236/255, green: 229/255, blue: 240/255, alpha: 1.0) // lavender mist
        //static let softWhite = UIColor(displayP3Red: 230/255, green: 232/255, blue: 230/255, alpha: 1.0) // platinum
        static let alcoholTypes = [beer, liquor, wine, alculatePurpleLite]
    }
    
    static func printUI() {
        //Color definitions
        // The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
        // Adjust a color it starts you with to match the RGB values above,
        // lock it, hit space bar and watch the suggested matches autopopulate
    }

}
