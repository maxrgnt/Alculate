//
//  SecondaryView.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol SecondaryDelegate {
    func animateSubMenu(by: CGFloat, reset: Bool)
    func animateComparisonLabels()
}

class SecondaryView: UIView {
    
    //MARK: - Definitions
    // Delegates
    var delegate : SecondaryDelegate!
    // Objects
    let drinkLibrary = DrinkLibrary()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        print("init secondary")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.DrinkLibrary.radii)
        
        addObjectsToView()
        constraints()
    }
    
    func addObjectsToView() {
        addSubview(drinkLibrary)
        drinkLibrary.setup()
    }
    
    func constraints() {
        drinkLibraryConstraints()
    }
        
}
