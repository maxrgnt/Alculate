//
//  Constraints.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

//MARK: ViewController
extension ViewController {
    
    func primaryViewConstraints() {
        primaryView.translatesAutoresizingMaskIntoConstraints                                                       = false
        primaryView.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                        = true
        primaryView.trailingAnchor.constraint(equalTo: ViewController.trailingAnchor).isActive                      = true
        primaryView.topAnchor.constraint(equalTo: ViewController.topAnchor).isActive                                = true
        primaryView.heightAnchor.constraint(equalToConstant: UI.Sizing.Primary.height).isActive                     = true
    }
    
    func secondaryViewConstraints() {
        ViewController.secondaryTop = secondaryView.topAnchor.constraint(equalTo: ViewController.bottomAnchor)
        secondaryView.translatesAutoresizingMaskIntoConstraints                                                     = false
        secondaryView.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                      = true
        secondaryView.trailingAnchor.constraint(equalTo: ViewController.trailingAnchor).isActive                    = true
        ViewController.secondaryTop.isActive                                                                        = true
        secondaryView.heightAnchor.constraint(equalToConstant: UI.Sizing.Secondary.height).isActive                 = true
    }
    
    func tapDismissConstraints() {
        let x = UI.Sizing.bounds.height
        TapDismiss.dismissTop = tapDismiss.topAnchor.constraint(equalTo: ViewController.topAnchor, constant: x)
        tapDismiss.translatesAutoresizingMaskIntoConstraints                                                        = false
        TapDismiss.dismissTop.isActive                                                                              = true
        tapDismiss.bottomAnchor.constraint(equalTo: ViewController.bottomAnchor).isActive                           = true
        tapDismiss.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                         = true
        tapDismiss.trailingAnchor.constraint(equalTo: ViewController.trailingAnchor).isActive                       = true
    }
    
    func textEntryConstraints() {
        textEntry.top = textEntry.topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        textEntry.translatesAutoresizingMaskIntoConstraints                                                         = false
        textEntry.top.isActive                                                                                      = true
        textEntry.widthAnchor.constraint(equalToConstant: UI.Sizing.width).isActive                                 = true
        textEntry.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.height).isActive                     = true
        textEntry.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                          = true
    }
    
    func undoConstraints() {
        undo.top = undo.topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        undo.translatesAutoresizingMaskIntoConstraints                                                              = false
        undo.top.isActive                                                                                           = true
        undo.widthAnchor.constraint(equalToConstant: UI.Sizing.width).isActive                                      = true
        undo.heightAnchor.constraint(equalToConstant: UI.Sizing.Undo.height).isActive                               = true
        undo.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                               = true
    }
    
}

//MARK: PrimaryView
extension PrimaryView {
    
    func headerConstraints() {
        header.height = header.heightAnchor.constraint(equalToConstant: UI.Sizing.Header.heightMinimized)
        header.translatesAutoresizingMaskIntoConstraints                                                            = false
        header.widthAnchor.constraint(equalToConstant: UI.Sizing.Header.width).isActive                             = true
        header.height.isActive                                                                                      = true
        header.topAnchor.constraint(equalTo: topAnchor).isActive                                                    = true
        header.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                            = true
    }
    
    func comparisonScrollConstraints() {
        comparison.height = comparison.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Scroll.heightEmpty)
        comparison.translatesAutoresizingMaskIntoConstraints                                                        = false
        comparison.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                        = true
        comparison.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Scroll.width).isActive              = true
        comparison.height.isActive                                                                                  = true
        comparison.topAnchor.constraint(equalTo: header.bottomAnchor).isActive                                      = true
    }
    
    func menuConstraints() {
        menu.bottom = menu.bottomAnchor.constraint(equalTo: bottomAnchor)
        menu.translatesAutoresizingMaskIntoConstraints                                                              = false
        menu.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                              = true
        menu.widthAnchor.constraint(equalToConstant: UI.Sizing.Menu.width).isActive                                 = true
        menu.bottom.isActive                                                                                        = true
        menu.heightAnchor.constraint(equalToConstant: UI.Sizing.Menu.height).isActive                               = true
    }
    
}

