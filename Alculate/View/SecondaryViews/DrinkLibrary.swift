//
//  DrinkLibrary.swift
//  Alculate
//
//  Created by Max Sergent on 12/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol DrinkLibraryDelegate {
    func animateSubMenu(by: CGFloat, reset: Bool)
    func animateComparisonLabels()
}

class DrinkLibrary: UIView {
    
    //MARK: - Definitions
    // Delegates
    var delegate : DrinkLibraryDelegate!
    // Constraints
    var headerTop: NSLayoutConstraint!
    // Objects
    var gradient = CAGradientLayer()
    var gradient2 = CAGradientLayer()
    let header = UILabel()
    var table = DrinkLibraryTable()
    
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
        backgroundColor = .green
        
        headerSettings()
        
        addObjectsToView()
        constraints()
    }
    
    func addObjectsToView() {
        addSubview(header)
        addSubview(table)
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
        
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        header.addGestureRecognizer(pan)
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
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        table.isMoving = true
        table.reloadSectionIndexTitles()
        // Allow movement of contact card back/forth when not fully visible
        headerTop.constant += translation.y
        // If contact card is fully visible, don't allow movement further left
        headerTop.constant = headerTop.constant < UI.Sizing.savedABVtop ? UI.Sizing.savedABVtop : headerTop.constant
        let percent = headerTop.constant/UI.Sizing.height >= 1 ? 1 : headerTop.constant/UI.Sizing.height
        self.delegate.animateSubMenu(by: percent, reset: false)
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            table.isMoving = false
            table.reloadSectionIndexTitles()
            // Auto-scroll left (in frame) if false, Auto-scroll right (out of frame) if true
            let constant = (headerTop.constant/UI.Sizing.height > 0.4) ? UI.Sizing.height : UI.Sizing.savedABVtop
            let percent: CGFloat = (constant == UI.Sizing.savedABVtop) ? 0 : 1
            constant == UI.Sizing.height ? table.scrollToFirstRow() : nil
            let reset = (constant == UI.Sizing.savedABVtop) ? true : false
            self.delegate.animateSubMenu(by: percent, reset: reset)
            // Animate to end-point
//            animateTopAnchor(constant: constant)
        }
    }
    
}
