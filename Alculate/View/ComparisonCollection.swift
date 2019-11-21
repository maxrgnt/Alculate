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

class ComparisonCollection: UIScrollView, UIScrollViewDelegate {

    // Delegate object
    var customDelegate : ComparisonCollectionDelegate!

    // Constraints
    var height: NSLayoutConstraint!
    
    // Objects
    var beer = Comparison()
    var liquor = Comparison()
    var wine = Comparison()
    
    override init (frame: CGRect) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame)
    }
    
    // MARK: - View/Object Settings
    func build(anchorTo anchorView: UIView) {
        backgroundColor = .clear
        delegate = self
        isScrollEnabled = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
    
        for (i, obj) in [beer,liquor,wine].enumerated() {
            addSubview(obj)
            obj.header.add.tag = 20 + i
        }
        beer.build(forType: Data.beerListID, anchorTo: self)
        liquor.build(forType: Data.liquorListID, anchorTo: beer)
        wine.build(forType: Data.wineListID, anchorTo: liquor)
        
        constraints(anchorTo: anchorView)
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.savedABVTableDelegate.adjustHeaderBackground()
//        if scrollView.contentOffset.y <= 0 {
//            scrollView.contentOffset.y = 0
//        }
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.Padding.comparison),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
            heightAnchor.constraint(equalToConstant: UI.Sizing.height),
            topAnchor.constraint(equalTo: anchorView.bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