//MARK: Header
extension Header {

    func statusBarConstraints() {
        statusBar.translatesAutoresizingMaskIntoConstraints                                                         = false
        statusBar.widthAnchor.constraint(equalToConstant: UI.Sizing.StatusBar.width).isActive                       = true
        statusBar.heightAnchor.constraint(equalToConstant: UI.Sizing.StatusBar.height).isActive                     = true
        statusBar.topAnchor.constraint(equalTo: topAnchor).isActive                                                 = true
        statusBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                         = true
    }
    
    func appNameConstraints() {
        appName.translatesAutoresizingMaskIntoConstraints                                                           = false
        appName.widthAnchor.constraint(equalToConstant: UI.Sizing.Header.appName.width).isActive                    = true
        appName.heightAnchor.constraint(equalToConstant: UI.Sizing.Header.appName.height).isActive                  = true
        appName.topAnchor.constraint(equalTo: statusBar.bottomAnchor).isActive                                      = true
        appName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                           = true
    }
    
    func valueConstraints() {
        value.top = value.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: -UI.Sizing.Summary.height)
        value.translatesAutoresizingMaskIntoConstraints                                                             = false
        value.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive                             = true
        value.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.height).isActive                           = true
        value.top.isActive                                                                                          = true
        value.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -UI.Sizing.Summary.xOffset).isActive       = true
    }
    
    func effectConstraints() {
        effect.top = effect.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: -UI.Sizing.Summary.height)
        effect.translatesAutoresizingMaskIntoConstraints                                                            = false
        effect.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive                            = true
        effect.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.height).isActive                          = true
        effect.top.isActive                                                                                         = true
        effect.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UI.Sizing.Summary.xOffset).isActive       = true
    }
    
}


//MARK: SummaryCell
extension SummaryCell {

    func categoryConstraints() {
        category.translatesAutoresizingMaskIntoConstraints                                                          = false
        category.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive                          = true
        category.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.categoryHeight).isActive                = true
        category.topAnchor.constraint(equalTo: topAnchor).isActive                                                  = true
        category.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                          = true
    }
    
    func nameConstraints() {
        nameWidth = name.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width)
        nameCenterX = name.centerXAnchor.constraint(equalTo: centerXAnchor)
        name.translatesAutoresizingMaskIntoConstraints                                                              = false
        nameWidth.isActive                                                                                          = true
        name.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.nameHeight).isActive                        = true
        name.topAnchor.constraint(equalTo: category.bottomAnchor).isActive                                          = true
        nameCenterX.isActive                                                                                        = true
    }
    
    func statConstraints() {
        stat.translatesAutoresizingMaskIntoConstraints                                                              = false
        stat.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive                              = true
        stat.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.statHeight).isActive                        = true
        stat.topAnchor.constraint(equalTo: name.bottomAnchor).isActive                                              = true
        stat.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                              = true
    }
    
    func statUnitConstraints() {
        statUnit.translatesAutoresizingMaskIntoConstraints                                                          = false
        statUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Summary.width).isActive                          = true
        statUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Summary.statUnitHeight).isActive                = true
        statUnit.topAnchor.constraint(equalTo: stat.bottomAnchor).isActive                                          = true
        statUnit.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                          = true
    }
}

//MARK: ComparisonScroll
extension ComparisonScroll {
    
