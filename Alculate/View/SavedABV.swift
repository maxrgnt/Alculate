//
//  SavedABV.swift
//  Alculate
//
//  Created by Max Sergent on 10/11/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol SavedABVDelegate {
    // called when user taps subview/delete button
    func animateSubMenu(by: CGFloat, reset: Bool)
    func animateComparisonLabels()
}

class SavedABV: UIView {
                
    var savedABVDelegate : SavedABVDelegate!

    // Constraints
    var savedABVtop: NSLayoutConstraint!
    
    // Objects
    var gradient = CAGradientLayer()
    var gradient2 = CAGradientLayer()
    let statusBar = StatusBar()
    let header = UIView()
    let headerLabel = UILabel()
    var savedABVTable = SavedABVTable()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = false
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.Radii.comparison)
        
        for obj in [header,savedABVTable] {
            addSubview(obj)
            obj.backgroundColor = backgroundColor
        }
        savedABVTable.build()
        //
        header.addSubview(headerLabel)
        header.backgroundColor = backgroundColor
        headerLabel.font = UI.Font.headerFont
        headerLabel.textColor = UI.Color.fontWhite
        headerLabel.textAlignment = .left
        headerLabel.text = "Drink Library"
        
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        header.addGestureRecognizer(pan)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [header,headerLabel,savedABVTable] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        savedABVtop = topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.height)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheight),
            savedABVtop,
            header.centerXAnchor.constraint(equalTo: centerXAnchor),
            header.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            header.topAnchor.constraint(equalTo: topAnchor),
            header.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheaderHeight),
            headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerLabel.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheaderHeight),
            savedABVTable.widthAnchor.constraint(equalTo: widthAnchor),
            savedABVTable.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVtableHeight),
            savedABVTable.centerXAnchor.constraint(equalTo: centerXAnchor),
            savedABVTable.topAnchor.constraint(equalTo: header.bottomAnchor)
            ])
        
//        addSubview(statusBar)
//        statusBar.build(leading: header.leadingAnchor)
        buildGradient()
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
    
    // MARK: - Animation Functions
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        savedABVTable.isMoving = true
        savedABVTable.reloadSectionIndexTitles()
        // Allow movement of contact card back/forth when not fully visible
        savedABVtop.constant += translation.y
        // If contact card is fully visible, don't allow movement further left
        savedABVtop.constant = savedABVtop.constant < UI.Sizing.savedABVtop ? UI.Sizing.savedABVtop : savedABVtop.constant
        let percent = savedABVtop.constant/UI.Sizing.height >= 1 ? 1 : savedABVtop.constant/UI.Sizing.height
        self.savedABVDelegate.animateSubMenu(by: percent, reset: false)
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            savedABVTable.isMoving = false
            savedABVTable.reloadSectionIndexTitles()
            // Auto-scroll left (in frame) if false, Auto-scroll right (out of frame) if true
            let constant = (savedABVtop.constant/UI.Sizing.height > 0.4) ? UI.Sizing.height : UI.Sizing.savedABVtop
            let percent: CGFloat = (constant == UI.Sizing.savedABVtop) ? 0 : 1
            constant == UI.Sizing.height ? savedABVTable.scrollToFirstRow() : nil
            let reset = (constant == UI.Sizing.savedABVtop) ? true : false
            self.savedABVDelegate.animateSubMenu(by: percent, reset: reset)
            // Animate to end-point
            animateTopAnchor(constant: constant)
        }
    }
    
    func animateTopAnchor(constant: CGFloat) {
        savedABVtop.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut
            , animations: ({
                self.superview!.layoutIfNeeded()
            }), completion: { (completed) in
                (constant == UI.Sizing.savedABVtop) ? nil : self.savedABVDelegate.animateComparisonLabels()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
