//
//  Constraints.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

//MARK: PrimaryView
extension PrimaryView {
    
    func headerConstraints() {
        header.height = header.heightAnchor.constraint(equalToConstant: UI.Sizing.Header.height)
        header.translatesAutoresizingMaskIntoConstraints                                                = false
        header.widthAnchor.constraint(equalToConstant: UI.Sizing.Header.width).isActive                 = true
        header.height.isActive                                                                          = true
        header.topAnchor.constraint(equalTo: topAnchor).isActive                                        = true
        header.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                = true
    }
    
}

//MARK: Header
extension Header {

    func statusBarConstraints() {
        statusBar.translatesAutoresizingMaskIntoConstraints                                             = false
        statusBar.widthAnchor.constraint(equalToConstant: UI.Sizing.StatusBar.width).isActive           = true
        statusBar.heightAnchor.constraint(equalToConstant: UI.Sizing.StatusBar.height).isActive         = true
        statusBar.topAnchor.constraint(equalTo: topAnchor).isActive                                     = true
        statusBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                             = true
    }
    
    func appNameConstraints() {
        appName.translatesAutoresizingMaskIntoConstraints                                               = false
        appName.widthAnchor.constraint(equalToConstant: UI.Sizing.Header.appName.width).isActive        = true
        appName.heightAnchor.constraint(equalToConstant: UI.Sizing.Header.appName.height).isActive      = true
        appName.topAnchor.constraint(equalTo: statusBar.bottomAnchor).isActive                          = true
        appName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                               = true
    }
    
    func valueConstraints() {
        value.top = value.topAnchor.constraint(equalTo: appName.bottomAnchor)
        value.translatesAutoresizingMaskIntoConstraints                                               = false
        value.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive               = true
        value.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.height).isActive             = true
        value.top.isActive                                                                            = true
        value.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -UI.Sizing.Summary.xOffset).isActive      = true
    }
    
    func effectConstraints() {
        effect.top = effect.topAnchor.constraint(equalTo: appName.bottomAnchor)
        effect.translatesAutoresizingMaskIntoConstraints                                               = false
        effect.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive               = true
        effect.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.height).isActive             = true
        effect.top.isActive                                                                            = true
        effect.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UI.Sizing.Summary.xOffset).isActive    = true
    }
    
}


//MARK: SummaryCell
extension SummaryCell {

    func categoryConstraints() {
        category.translatesAutoresizingMaskIntoConstraints                                             = false
        category.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive           = true
        category.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.categoryHeight).isActive         = true
        category.topAnchor.constraint(equalTo: topAnchor).isActive                                     = true
        category.centerXAnchor.constraint(equalTo: centerXAnchor).isActive     = true
    }
    
    func nameConstraints() {
        nameWidth = name.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width)
        nameCenterX = name.centerXAnchor.constraint(equalTo: centerXAnchor)
        name.translatesAutoresizingMaskIntoConstraints                                               = false
        nameWidth.isActive                                                                          = true
        name.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.nameHeight).isActive      = true
        name.topAnchor.constraint(equalTo: category.bottomAnchor).isActive                          = true
        nameCenterX.isActive           = true
    }
    
    func statConstraints() {
        stat.translatesAutoresizingMaskIntoConstraints                                               = false
        stat.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive               = true
        stat.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.statHeight).isActive             = true
        stat.topAnchor.constraint(equalTo: name.bottomAnchor).isActive                                    = true
        stat.centerXAnchor.constraint(equalTo: centerXAnchor).isActive               = true
    }
    
    func statUnitConstraints() {
        statUnit.translatesAutoresizingMaskIntoConstraints                                               = false
        statUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive               = true
        statUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.statUnitHeight).isActive             = true
        statUnit.topAnchor.constraint(equalTo: stat.bottomAnchor).isActive                               = true
        statUnit.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                      = true
    }
}