    func totalConstraints() {
        total.height = total.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.height)
        total.translatesAutoresizingMaskIntoConstraints                                                             = false
        total.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                             = true
        total.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                 = true
        total.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.Comparison.padding).isActive             = true
        total.height.isActive                                                                                       = true
    }
    
    func beerConstraints () {
        beer.height = beer.heightAnchor.constraint(equalToConstant: 0.0)
        beer.top = beer.topAnchor.constraint(equalTo: total.bottomAnchor, constant: UI.Sizing.Comparison.padding)
        beer.translatesAutoresizingMaskIntoConstraints                                                              = false
        beer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                              = true
        beer.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                  = true
        beer.height.isActive                                                                                        = true
        beer.top.isActive                                                                                           = true
    }
    
    func liquorConstraints () {
        liquor.height = liquor.heightAnchor.constraint(equalToConstant: 0.0)
        liquor.translatesAutoresizingMaskIntoConstraints                                                            = false
        liquor.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                            = true
        liquor.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                = true
        liquor.height.isActive                                                                                      = true
        liquor.topAnchor.constraint(equalTo: beer.bottomAnchor, constant: UI.Sizing.Comparison.padding).isActive    = true
    }
    
    func wineConstraints () {
        wine.height = wine.heightAnchor.constraint(equalToConstant: 0.0)
        wine.translatesAutoresizingMaskIntoConstraints                                                              = false
        wine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                              = true
        wine.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                  = true
        wine.height.isActive                                                                                        = true
        wine.topAnchor.constraint(equalTo: liquor.bottomAnchor, constant: UI.Sizing.Comparison.padding).isActive    = true
    }
    
    func emptyConstraints() {
        emptyTop = empty.topAnchor.constraint(equalTo: wine.bottomAnchor)
        empty.translatesAutoresizingMaskIntoConstraints                                                             = false
        empty.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                             = true
        empty.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                 = true
        emptyTop.isActive                                                                                           = true
        empty.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Empty.height).isActive                  = true
    }
    
}

//MARK: ComparisonTotal
extension ComparisonTotal {
    
    func totalConstraints() {
        total.translatesAutoresizingMaskIntoConstraints                                                             = false
        total.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.nameWidth).isActive                = true
        total.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.height).isActive                  = true
        total.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Comparison.padding).isActive     = true
        total.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                             = true
    }
    
    func spentConstraints() {
        spent.translatesAutoresizingMaskIntoConstraints                                                             = false
        spent.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.spentWidth).isActive               = true
        spent.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.statHeight).isActive              = true
        spent.leadingAnchor.constraint(equalTo: total.trailingAnchor).isActive                                      = true
        spent.topAnchor.constraint(equalTo: topAnchor).isActive                                                     = true
    }
    
    func spentUnitConstraints() {
        let x = UI.Sizing.Comparison.Total.unitOffset
        spentUnit.translatesAutoresizingMaskIntoConstraints                                                         = false
        spentUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.shotsWidth).isActive           = true
        spentUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.statHeight).isActive          = true
        spentUnit.leadingAnchor.constraint(equalTo: total.trailingAnchor).isActive                                  = true
        spentUnit.topAnchor.constraint(equalTo: shots.bottomAnchor, constant: x).isActive                           = true
    }
    
    func shotsConstraints() {
        shots.translatesAutoresizingMaskIntoConstraints                                                             = false
        shots.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.shotsWidth).isActive               = true
        shots.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.statHeight).isActive              = true
        shots.leadingAnchor.constraint(equalTo: spent.trailingAnchor).isActive                                      = true
        shots.topAnchor.constraint(equalTo: topAnchor).isActive                                                     = true
    }
    
    func shotUnitConstraints() {
        let x = UI.Sizing.Comparison.Total.unitOffset
        shotUnit.translatesAutoresizingMaskIntoConstraints                                                          = false
        shotUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.shotsWidth).isActive            = true
        shotUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Total.statHeight).isActive           = true
        shotUnit.leadingAnchor.constraint(equalTo: spent.trailingAnchor).isActive                                   = true
        shotUnit.topAnchor.constraint(equalTo: shots.bottomAnchor, constant: x).isActive                            = true
    }
    
}

//MARK: ComparisonContainer
extension ComparisonContainer {
    
    func headerConstraints() {
        header.translatesAutoresizingMaskIntoConstraints                                                            = false
        header.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                            = true
        header.topAnchor.constraint(equalTo: topAnchor).isActive                                                    = true
        header.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                = true
        header.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.height).isActive                = true
    }
    
    func tableConstraints() {
        // why have to set height? why can't just set top and bottom anchor and height gets set from there?
        // table.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Sizing.Comparison.padding).isActive  = true
        table.height = table.heightAnchor.constraint(equalToConstant: 0.0)
        table.translatesAutoresizingMaskIntoConstraints                                                             = false
        table.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                             = true
        table.topAnchor.constraint(equalTo: header.bottomAnchor).isActive                                           = true
        table.widthAnchor.constraint(equalTo: widthAnchor).isActive                                                 = true
        table.height.isActive                                                                                       = true
    }
    
}

