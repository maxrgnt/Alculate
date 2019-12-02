//
//  DrinkLibrary.swift
//  Alculate
//
//  Created by Max Sergent on 12/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol DrinkLibraryDelegate {
    func animateComparisonLabels()
}

class DrinkLibrary: UIView {
    
    //MARK: - Definitions
    // Delegates
    var delegate : DrinkLibraryDelegate!
    // Objects
    var gradient = CAGradientLayer()
    var gradient2 = CAGradientLayer()
    let header = UILabel()
    var table = DrinkLibraryTable()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = .clear
        
        headerSettings()
        
        addObjectsToView()
        constraints()
    }
    
    func addObjectsToView() {
        addSubview(header)
        addSubview(table)
        table.setup()
    }
    
    func constraints() {
        headerConstraints()
        tableConstraints()
    }
    
    func headerSettings() {
        addSubview(header)
        header.backgroundColor = backgroundColor
        header.font = UI.Font.headerFont
        header.textColor = UI.Color.fontWhite
        header.textAlignment = .left
        header.text = "Drink Library"
    }
    
    
    // MARK: - Gradient Settings
    func buildGradient() {
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: UI.Sizing.savedABVheaderHeight)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.savedABVtableHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.bgDarker.withAlphaComponent(1.0).cgColor,
                           UI.Color.bgLite.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0.0,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
        
        // Set origin of gradient (top left of screen)
        let gradientOrigin2 = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize2 = CGSize(width: UI.Sizing.width, height: UI.Sizing.savedABVheaderHeight)
        gradient2.frame = CGRect(origin: gradientOrigin2, size: gradientSize2)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient2.colors = [UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor,
                            UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor,
                           UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient2.locations = [0.0,0.1,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient2, at: 0)
    }
    
    
    //MARK: - Animations

    
}
