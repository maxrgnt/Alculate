//
//  SummaryCell.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SummaryCell2: UIView {
    
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
        print("init summaryCell2")
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
        
        testLabels()
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
        // nuke all nimations
        self.subviews.forEach({$0.layer.removeAllAnimations()})
        self.layer.removeAllAnimations()
        // setup new animations
        let secondsToPanFullContainer: CGFloat = 2.0
        let standardWidth = UI.Sizing.Summary.width
        let pixelsPerSecond = standardWidth/secondsToPanFullContainer
        let calcHeight = UI.Sizing.Summary.nameHeight
        // calculate width of text with given font
        calcFontWidth = name.text!.width(withConstrainedHeight: calcHeight, font: name.font)
        // calculate duration needed to traverse width at pixels per second
        let duration = Double(calcFontWidth/pixelsPerSecond)
        // if width calculated to be smaller than standard, make standard
        calcFontWidth = (calcFontWidth < standardWidth) ? standardWidth : calcFontWidth
        // set constant of name width to calculated version
        nameWidth.constant = calcFontWidth
        let leftCenter = (calcFontWidth/2-standardWidth/2)
        let rightCenter = (standardWidth/2-calcFontWidth/2)
        let center = (side == "left") ? leftCenter : rightCenter
        nameCenterX.constant = center
        self.layoutIfNeeded()
        // set new center based off side of screen on
        let newCenter = (side == "left") ? rightCenter : leftCenter
        // start the animation if all criteria met otherwise do nothing
        (standardWidth < calcFontWidth && !nameAnimating) ? startAnimation(for: duration, toNew: newCenter, fromOld: center) : nil
    }

    func startAnimation(for duration: Double, toNew newCenter: CGFloat, fromOld oldCenter: CGFloat) {
        nameAnimating = true
        // animate asyncronously
        DispatchQueue.main.async(execute: { // repeat and autoreverse 
            UIView.animate(withDuration: duration, delay: 1, options: ([.curveEaseInOut, .repeat, .autoreverse])
                , animations: ({
                    self.nameCenterX.constant = newCenter
                    self.layoutIfNeeded()
                }), completion: { (completed) in
                    self.nameCenterX.constant = oldCenter
                    self.layoutIfNeeded()
                    self.nameAnimating = false
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