//MARK: ContainerHeader
extension ContainerHeader {
    
    func typeConstraints() {
        type.translatesAutoresizingMaskIntoConstraints                                                              = false
        type.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                              = true
        type.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                              = true
        type.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.contentWidth).isActive             = true
        type.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.height).isActive                  = true
    }
    
    func addConstraints() {
        add.translatesAutoresizingMaskIntoConstraints                                                               = false
        add.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                               = true
        add.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                               = true
        add.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.contentWidth).isActive              = true
        add.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Header.height).isActive                   = true
    }
    
}

//MARK: ContainerCell
extension ContainerCell {
    
    func nameConstraints() {
        name.translatesAutoresizingMaskIntoConstraints                                                              = false
        name.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.nameWidth).isActive                   = true
        name.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.height).isActive                     = true
        name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Comparison.padding).isActive      = true
        name.topAnchor.constraint(equalTo: topAnchor).isActive                                                      = true
    }
    
    func valueConstraints() {
        value.translatesAutoresizingMaskIntoConstraints                                                             = false
        value.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.valueWidth).isActive                 = true
        value.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.statHeight).isActive                = true
        value.leadingAnchor.constraint(equalTo: name.trailingAnchor).isActive                                       = true
        value.topAnchor.constraint(equalTo: topAnchor).isActive                                                     = true
    }
    
    func valueUnitConstraints() {
        let x = UI.Sizing.Comparison.Row.unitOffset
        valueUnit.translatesAutoresizingMaskIntoConstraints                                                         = false
        valueUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.valueWidth).isActive             = true
        valueUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.unitHeight).isActive            = true
        valueUnit.leadingAnchor.constraint(equalTo: name.trailingAnchor).isActive                                   = true
        valueUnit.topAnchor.constraint(equalTo: value.bottomAnchor, constant: x).isActive                           = true
    }
    
    func effectConstraints() {
        effect.translatesAutoresizingMaskIntoConstraints                                                            = false
        effect.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.effectWidth).isActive               = true
        effect.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.statHeight).isActive               = true
        effect.leadingAnchor.constraint(equalTo: value.trailingAnchor).isActive                                     = true
        effect.topAnchor.constraint(equalTo: topAnchor).isActive                                                    = true
    }
    
    func effectUnitConstraints() {
        let x = UI.Sizing.Comparison.Row.unitOffset
        effectUnit.translatesAutoresizingMaskIntoConstraints                                                        = false
        effectUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.effectWidth).isActive           = true
        effectUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Comparison.Row.unitHeight).isActive           = true
        effectUnit.leadingAnchor.constraint(equalTo: valueUnit.trailingAnchor).isActive                             = true
        effectUnit.topAnchor.constraint(equalTo: effect.bottomAnchor, constant: x).isActive                         = true
    }
    
}

//MARK: Menu
extension Menu {
    
    func showDrinkLibraryConstraints() {
        showDrinkLibrary.translatesAutoresizingMaskIntoConstraints                                                  = false
        showDrinkLibrary.widthAnchor.constraint(equalTo: widthAnchor).isActive                                      = true
        showDrinkLibrary.heightAnchor.constraint(equalToConstant: UI.Sizing.Menu.buttonHeight).isActive             = true
        showDrinkLibrary.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                  = true
        showDrinkLibrary.topAnchor.constraint(equalTo: topAnchor).isActive                                          = true
    }
    
}

//MARK: Secondary View
extension SecondaryView {
    
    func drinkLibraryConstraints() {
        drinkLibrary.translatesAutoresizingMaskIntoConstraints                                                      = false
        drinkLibrary.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                      = true
        drinkLibrary.widthAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.width).isActive                 = true
        drinkLibrary.topAnchor.constraint(equalTo: topAnchor).isActive                                              = true
        drinkLibrary.heightAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.height).isActive               = true
    }
    
}

