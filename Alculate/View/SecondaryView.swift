//
//  SecondaryView.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol SecondaryDelegate {
    func animateComparisonLabels()
}

class SecondaryView: UIView {
    
    //MARK: Definitions
    // Delegates
    var delegate : SecondaryDelegate!
    // Objects
    let drinkLibrary = DrinkLibrary()
    
    //MARK: Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = UI.Color.Secondary.background
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.DrinkLibrary.radii)
        addObjectsToView()
        constraints()
    }
    
    func addObjectsToView() {
        addSubview(drinkLibrary)
        drinkLibrary.setup()
    }
    
    //MARK: Constraints
    func constraints() {
        drinkLibraryConstraints()
    }
    
}
