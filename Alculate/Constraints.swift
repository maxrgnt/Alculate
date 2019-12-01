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
        header.height = header.heightAnchor.constraint(equalToConstant: UI.Sizing.Header.heightMinimized)
        header.translatesAutoresizingMaskIntoConstraints                                                = false
        header.widthAnchor.constraint(equalToConstant: UI.Sizing.Header.width).isActive                 = true
        header.height.isActive                                                                          = true
        header.topAnchor.constraint(equalTo: topAnchor).isActive                                        = true
        header.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                = true
    }
    
    func comparisonScrollConstraints() {
        comparison.height = comparison.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Scroll.heightEmpty)
        comparison.translatesAutoresizingMaskIntoConstraints                                                = false
        comparison.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                        = true
        comparison.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Scroll.width).isActive         = true
        comparison.height.isActive                                                                      = true
        comparison.topAnchor.constraint(equalTo: header.bottomAnchor).isActive                      = true
    }
    
    func menuConstraints() {
        menu.bottom = menu.bottomAnchor.constraint(equalTo: bottomAnchor)
        menu.translatesAutoresizingMaskIntoConstraints                                                = false
        menu.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                             = true
        menu.widthAnchor.constraint(equalToConstant: UI.Sizing.Menu.width).isActive         = true
        menu.bottom.isActive                                                                      = true
        menu.heightAnchor.constraint(equalToConstant: UI.Sizing.Menu.height).isActive                      = true
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
        value.top = value.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: -UI.Sizing.Summary.height)
        value.translatesAutoresizingMaskIntoConstraints                                               = false
        value.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive               = true
        value.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.height).isActive             = true
        value.top.isActive                                                                            = true
        value.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -UI.Sizing.Summary.xOffset).isActive      = true
    }
    
    func effectConstraints() {
        effect.top = effect.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: -UI.Sizing.Summary.height)
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

//MARK: ComparisonScroll
extension ComparisonScroll {
    
    func beerConstraints () {
        beer.height = beer.heightAnchor.constraint(equalToConstant: 100.0)
        beer.translatesAutoresizingMaskIntoConstraints                                                  = false
        beer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                  = true
        beer.widthAnchor.constraint(equalTo: widthAnchor).isActive                                      = true
        beer.height.isActive                                                                            = true
        beer.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.Comparison.padding).isActive  = true
    }
    
    func liquorConstraints () {
        liquor.height = liquor.heightAnchor.constraint(equalToConstant: 0.0)
        liquor.translatesAutoresizingMaskIntoConstraints                                                    = false
        liquor.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                  = true
        liquor.widthAnchor.constraint(equalTo: widthAnchor).isActive                                      = true
        liquor.height.isActive                                                                            = true
        liquor.topAnchor.constraint(equalTo: beer.bottomAnchor, constant: UI.Sizing.Comparison.padding).isActive  = true
    }
    
    func wineConstraints () {
        wine.height = wine.heightAnchor.constraint(equalToConstant: 0.0)
        wine.translatesAutoresizingMaskIntoConstraints                                                      = false
        wine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                  = true
        wine.widthAnchor.constraint(equalTo: widthAnchor).isActive                                      = true
        wine.height.isActive                                                                            = true
        wine.topAnchor.constraint(equalTo: liquor.bottomAnchor, constant: UI.Sizing.Comparison.padding).isActive  = true
    }
    
    func emptyConstraints() {
        emptyTop = empty.topAnchor.constraint(equalTo: wine.bottomAnchor)
        empty.translatesAutoresizingMaskIntoConstraints                                                      = false
        empty.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                  = true
        empty.widthAnchor.constraint(equalTo: widthAnchor).isActive                                      = true
        emptyTop.isActive                                                                            = true
        empty.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Empty.height).isActive          = true
    }
    
}

//MARK: ComparisonContainer
extension ComparisonContainer {
    
    func headerConstraints() {
        header.translatesAutoresizingMaskIntoConstraints                                                        = false
        header.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                        = true
        header.topAnchor.constraint(equalTo: topAnchor).isActive                                                = true
        header.widthAnchor.constraint(equalTo: widthAnchor).isActive                                            = true
        header.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.height).isActive  = true
    }
    
    func tableConstraints() {
        table.translatesAutoresizingMaskIntoConstraints                                                        = false
        table.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                        = true
        table.topAnchor.constraint(equalTo: header.bottomAnchor).isActive                                      = true
        table.widthAnchor.constraint(equalTo: widthAnchor).isActive                                            = true
        table.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Sizing.Comparison.padding).isActive  = true
    }
    
}

//MARK: ContainerHeader
extension ContainerHeader {
    
    func typeConstraints() {
        type.translatesAutoresizingMaskIntoConstraints                                                        = false
        type.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                        = true
        type.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                        = true
        type.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.contentWidth).isActive         = true
        type.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.height).isActive              = true
    }
    
    func addConstraints() {
        add.translatesAutoresizingMaskIntoConstraints                                                        = false
        add.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                        = true
        add.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                        = true
        add.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.contentWidth).isActive            = true
        add.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.height).isActive              = true
    }
    
}

//MARK: ContainerCell
extension ContainerCell {
    
    func nameConstraints() {
        name.translatesAutoresizingMaskIntoConstraints                                                          = false
        name.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.nameWidth).isActive               = true
        name.heightAnchor.constraint(equalTo: heightAnchor, constant: -UI.Sizing.Comparison.border).isActive    = true
        name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Comparison.padding).isActive  = true
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                          = true
    }
    
    func valueConstraints() {
        value.translatesAutoresizingMaskIntoConstraints                                                          = false
        value.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.nameWidth).isActive               = true
        value.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.statHeight).isActive             = true
        value.leadingAnchor.constraint(equalTo: name.trailingAnchor).isActive                                = true
        value.topAnchor.constraint(equalTo: topAnchor).isActive                                          = true
    }
    
    func valueUnitConstraints() {
        valueUnit.translatesAutoresizingMaskIntoConstraints                                                          = false
        valueUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.valueWidth).isActive               = true
        valueUnit.heightAnchor.constraint(equalTo: heightAnchor, constant: -UI.Sizing.Comparison.border).isActive    = true
        valueUnit.leadingAnchor.constraint(equalTo: name.trailingAnchor).isActive                                   = true
        valueUnit.topAnchor.constraint(equalTo: value.bottomAnchor, constant: UI.Sizing.Comparison.Row.unitOffset).isActive = true
    }
    
    func effectConstraints() {
        effect.translatesAutoresizingMaskIntoConstraints                                                          = false
        effect.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.effectWidth).isActive               = true
        effect.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.statHeight).isActive             = true
        effect.leadingAnchor.constraint(equalTo: value.trailingAnchor).isActive                                = true
        effect.topAnchor.constraint(equalTo: topAnchor).isActive                                          = true
    }
    
    func effectUnitConstraints() {
        effectUnit.translatesAutoresizingMaskIntoConstraints                                                          = false
        effectUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.effectWidth).isActive               = true
        effectUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.statHeight).isActive             = true
        effectUnit.leadingAnchor.constraint(equalTo: valueUnit.trailingAnchor).isActive                                = true
        effectUnit.topAnchor.constraint(equalTo: value.bottomAnchor, constant: UI.Sizing.Comparison.Row.unitOffset).isActive = true
    }
    
}

//MARK: Secondary View
extension SecondaryView {
    
    func tableHeaderConstraints() {
        
    }
    
    func tableConstraints() {
        
    }
    
}