//MARK: DrinkLibrary
extension DrinkLibrary {
    
    func headerConstraints() {
        header.translatesAutoresizingMaskIntoConstraints                                                            = false
        header.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                            = true
        header.widthAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Header.width).isActive                = true
        header.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.statusBar.height).isActive              = true
        header.heightAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Header.height).isActive              = true
    }
    
    func tableConstraints() {
        table.translatesAutoresizingMaskIntoConstraints                                                             = false
        table.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                             = true
        table.widthAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.width).isActive                        = true
        table.topAnchor.constraint(equalTo: header.bottomAnchor).isActive                                           = true
        table.heightAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Table.height).isActive                = true
    }
    
}

//MARK: Undo
extension Undo {
    
    func confirmConstraints() {
        confirm.translatesAutoresizingMaskIntoConstraints                                                           = false
        confirm.widthAnchor.constraint(equalToConstant: UI.Sizing.Undo.confirmWidth).isActive                       = true
        confirm.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                           = true
        confirm.heightAnchor.constraint(equalToConstant: UI.Sizing.Undo.confirmHeight).isActive                     = true
        confirm.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive                                      = true
    }
    
    func cancelConstraints() {
        cancel.translatesAutoresizingMaskIntoConstraints                                                            = false
        cancel.widthAnchor.constraint(equalToConstant: UI.Sizing.Undo.cancelDiameter).isActive                      = true
        cancel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding).isActive      = true
        cancel.heightAnchor.constraint(equalToConstant: UI.Sizing.Undo.cancelDiameter).isActive                     = true
        cancel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive                                       = true
    }
    
}

//MARK: TapDismiss
extension TapDismiss {
    
    func tapDismissConstraints() {
        TapDismiss.dismiss.translatesAutoresizingMaskIntoConstraints                                                = false
        TapDismiss.dismiss.widthAnchor.constraint(equalTo: widthAnchor).isActive                                    = true
        TapDismiss.dismiss.heightAnchor.constraint(equalTo: heightAnchor).isActive                                  = true
        TapDismiss.dismiss.leadingAnchor.constraint(equalTo: leadingAnchor).isActive                                = true
        TapDismiss.dismiss.topAnchor.constraint(equalTo: topAnchor).isActive                                        = true
    }
    
}

//MARK: TextEntry
extension TextEntry {
    
    func inputConstraints() {
        inputsHeight = inputs.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Input.height)
        inputs.translatesAutoresizingMaskIntoConstraints                                                            = false
        inputsHeight.isActive                                                                                       = true
        inputs.widthAnchor.constraint(equalToConstant: UI.Sizing.width).isActive                                    = true
        inputs.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                            = true
        inputs.topAnchor.constraint(equalTo: topAnchor).isActive                                                    = true
    }
    
    func navigatorConstraints() {
        TextNavigator.bottom = navigator.bottomAnchor.constraint(equalTo: bottomAnchor)
        navigator.translatesAutoresizingMaskIntoConstraints                                                         = false
        TextNavigator.bottom.isActive                                                                               = true
        navigator.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.width).isActive             = true
        navigator.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height).isActive           = true
        navigator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                         = true
    }
    
    func blurEffectConstraints() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints                                                    = false
        blurEffectView.topAnchor.constraint(equalTo: topAnchor).isActive                                            = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive                         = true
        blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -20).isActive                     = true
        blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20).isActive                    = true
    }
    
    func vibrancyEffectConstraints() {
        vibrancyView.translatesAutoresizingMaskIntoConstraints                                                      = false
        vibrancyView.topAnchor.constraint(equalTo: blurEffectView.topAnchor).isActive                               = true
        vibrancyView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: 0).isActive            = true
        vibrancyView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: -20).isActive        = true
        vibrancyView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: 20).isActive       = true
    }
    
}

//MARK: TextEntryInputs
extension TextEntryInputs {
    
