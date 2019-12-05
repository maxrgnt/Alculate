//
//  UI_Color.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

//Color definitions
// The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
// Adjust a color it starts you with to match the RGB values above,
// lock it, hit space bar and watch the suggested matches autopopulate

import UIKit

extension UI {
    
    //MARK: Color
    struct Color {
        
        // Update these variables with new color variables
        static let darkestAccent = cello
        static let darkestAccentRGB = [61,75,96] // RGB for darkestAccent
        static let darkAccent = blackCoral
        static let darkAccentRGB = [79,98,114] // RGB for darkAccent
        static let lightAccent = cadetGrey
        static let fontColor = whiteSmoke
        
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
        static let cello = UIColor(displayP3Red: 61/255, green: 75/255, blue: 96/255, alpha: 1.0)
        // #f4f4f4
        static let whiteSmoke = UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
                
        struct Border {
            static let comparison = darkestAccent
            static let comparisonCell = darkAccent
        }
        
        struct Font {
            static let standard = fontColor
            static let beerHeader = standard
            static let liquorHeader = standard
            static let wineHeader = standard
            static let comparisonCell = standard
            static let comparisonTotal = darkestAccent
        }
        
        struct Background {
            static let drinkTypes = [beerHeader,liquorHeader,wineHeader]
            static let header = darkestAccent
            static let summary = darkestAccent
            static let comparison = darkestAccent
            static let comparisonHeader = darkestAccent
            static let beerHeader = beer
            static let liquorHeader = liquor
            static let wineHeader = wine
        }
        
        struct ViewController {
            static let background = darkAccent
        }
        
        struct Gradient {
            static let darkest = darkestAccent
            static let darkestRGB = darkestAccentRGB
            static let dark = darkAccent
            static let darkRGB = darkAccentRGB
            static let light = lightAccent
        }
        
        struct Header {
            static let background = darkestAccent
            static let font = Font.standard
        }
        
        struct Comparison {
            static let background = darkestAccent
            static let border = darkestAccent
        }
        
        struct Secondary {
            static let background = darkestAccent
        }
        
        struct TextEntry {
            static let background = darkestAccent
        }
        
        struct Menu {
            static let background = darkestAccent
        }
        
        struct Undo {
            static let background = begonia
        }
        
    }

    
}
