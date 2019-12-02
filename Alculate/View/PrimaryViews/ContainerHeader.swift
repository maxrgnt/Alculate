//
//  ContainerHeader.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class ContainerHeader: UIView {
    
    //MARK: - Definitions
    // Objects
    let type = UIButton()
    let add = UIButton()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup(forType id: String) {
        
        var bgColor = (id == Data.beerListID) ? UI.Color.Background.beerHeader : nil
        bgColor = (id == Data.liquorListID) ? UI.Color.Background.liquorHeader : bgColor
        bgColor = (id == Data.wineListID) ? UI.Color.Background.wineHeader : bgColor
        backgroundColor = bgColor
        
        typeSettings(forType: id)
        addSettings(forType: id)
        
        addObjectsToView()
        
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        addSubview(type)
        addSubview(add)
    }

    //MARK: - Constraints
    func constraints() {
        typeConstraints()
        addConstraints()
    }
    
    //MARK: - Settings
    func typeSettings(forType id: String) {
        var typeFromID = (id == Data.beerListID) ? "Beer" : nil
        typeFromID = (id == Data.liquorListID) ? "Liquor" : typeFromID
        typeFromID = (id == Data.wineListID) ? "Wine" : typeFromID
        
        type.contentVerticalAlignment = .bottom
        type.contentHorizontalAlignment = .left
        type.setTitle(typeFromID, for: .normal)
        type.titleLabel?.font = UI.Font.Comparison.type!
        type.setTitleColor(UI.Color.fontWhite, for: .normal)
    }
    
    func addSettings(forType id: String) {
        var tagFromID = (id == Data.beerListID) ? 20 : nil
        tagFromID = (id == Data.liquorListID) ? 21 : tagFromID
        tagFromID = (id == Data.wineListID) ? 22 : tagFromID
        
        add.tag = tagFromID!
        add.contentVerticalAlignment = .center
        add.contentHorizontalAlignment = .right
        add.setTitle("+", for: .normal)
        add.titleLabel?.font = UI.Font.Comparison.add!
        add.setTitleColor(UI.Color.fontWhite, for: .normal)
    }
    
    //MARK: - Functions

    
}
