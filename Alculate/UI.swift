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
    static let subLineRatio: CGFloat = 0.105
    static let tableViewRatio: CGFloat = (1-(headerRatio*2)-topLineRatio-subLineRatio) // 0.84
    static let userInputRatio: CGFloat = 0.75 // 0.84
    
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
                inputTop = -(keyboard+(inputTextHeight*2)+userInputRadius)
                inputBottom = inputTop-(inputTextHeight*3)
                InputNavigation.bottom.constant = -keyboard
            }
        }
        // Header sizing
        static let headerHeight = height*headerRatio
        // Top line sizing
        static let topLineHeight = height*topLineRatio
        static let topLineTop = statusBar.height + headerHeight
        // Sub line sizing
        static let subLineHeight = height*subLineRatio
        static let subLineTop = topLineTop + topLineHeight
        // App nav sizing
        static let appNavigationHeight = (headerHeight*2)+objectPadding+statusBar.height
        static let appNavigationGradient = headerHeight/appNavigationHeight
        // Table view sizing
        static let tableViewHeight = height*(tableViewRatio)-statusBar.height
        static let tableViewWidth = width/3
        static let tableViewTop = statusBar.height+headerHeight+topLineHeight+subLineHeight
        // user input sizing
        static let userInputHeight = height*(userInputRatio)
        static let userInputRadius = width/10
        static let inputTextHeight = height*(headerRatio)
        static var inputTop = -(keyboard+(inputTextHeight*2)+userInputRadius)
        static var inputBottom = inputTop-(inputTextHeight*3)
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
//        static let mainBlue = UIColor(displayP3Red: 30/255, green: 80/255, blue: 205/255, alpha: 1.0)
//        static let darkerBlue = UIColor(displayP3Red: 0/255, green: 58/255, blue: 177/255, alpha: 1.0)
//        static let darkestBlue = UIColor(displayP3Red: 16/255, green: 29/255, blue: 66/255, alpha: 1.0)
//        static let coinWhite = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        static let removeContactText = UIColor(displayP3Red: 225/255, green: 111/255, blue: 124/255, alpha: 1.0)
//        static let red = UIColor(displayP3Red: 197/255, green: 40/255, blue: 61/255, alpha: 1.0)
        static let softWhite = UIColor(displayP3Red: 189/255, green: 213/255, blue: 234/255, alpha: 1.0)
//        static let green = UIColor(displayP3Red: 124/255, green: 255/255, blue: 203/255, alpha: 1.0)
        static let alcoholTypes = [UIColor.lightGray, UIColor.gray, UIColor.darkGray]
    }
    
    static func printUI() {
        //Color definitions
        // The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
        // Adjust a color it starts you with to match the RGB values above,
        // lock it, hit space bar and watch the suggested matches autopopulate
    }

}
