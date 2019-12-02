//
//  PrimaryView.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class PrimaryView: UIView {
    
    //MARK: - Definitions
    // Objects
    let header = Header()
    let comparison = ComparisonScroll()
    let menu = Menu()
    
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
        addObjectsToView()
        constraints()
    }
    
    func addObjectsToView() {
        addSubview(header)
        header.setup()
        addSubview(comparison)
        comparison.setup()
        addSubview(menu)
        menu.setup()
    }
    
    func constraints() {
        headerConstraints()
        comparisonScrollConstraints()
        menuConstraints()
    }
    
    //MARK: - Animations
    func moveSummaryAnchor (to state: String) {
        let headerHeight: CGFloat = (state == "hidden") ? UI.Sizing.Header.heightMinimized : UI.Sizing.Header.height
        let summaryTop: CGFloat = (state == "hidden") ? -UI.Sizing.Summary.height : 0.0
        if header.height != nil {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut
                , animations: ({
                    self.header.height.constant = headerHeight
                    self.header.value.top.constant = summaryTop
                    self.header.effect.top.constant = summaryTop
                    self.layoutIfNeeded()
                }), completion: { (completed) in
                    if state == "visible" {
                        self.header.value.calculateNameWidth()
                        self.header.effect.calculateNameWidth()
                    }
                }
            )
        }
    }
    
    func moveMenu (to state: String) {
        let newBottom: CGFloat = (state == "hidden") ? UI.Sizing.Menu.height : 0.0
        if menu.bottom != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut
                , animations: ({
                    self.menu.bottom.constant = newBottom
                    self.layoutIfNeeded()
                }), completion: { (completed) in
                    // pass
                }
            )
        }
    }
    
}
