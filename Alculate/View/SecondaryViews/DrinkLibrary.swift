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
    
    //MARK: Definitions
    // Delegates
    var delegate : DrinkLibraryDelegate!
    // Objects
    let header = UILabel()
    var table  = DrinkLibraryTable()
    
    //MARK: Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        clipsToBounds   = true
        backgroundColor = .clear
        headerSettings()
        addObjectsToView()
        constraints()
    }
    
    func headerSettings() {
        addSubview(header)
        header.backgroundColor          = backgroundColor
        header.font                     = UI.Font.DrinkLibrary.header
        header.textColor                = UI.Color.Font.standard
        header.textAlignment            = .left
        header.text                     = Constants.drinkLibraryHeader
        header.isUserInteractionEnabled = true
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
}
