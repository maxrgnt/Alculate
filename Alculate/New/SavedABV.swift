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
    func delegateHideUndo()
    func animateAppNavigator(by: CGFloat, animate: Bool)
}

class SavedABV: UIView {
                
    var savedABVDelegate : SavedABVDelegate!

    // Constraints
    var savedABVleading: NSLayoutConstraint!
    var undoBottom: NSLayoutConstraint!
    
    // Objects
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
        backgroundColor = UI.Color.alculatePurpleDark
        roundCorners(corners: [.topLeft,.topRight], radius: (UI.Sizing.height-(UI.Sizing.headerHeight))/(UI.Sizing.width/10))
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        addGestureRecognizer(pan)
        for obj in [header,savedABVTable] {
            addSubview(obj)
            obj.backgroundColor = .clear
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
        for obj in [header,headerLabel,savedABVTable] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        savedABVleading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.width)
        undoBottom = undo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.appNavigationHeight*(2/3))
        NSLayoutConstraint.activate([
            savedABVleading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.height-(UI.Sizing.headerHeight)),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            undo.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            undo.heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)),
            undo.leadingAnchor.constraint(equalTo: leadingAnchor),
            undoBottom,
            header.centerXAnchor.constraint(equalTo: centerXAnchor),
            header.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            header.topAnchor.constraint(equalTo: topAnchor),
            header.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheaderHeight),
            headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerLabel.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVheaderHeight),
            savedABVTable.widthAnchor.constraint(equalTo: widthAnchor),
            savedABVTable.heightAnchor.constraint(equalTo: heightAnchor),
            savedABVTable.centerXAnchor.constraint(equalTo: centerXAnchor),
            savedABVTable.topAnchor.constraint(equalTo: header.bottomAnchor)
            ])
    }
    
    // MARK: - Animation Functions
    func hideUndo() {
        savedABVTable.toBeDeleted = []
        undoBottom.constant = UI.Sizing.appNavigationHeight*(2/3)
        layoutIfNeeded()
    }
    
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        savedABVTable.isMoving = true
        savedABVTable.reloadSectionIndexTitles()
        // Allow movement of contact card back/forth when not fully visible
        savedABVleading.constant += translation.x
        // If contact card is fully visible, don't allow movement further left
        savedABVleading.constant = savedABVleading.constant < 0 ? 0 : savedABVleading.constant
        let percent = savedABVleading.constant/UI.Sizing.width >= 1 ? 1 : savedABVleading.constant/UI.Sizing.width
        let booly = percent >= 1 ? true : false
        self.savedABVDelegate.animateAppNavigator(by: percent, animate: booly)
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            savedABVTable.isMoving = false
            savedABVTable.reloadSectionIndexTitles()
            // Auto-scroll left (in frame) if false, Auto-scroll right (out of frame) if true
            let constant = savedABVleading.constant > UI.Sizing.width/4 ? UI.Sizing.width : savedABVleading.constant
            // Animate to end-point
            animateLeadingAnchor(constant: constant)
        }
    }
    
    func animateLeadingAnchor(constant: CGFloat) {
        if constant == UI.Sizing.width {
            self.savedABVDelegate.delegateHideUndo()
            self.savedABVDelegate.animateAppNavigator(by: 1, animate: true)
        }
        savedABVleading.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
