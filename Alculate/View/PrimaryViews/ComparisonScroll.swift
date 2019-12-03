//
//  ComparisonAll.swift
//  Alculate
//
//  Created by Max Sergent on 11/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class ComparisonScroll: UIScrollView {
    
    //MARK: - Definitions
    // Constraints
    var height: NSLayoutConstraint!
    var emptyTop: NSLayoutConstraint!
    // Objects
    let beer = ComparisonContainer()
    let liquor = ComparisonContainer()
    let wine = ComparisonContainer()
    var containers: [ComparisonContainer] = []
    let total = ComparisonTotal()
    let empty = UILabel()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        
        containers = [beer,liquor,wine]
        
        isScrollEnabled = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        contentSize.height = UI.Sizing.Comparison.Scroll.heightEmpty
        
        addObjectsToView()
        
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        for (i, obj) in containers.enumerated() {
            addSubview(obj)
            obj.setup(forType: Data.IDs[i])
//            obj.header.add.tag = 20 + i
        }
        addSubview(total)
        total.setup()
        
        addSubview(empty)
        empty.backgroundColor = .clear
        empty.textColor = UI.Color.Comparison.border
        empty.text = "Add a drink above!"
        empty.font = UI.Font.Comparison.empty
        empty.textAlignment = .center
        
    }

    //MARK: - Constraints
    func constraints() {
        beerConstraints()
        liquorConstraints()
        wineConstraints()
        for obj in Data.IDs {
            updateHeight(for: obj, animated: false)
        }
        totalConstraints()
        emptyConstraints()
    }
    
    //MARK: - Settings
    func printConstraintConstants(for view: UIView) {
        for constraint in view.constraints {
            print(constraint)
        }

        for subview in view.subviews {
            printConstraintConstants(for: subview)
        }
    }
    
    //MARK: - Functions
    func updateHeight(for container: String, animated: Bool? = true) {
        var newContainer: CGFloat = 0.0
        var newTable: CGFloat = 0.0
        for (i, id) in Data.IDs.enumerated() {
            if container == id {
                // set new height to the header + however many rows
                newTable = CGFloat(Data.lists[i].count) * UI.Sizing.Comparison.Row.height
                newContainer = newTable + UI.Sizing.Comparison.Header.height
                // add to the new height for the rounded radii at bottom and border
                newContainer += UI.Sizing.Comparison.radii + UI.Sizing.Comparison.border*2
                // only animate when necessary (not on app load)
                if animated! {
                    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut
                        , animations: ({
                            self.containers[i].height.constant = newContainer
                            self.containers[i].table.height.constant = newTable
                            self.layoutIfNeeded()
                        }), completion: { (completed) in
                            // pass
                    })
                }
                else {
                    containers[i].height.constant = newContainer
                    containers[i].table.height.constant = newTable
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func updateContentSize() {
        // Set at 4 because there is a gap above each (three) tables and one below the last
        var new: CGFloat = 3 * UI.Sizing.Padding.comparison
        // add height of each container
        for container in containers {
            new += container.height.constant
        }
        // add padding to bottom if bigger than given screen area
        let newPadded = new + UI.Sizing.Comparison.padding
        new = (newPadded > UI.Sizing.Comparison.Scroll.heightFull) ? newPadded : new
        // change content size based off scrollview size
//        new = (height.constant == UI.Sizing.Comparison.Scroll.heightEmpty) ? UI.Sizing.Comparison.Scroll.heightEmpty : new
        contentSize.height = new
    }
    
    func checkIfEmpty() {
        var isEmpty = true
        for list in Data.lists {
            isEmpty = (list.count > 0) ? false : true
            if !isEmpty {
                break
            }
        }
        let newHeight = isEmpty ? UI.Sizing.Comparison.Scroll.heightEmpty : UI.Sizing.Comparison.Scroll.heightFull
        let newTotal = isEmpty ? 0.0 : UI.Sizing.Comparison.Total.height
        let newPadding = isEmpty ? 0.0 : UI.Sizing.Comparison.padding
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut
                    , animations: ({
                        self.height.constant = newHeight
                        self.total.height.constant = newTotal
                        self.beer.top.constant = newPadding
                        self.empty.alpha = isEmpty ? 1.0 : 0.0
                        self.total.alpha = isEmpty ? 0.0 : 1.0
                        self.layoutIfNeeded()
                    }), completion: { (completed) in
                        // pass
                })
    }
    
    // MARK: - ScrollView Delegate
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        self.contentOffset.y += scrollView.contentOffset.y
    //        self.savedABVTableDelegate.adjustHeaderBackground()
    //        if scrollView.contentOffset.y <= 0 {
    //            scrollView.contentOffset.y = 0
    //        }
    //    }
    
}
