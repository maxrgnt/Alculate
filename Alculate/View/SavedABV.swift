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
    func animateAppNavigator(by: CGFloat, reset: Bool)
}

class SavedABV: UIView {
                
    var savedABVDelegate : SavedABVDelegate!

    // Constraints
    var savedABVleading: NSLayoutConstraint!
    
    // Objects
    var gradient = CAGradientLayer()
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
        backgroundColor = UI.Color.alculatePurpleDark
//        roundCorners(corners: [.topLeft,.topRight], radius: (UI.Sizing.height-(UI.Sizing.headerHeight))/(UI.Sizing.width/10))
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        addGestureRecognizer(pan)
        for obj in [header,savedABVTable] {
            addSubview(obj)
            obj.backgroundColor = UI.Color.alculatePurpleDark
        }
        savedABVTable.build()
        //
        header.addSubview(headerLabel)
        headerLabel.font = UI.Font.headerFont
        headerLabel.textColor = UI.Color.softWhite
        headerLabel.textAlignment = .left
        headerLabel.text = "Saved drink ABVs:"
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [header,headerLabel,savedABVTable] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        savedABVleading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.width)
        NSLayoutConstraint.activate([
            savedABVleading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.savedABVtop),
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
        
        addSubview(statusBar)
        statusBar.build(leading: savedABVleading)
//        buildGradient()
    }
    
    // MARK: - Gradient Settings
    func buildGradient() {
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.savedABVheight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                           UI.Color.alculatePurpleLite.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0.0,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Animation Functions
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        savedABVTable.isMoving = true
        savedABVTable.reloadSectionIndexTitles()
        // Allow movement of contact card back/forth when not fully visible
        savedABVleading.constant += translation.x
        // If contact card is fully visible, don't allow movement further left
        savedABVleading.constant = savedABVleading.constant < 0 ? 0 : savedABVleading.constant
        let percent = savedABVleading.constant/UI.Sizing.width >= 1 ? 1 : savedABVleading.constant/UI.Sizing.width
        self.savedABVDelegate.animateAppNavigator(by: percent, reset: false)
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            savedABVTable.isMoving = false
            savedABVTable.reloadSectionIndexTitles()
            // Auto-scroll left (in frame) if false, Auto-scroll right (out of frame) if true
            let constant = (savedABVleading.constant > UI.Sizing.savedABVgestureThreshold) ? UI.Sizing.width : 0
            let percent: CGFloat = (constant == 0) ? 0 : 1
            let reset = (constant == 0) ? true : false
            self.savedABVDelegate.animateAppNavigator(by: percent, reset: reset)
            // Animate to end-point
            animateLeadingAnchor(constant: constant)
        }
    }
    
    func animateLeadingAnchor(constant: CGFloat) {
        savedABVleading.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