    func nameConstraints() {
        name.translatesAutoresizingMaskIntoConstraints                                                              = false
        name.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.objectPadding).isActive                   = true
        name.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.height).isActive                    = true
        name.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.width).isActive                      = true
        name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding).isActive           = true
    }
    
    func abvConstraints() {
        abv.translatesAutoresizingMaskIntoConstraints                                                               = false
        abv.topAnchor.constraint(equalTo: name.bottomAnchor).isActive                                               = true
        abv.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.height).isActive                     = true
        abv.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.width).isActive                       = true
        abv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding).isActive            = true
    }
    
    func sizeConstraints() {
        size.translatesAutoresizingMaskIntoConstraints                                                              = false
        size.topAnchor.constraint(equalTo: abv.bottomAnchor).isActive                                               = true
        size.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.height).isActive                    = true
        size.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.sizeWidth).isActive                  = true
        size.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding).isActive           = true
    }
    
    func ozConstraints() {
        oz.translatesAutoresizingMaskIntoConstraints                                                                = false
        oz.topAnchor.constraint(equalTo: size.topAnchor).isActive                                                   = true
        oz.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.height).isActive                      = true
        oz.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Icon.diameter).isActive                      = true
        oz.leadingAnchor.constraint(equalTo: size.trailingAnchor, constant: 0.0).isActive                           = true
    }
    
    func mlConstraints() {
        let x = UI.Sizing.TextEntry.Icon.diameter
        ml.translatesAutoresizingMaskIntoConstraints                                                                = false
        ml.topAnchor.constraint(equalTo: size.topAnchor).isActive                                                   = true
        ml.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.height).isActive                      = true
        ml.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Icon.diameter).isActive                      = true
        ml.leadingAnchor.constraint(equalTo: size.trailingAnchor, constant: x).isActive                             = true
    }
    
    func priceConstraints() {
        price.translatesAutoresizingMaskIntoConstraints                                                             = false
        price.topAnchor.constraint(equalTo: size.bottomAnchor).isActive                                             = true
        price.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.height).isActive                   = true
        price.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.width).isActive                     = true
        price.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding).isActive          = true
    }
    
    func iconConstraints() {
        icon.translatesAutoresizingMaskIntoConstraints                                                              = false
        icon.bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive                                           = true
        icon.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Icon.diameter).isActive                   = true
        icon.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Icon.diameter).isActive                    = true
        icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding).isActive        = true
    }
    
}


//MARK: TextNavigator
extension TextNavigator {
    
    func forwardConstraints() {
        forwardBottom = forward.bottomAnchor.constraint(equalTo: bottomAnchor)
        forward.translatesAutoresizingMaskIntoConstraints                                                           = false
        forward.trailingAnchor.constraint(equalTo: trailingAnchor).isActive                                         = true
        forward.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.buttonWidth).isActive         = true
        forward.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height).isActive             = true
        forwardBottom.isActive                                                                                      = true
    }
    
    func backwardConstraints() {
        backwardBottom = backward.bottomAnchor.constraint(equalTo: bottomAnchor)
        backward.translatesAutoresizingMaskIntoConstraints                                                          = false
        backward.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                                          = true
        backward.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.buttonWidth).isActive        = true
        backward.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height).isActive            = true
        backwardBottom.isActive                                                                                     = true
    }
    
    func doneConstraints() {
        let x = UI.Sizing.TextEntry.Navigator.height
        doneBottom = done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: x)
        done.translatesAutoresizingMaskIntoConstraints                                                              = false
        done.trailingAnchor.constraint(equalTo: trailingAnchor).isActive                                            = true
        done.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.buttonWidth).isActive            = true
        done.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height).isActive                = true
        doneBottom.isActive                                                                                         = true
    }
    
    func suggestionConstraints() {
        let x = UI.Sizing.TextEntry.Navigator.height
        suggestionBottom = suggestion.bottomAnchor.constraint(equalTo: bottomAnchor, constant: x)
        suggestion.translatesAutoresizingMaskIntoConstraints                                                        = false
        suggestion.leadingAnchor.constraint(equalTo: leadingAnchor).isActive                                        = true
        suggestion.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.width).isActive                = true
        suggestion.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height).isActive          = true
        suggestionBottom.isActive                                                                                   = true
    }
    
}

