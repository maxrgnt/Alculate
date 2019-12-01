//
//  ComparisonCollection.swift
//  Alculate
//
//  Created by Max Sergent on 11/20/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol ComparisonCollectionDelegate {
    // called when user taps container or delete button
//    func reloadTable(table: String, realculate: Bool)
//    func makeDeletable(_ paramDeletable: Bool, lists: String)
//    func editComparison(type: String, name: String, abv: String, size: String, price: String)
//    func alculate()
}

class ComparisonCollection: UIScrollView {

    // Delegate object
    var customDelegate : ComparisonCollectionDelegate!

    // Constraints
    var height: NSLayoutConstraint!
    var emptyPromptTop: NSLayoutConstraint!
    
    // Objects
    var content = UIView()
    var beer = Comparison()
    var liquor = Comparison()
    var wine = Comparison()
    var emptyPrompt = UILabel()
    
    override init (frame: CGRect) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame)
    }
    
    // MARK: - View/Object Settings
    func build(anchorTo anchorView: UIView) {
        backgroundColor = .clear
//        delegate = self
        isScrollEnabled = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        contentSize.height = UI.Sizing.height-UI.Sizing.subMenuHeight-UI.Sizing.Height.header
        
        for (i, obj) in [beer,liquor,wine].enumerated() {
            addSubview(obj)
            obj.header.add.tag = 20 + i
            obj.clear.tag = i
        }
        beer.build(forType: Data.beerListID, anchorTo: self)
        liquor.build(forType: Data.liquorListID, anchorTo: beer)
        wine.build(forType: Data.wineListID, anchorTo: liquor)
        
        addSubview(emptyPrompt)
        emptyPrompt.backgroundColor = .clear
        emptyPrompt.textColor = UI.Color.Border.comparison
        emptyPrompt.text = "Add a drink above!"
        emptyPrompt.font = UI.Font.Comparison.type
        emptyPrompt.textAlignment = .center
        
        constraints(anchorTo: anchorView)
    }
    
    func updateHeight(for table: String) {
        print("update for \(table)")
        self.layoutIfNeeded()
        let tables = [beer,liquor,wine]
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        for (i, id) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            if id == table {
                print(id, lists[i].count)
                var newConstant = UI.Sizing.Height.comparisonRow * CGFloat(lists[i].count) + UI.Sizing.Radii.comparison
                newConstant += UI.Sizing.Border.comparisonRow*2
//                newTableHeight = (lists[i].count == 0) ? newTableHeight + UI.Sizing.Radii.comparisonEmpty : newTableHeight + UI.Sizing.Radii.comparisonEmpty
//                let newRadius = (lists[i].count == 0) ? UI.Sizing.Radii.comparisonEmpty : UI.Sizing.Radii.comparison
        //        table.height.constant = newTableHeight
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut
                    , animations: ({
//                        tables[i].layer.cornerRadius = newRadius
                        tables[i].height.constant = UI.Sizing.Height.comparisonHeader + newConstant
                        self.layoutIfNeeded()
                    }), completion: { (completed) in
                        // pass
                })
//                tables[i].clear.isHidden = (lists[i].count == 0) ? true : false
                //break
            }
        }
    }
    
    // MARK: - ScrollView Delegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.contentOffset.y += scrollView.contentOffset.y
//        self.savedABVTableDelegate.adjustHeaderBackground()
//        if scrollView.contentOffset.y <= 0 {
//            scrollView.contentOffset.y = 0
//        }
//    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        for obj in [self, emptyPrompt] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        emptyPromptTop = emptyPrompt.topAnchor.constraint(equalTo: wine.bottomAnchor)
        height = heightAnchor.constraint(equalToConstant: UI.Sizing.height-UI.Sizing.subMenuHeight-UI.Sizing.Height.headerMinimized)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.Padding.comparison),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
            height,
            topAnchor.constraint(equalTo: anchorView.bottomAnchor),
            emptyPromptTop,
            emptyPrompt.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.Padding.comparison),
            emptyPrompt.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
            emptyPrompt.heightAnchor.constraint(equalToConstant: UI.Sizing.height-UI.Sizing.subMenuHeight-UI.Sizing.Height.header - (UI.Sizing.Padding.comparison)*3 - UI.Sizing.Height.comparison*3)
            ])
    }
    
    func updateContentSize() {
        // Set at 4 because there is a gab above each (three) tables and one below the last
        var newContentSize: CGFloat = 3 * UI.Sizing.Padding.comparison
        for comparison in [beer,liquor,wine] {
            newContentSize += comparison.height.constant
        }
        // add padding to bottom if bigger than given screen area
        newContentSize = (newContentSize > UI.Sizing.Height.comparisonCollectionFull) ? newContentSize + UI.Sizing.Padding.comparison : newContentSize
        // change content size based off scrollview size
        newContentSize = (height.constant == UI.Sizing.Height.comparisonCollectionEmpty) ? UI.Sizing.Height.comparisonCollectionEmpty : newContentSize
        contentSize.height = newContentSize
    }
    
    func checkIfEmpty() {
        var empty = true
        for list in [Data.beerList, Data.liquorList, Data.wineList] {
            if list.count > 0 {
                empty = false
            }
        }
        let newAlpha: CGFloat = empty ? 1.0 : 0.0
        let newHeight = empty ? UI.Sizing.Height.comparisonCollectionEmpty : UI.Sizing.Height.comparisonCollectionFull
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut
                    , animations: ({
                        self.height.constant = newHeight
                        self.emptyPrompt.alpha = newAlpha
                        self.layoutIfNeeded()
                    }), completion: { (completed) in
                        // pass
                })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



