//
//  SummaryCell.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SummaryCell: UIView {
    
    //MARK: - Definitions
    // Constraints
    var top: NSLayoutConstraint!
    var nameWidth: NSLayoutConstraint!
    var nameCenterX: NSLayoutConstraint!
    // Objects
    let category = UILabel()
    let name = UILabel()
    let stat = UILabel()
    let statUnit = UILabel()
    var objects: [UILabel] = []
    // Variables
    var centerOffset: CGFloat!
    var calcFontWidth: CGFloat!
    var nameAnimating = false
    var side: String!
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup(to side: String) {
        self.side = side
        objects = [category,name,stat,statUnit]
        clipsToBounds = true
        
        addObjectsToView()
        objectSettings()
        
        setCenterOffset()
        constraints()
        
//        testLabels()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        for obj in objects {
            addSubview(obj)
        }
    }
    
    //MARK: - Constraints
    func constraints() {
        categoryConstraints()
        nameConstraints()
        statConstraints()
        statUnitConstraints()
    }
    
    //MARK: - Settings
    func objectSettings() {
        for label in objects {
            label.alpha = 1.0
            label.textColor = UI.Color.Header.font
            label.textAlignment = (side == "left") ? .left : .right
        }
        category.font = UI.Font.Summary.category
        name.font = UI.Font.Summary.name
        stat.font = UI.Font.Summary.stat
        statUnit.font = UI.Font.Summary.statUnit
        statUnit.alpha = 0.7
    }
    
    func setCenterOffset() {
        let multiplier: CGFloat = (side == "left") ? -1.0 : 1.0
        centerOffset = multiplier * (UI.Sizing.Summary.width/2)
    }
    
    //MARK: - Label Animator
    func calculateNameWidth() {
        nukeAllAnimations()
        // calculate width of text with given font
        calcFontWidth = name.text!.width(withConstrainedHeight: UI.Sizing.Summary.nameHeight, font: name.font)
        if calcFontWidth > UI.Sizing.Summary.width && !nameAnimating {
            // calculate duration needed to traverse width per second
            let duration = Double(calcFontWidth/translationsPerSecond())
            // reset left/right centers with new width
            let center = setCentersForAnimating()
            // start the animation if all criteria met otherwise do nothing
            startAnimation(for: duration, fromOld: center.origin, toNew: center.translated)
        }
    }
    
    func nukeAllAnimations() {
        self.nameAnimating = false
        self.subviews.forEach({$0.layer.removeAllAnimations()})
        self.layer.removeAllAnimations()
        calcFontWidth = name.text!.width(withConstrainedHeight: UI.Sizing.Summary.nameHeight, font: name.font)
        let duration = Double(calcFontWidth/translationsPerSecond())
        let center = setCentersForAnimating()
        DispatchQueue.main.async(execute: { // repeat and autoreverse
            UIView.animate(withDuration: duration, delay: 0.4, options: ([.curveEaseInOut])
                , animations: ({
                    self.nameCenterX.constant = center.origin
                    self.layoutIfNeeded()
                }), completion: { (completed) in
                    self.nameAnimating = false
            })
        })
    }
    
    func translationsPerSecond() -> CGFloat {
        let secondsToPanFullContainer: CGFloat = 2.0
        return UI.Sizing.Summary.width/secondsToPanFullContainer
    }
    
    func setCentersForAnimating() -> (origin: CGFloat, translated: CGFloat) {
        // set constant of name width to calculated version
        nameWidth.constant = calcFontWidth
        // calculate left and right centers
        let leftCenter = (calcFontWidth/2-UI.Sizing.Summary.width/2)
        let rightCenter = (UI.Sizing.Summary.width/2-calcFontWidth/2)
        // set origin and translated centers
        let originCenter = (side == "left") ? leftCenter : rightCenter
        let translatedCenter = (side == "left") ? rightCenter : leftCenter
        // set constraint to origin
        nameCenterX.constant = originCenter
        self.layoutIfNeeded()
        return (origin: originCenter, translated: translatedCenter)
    }

    func startAnimation(for duration: Double, fromOld oldCenter: CGFloat, toNew newCenter: CGFloat) {
        nameAnimating = true
        // animate asyncronously
        DispatchQueue.main.async(execute: { // repeat and autoreverse 
            UIView.animate(withDuration: duration, delay: 0.4, options: ([.curveEaseInOut, .repeat, .autoreverse])
                , animations: ({
                    self.nameCenterX.constant = newCenter
                    self.layoutIfNeeded()
                }), completion: { (completed) in
//                    self.nameCenterX.constant = oldCenter
//                    self.layoutIfNeeded()
//                    self.nameAnimating = false
//                    print("\(self.name.text!) has stopped animating")
            })
        })
    }
    
    //MARK: - Test Functions
    func testLabels() {
        for label in objects {
            label.text = "Test: \(centerOffset!)"
        }
        name.text = "This is quite a long name wouldn't you say?"
    }
}
