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
    let header = Header2()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        print("init primary")
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
        for obj in [header] {
            addSubview(obj)
            obj.setup()
        }
    }
    
    func constraints() {
        headerConstraints()
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
                    // pass
                }
            )
        }
    }
    
}
