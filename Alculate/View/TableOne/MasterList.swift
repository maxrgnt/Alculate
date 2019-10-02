//
//  MasterList.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol MasterListDelegate {
    // called when user taps subview/delete button
//    func displayAlert(alert: UIAlertController)
    func closeUndo()
    func bringBackAppNav()
}

class MasterList: UIView {
             
    var masterListDelegate : MasterListDelegate!

    // Objects
    var tableOne = TableOne()
    var undo = Undo()
    var masterListLeading: NSLayoutConstraint!
    var undoBottom = NSLayoutConstraint()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = true
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        addGestureRecognizer(pan)
        //
        addSubview(tableOne)
        tableOne.build()
        //
        addSubview(undo)
        undo.build()
        // MARK: - NSLayoutConstraints
        masterListLeading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.width)
        undoBottom = undo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.appNavigationHeight*(2/3))
        NSLayoutConstraint.activate([
            masterListLeading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.height-(UI.Sizing.headerHeight)),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            undo.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            undo.heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)),
            undo.leadingAnchor.constraint(equalTo: leadingAnchor),
            undoBottom,
            tableOne.widthAnchor.constraint(equalTo: widthAnchor),
            tableOne.heightAnchor.constraint(equalTo: heightAnchor),
            tableOne.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableOne.topAnchor.constraint(equalTo: topAnchor)
            ])        
    }
    
    func minimizeUndo() {
        tableOne.toBeDeleted = []
        undoBottom.constant = UI.Sizing.appNavigationHeight*(2/3)
        layoutIfNeeded()
    }
    
    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        // Allow movement of contact card back/forth when not fully visible
        masterListLeading.constant += translation.x
        // If contact card is fully visible, don't allow movement further left
        if masterListLeading.constant < 0 {
            masterListLeading.constant = 0
        }
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            // Auto-scroll left (in frame)
            var constant: CGFloat = 0.0
            // Auto-scroll right (out of frame)
            if masterListLeading.constant > UI.Sizing.width/4 {
                constant = UI.Sizing.width
            }
            // Animate to end-point
            animateLeadingAnchor(constant: constant)
        }
    }
    
    func animateLeadingAnchor(constant: CGFloat) {
        if constant == UI.Sizing.width {
            self.masterListDelegate.closeUndo()
            self.masterListDelegate.bringBackAppNav()
        }
        masterListLeading.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
