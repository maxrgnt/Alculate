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
    func closeUndo()
    func updateAppNavBottom(by: CGFloat, animate: Bool)
}

class SavedABV: UIView {
                
    var savedABVDelegate : SavedABVDelegate!

    // Constraints
    var savedABVleading: NSLayoutConstraint!
    var undoBottom: NSLayoutConstraint!
    
    // Objects
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let header = UIView()
    let headerLabel = UILabel()
    var savedABVTable = SavedABVTable()
    var undo = Undo()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: (UI.Sizing.height-(UI.Sizing.headerHeight))/(UI.Sizing.width/10))
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        addGestureRecognizer(pan)
        // Blur object settings
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        // Vibrancy object settings
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        // View object settings
        for obj in [header,savedABVTable] {
            blurEffectView.contentView.addSubview(obj)
            obj.backgroundColor = .clear
            // addSubview(obj)
        }
        savedABVTable.build()
        //
        header.addSubview(headerLabel)
        headerLabel.font = UI.Font.headerFont
        headerLabel.textColor = UI.Color.softWhite
        headerLabel.textAlignment = .left
        headerLabel.text = "ABVs for saved drinks:"
        //
        addSubview(undo)
        undo.build()
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [blurEffectView,vibrancyView,header,headerLabel,savedABVTable] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        savedABVleading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: 0)//UI.Sizing.width)
        undoBottom = undo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.appNavigationHeight*(2/3))
        NSLayoutConstraint.activate([
            savedABVleading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.height-(UI.Sizing.headerHeight)),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            vibrancyView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            vibrancyView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            undo.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            undo.heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)),
            undo.leadingAnchor.constraint(equalTo: leadingAnchor),
            undoBottom,
            header.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor),
            header.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            header.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            header.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheaderHeight),
            headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerLabel.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheaderHeight),
            savedABVTable.widthAnchor.constraint(equalTo: widthAnchor),
            savedABVTable.heightAnchor.constraint(equalTo: heightAnchor),
            savedABVTable.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor),
            savedABVTable.topAnchor.constraint(equalTo: header.bottomAnchor)
            ])
    }
    
    func minimizeUndo() {
//        tableOne.toBeDeleted = []
        undoBottom.constant = UI.Sizing.appNavigationHeight*(2/3)
        layoutIfNeeded()
    }
    
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: self)
//        tableOne.isMoving = true
//        tableOne.reloadSectionIndexTitles()
        // Allow movement of contact card back/forth when not fully visible
//        masterListLeading.constant += translation.x
        // If contact card is fully visible, don't allow movement further left
//        if masterListLeading.constant < 0 {
//            masterListLeading.constant = 0
//        }
//        var percent = masterListLeading.constant/UI.Sizing.width
//        var shouldAnimate = false
//        if percent >= 1.0 {
//            percent = 1.0
//            shouldAnimate = true
//        }
//        self.masterListDelegate.updateAppNavBottom(by: percent, animate: shouldAnimate)
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
//            tableOne.isMoving = false
//            tableOne.reloadSectionIndexTitles()
            // Auto-scroll left (in frame)
            let constant: CGFloat = UI.Sizing.width // 0.0
            // Auto-scroll right (out of frame)
            //if masterListLeading.constant > UI.Sizing.width/4 {
            //    constant = UI.Sizing.width
            //}
            // Animate to end-point
            animateLeadingAnchor(constant: constant)
        }
    }
    
    func animateLeadingAnchor(constant: CGFloat) {
        if constant == UI.Sizing.width {
//            self.masterListDelegate.closeUndo()
//            self.masterListDelegate.updateAppNavBottom(by: 1, animate: true)
        }
//        masterListLeading.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
