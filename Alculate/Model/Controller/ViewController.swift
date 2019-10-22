//
//  ViewController2.swift
//  Alculate
//
//  Created by Max Sergent on 10/12/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit
import CoreData

// Setting protocol?
// Don't forget self.OBJECT.DELEGATE = self

class ViewController: UIViewController, SavedABVDelegate, SavedABVTableDelegate, ComparisonTableDelegate, TextEntryDelegate {
    
    // Constraints
    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!
    
    // Objects
    var header = Header()
    var valueTopLine = TopLinePiece()
    var effectTopLine = TopLinePiece()
    var beerHeader = ComparisonHeader()
    var liquorHeader = ComparisonHeader()
    var wineHeader = ComparisonHeader()
    var beerComparison = ComparisonTable()
    var liquorComparison = ComparisonTable()
    var wineComparison = ComparisonTable()
    var savedABV = SavedABV()
    var textEntry = TextEntry()
    var appNavigator = AppNavigator()
    var undo = Undo()
    
    override func viewDidLoad() {
        // MARK: - View/Object Settings
        // Add keyboard observer to retrieve keyboard height when keyboard shown
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil
        )
        //
        ViewController.leadingAnchor = view.leadingAnchor
        ViewController.topAnchor = view.topAnchor
        ViewController.trailingAnchor = view.trailingAnchor
        ViewController.bottomAnchor = view.bottomAnchor
        //
        view.backgroundColor = UI.Color.alculatePurpleDark

        view.addSubview(header)
        header.build()
        
        let categories = ["Most Value","Most Effective"]
        let valueDescriptions = ["per shot","shots"]
        let topLineIcons = ["value","effect"]
        let alignments = [.left,.right] as [NSTextAlignment]
        for (i, topLinePiece) in [valueTopLine,effectTopLine].enumerated() {
            view.addSubview(topLinePiece)
            topLinePiece.build(iconName: topLineIcons[i], alignText: alignments[i], leadingAnchors: i)
            topLinePiece.category.text = categories[i]
            topLinePiece.valueDescription.text = valueDescriptions[i]
        }

        let headerIcons = [Data.beerListID,Data.liquorListID,Data.wineListID]
        for (i, comparisonHeader) in [beerHeader,liquorHeader,wineHeader].enumerated() {
            view.addSubview(comparisonHeader)
            let calculatedLeading = CGFloat(i)*UI.Sizing.comparisonTableWidth
            comparisonHeader.build(iconName: headerIcons[i], leadingConstant: calculatedLeading)
        }

        let listIDs = [Data.beerListID,Data.liquorListID,Data.wineListID]
        for (i, comparisonTable) in [beerComparison,liquorComparison,wineComparison].enumerated() {
            view.addSubview(comparisonTable)
            let calculatedLeading = CGFloat(i)*UI.Sizing.comparisonTableWidth
            comparisonTable.build(forType: listIDs[i], withLeading: calculatedLeading)
        }
        self.beerComparison.comparisonTableDelegate = self
        self.liquorComparison.comparisonTableDelegate = self
        self.wineComparison.comparisonTableDelegate = self
        
        view.addSubview(savedABV)
        savedABV.build()
        self.savedABV.savedABVDelegate = self
        self.savedABV.savedABVTable.savedABVTableDelegate = self
            
        view.addSubview(undo)
        undo.build()
        undo.confirm.addTarget(self, action: #selector(confirmUndo), for: .touchUpInside)
        undo.cancel.addTarget(self, action: #selector(cancelUndo), for: .touchUpInside)

        view.addSubview(appNavigator)
        appNavigator.build()
        for obj in [appNavigator.addBeer,appNavigator.addLiquor,appNavigator.addWine,
                    appNavigator.sortDifferent,appNavigator.showSavedABV] {
                        obj.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        }
        
        view.addSubview(textEntry)
        textEntry.build()
        self.textEntry.textEntryDelegate = self
        
        //clearTestData()
        handleInit()
    }
    
    // MARK: - Initialization / Testing
    func clearTestData(){
        Data.deleteCoreDataFor(entity: Data.masterListID)
        Data.deleteCoreDataFor(entity: Data.beerListID)
        Data.deleteCoreDataFor(entity: Data.liquorListID)
        Data.deleteCoreDataFor(entity: Data.wineListID)
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    func handleInit() {
        // keyboard height
        let keyboardSet = UserDefaults.standard.bool(forKey: "keyboardSet")
        print("keyboardSet: \(keyboardSet)")
        if UserDefaults.standard.bool(forKey: "keyboardSet") {
            let keyboardHeight = UserDefaults.standard.double(forKey: "keyboard")
            UI.Sizing.keyboard = CGFloat(keyboardHeight)
            let keyboardDuration = UserDefaults.standard.double(forKey: "keyboardDuration")
            UI.Keyboard.duration = keyboardDuration
            let keyboardCurve = UserDefaults.standard.double(forKey: "keyboardCurve")
            UI.Keyboard.curve = UInt(keyboardCurve)
        }
        // check onboarding
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        print("hasLaunchedBefore: \(hasLaunched)")
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // onboarding
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        else {
            // normal run
            for list in [Data.masterListID,Data.beerListID,Data.liquorListID,Data.wineListID] {
                Data.loadList(for: list)
            }
            print("Master: ",Data.masterList)
            alculate()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // keyboard is set with approximate height prior to running (using ratio of keyboard to screen height)
            // if the keyboard has not been set, the exact height is found once keyboard is shown
            if !UserDefaults.standard.bool(forKey: "keyboardSet") {
                let keyboardRectangle = keyboardFrame.cgRectValue
                UserDefaults.standard.set(keyboardRectangle.height, forKey: "keyboard")
                UI.Sizing.keyboard = keyboardRectangle.height
                UserDefaults.standard.set(duration, forKey: "keyboardDuration")
                UI.Keyboard.duration = duration
                UserDefaults.standard.set(curve, forKey: "keyboardCurve")
                UI.Keyboard.curve = curve
                UserDefaults.standard.set(true, forKey: "keyboardSet")
            }
        }
    }

    // MARK: - App Navigator Functions
    @objc func navigateApp(sender: UIButton) {
//        let hapticFeedback = UINotificationFeedbackGenerator()
//        hapticFeedback.notificationOccurred(.warning)
        makeDeletable(false, lists: "all")
        if sender.tag >= 20 {
            let iconNames = [Data.beerListID,Data.liquorListID,Data.wineListID]
            showTextEntry(forType: iconNames[sender.tag-20], fullView: true)
        }
        else if sender.tag == 0 {
            flipAlculate()
        }
        else if sender.tag == 1 {
            savedABV.animateLeadingAnchor(constant: 0)
            appNavigator.top.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Show Text Entry
    func showTextEntry(forType id: String, fullView: Bool, forLevel level: Int? = 0) {
        // set entry id
        textEntry.entryID = id
        // set max level
        textEntry.maxLevel = (fullView==true) ? 3 : 1
        // reset components for first level (name)
        textEntry.setComponents(forLevel: level!)
        // set icon for given type
        textEntry.inputs.icon.image = UIImage(named: id)
        // show keyboard
        textEntry.field.becomeFirstResponder()
        // hide non-essential pieces if partial
        for obj in [textEntry.inputs.size,textEntry.inputs.oz,textEntry.inputs.ml,textEntry.inputs.price] {
            obj.isHidden = (fullView==true) ? false : true
        }
        // adjust height of input view to make space for text navigator if partial
        textEntry.inputsHeight.constant = (fullView==true)
            ? UI.Sizing.textEntryInputsHeight
            : UI.Sizing.textEntryInputsHeightPartial
        // move app navigator up in input view if partial
        TextNavigator.bottom.constant = (fullView==true)
            ? -UI.Sizing.keyboard
            : -UI.Sizing.keyboard-(2*UI.Sizing.textEntryFieldHeight)
        // set top of text entry to whether full (compare) or partial (savedABV)
        let topConstant = (fullView==true) ? UI.Sizing.textEntryTop : UI.Sizing.textEntryTopPartial
        textEntry.animateTopAnchor(constant: topConstant)
    }
    
    // MARK: - Hide Text Entry
    // Have to do as seperate function here because this called by UIButton, no parameters
    @objc func hideTextEntry() {
        // handle data here
    }
        
    // MARK: - Undo Logic
    @objc func confirmUndo() {
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        // if toBeDeleted is not empty
        if !savedABV.savedABVTable.toBeDeleted.isEmpty {
            // for every object in toBeDeleted, add it back to the Data master list
            for info in savedABV.savedABVTable.toBeDeleted {
                Data.masterList[info.name] = (type: info.type, abv: info.abv)
            }
            savedABV.savedABVTable.reloadData()
        }
        animateUndo(onScreen: false)
    }
    
    @objc func cancelUndo() {
        removeABVfromCoreData()
        animateUndo(onScreen: false)
    }
    
    func removeABVfromCoreData() {
        // iterate over every object in the toBeDeleted table
        for info in savedABV.savedABVTable.toBeDeleted {
            // make the database editable
            Data.isEditable = true
            // update the database to match the list with now deleted values
            Data.masterList = Data.masterList
            // delete objects in toBeDeleted from coreData
            Data.deleteMaster(wName: info.name, wABV: info.abv, wType: info.type)
        }
    }
    
    @objc func animateUndo(onScreen: Bool = true) {
        let constant = (onScreen == false) ? 0 : -UI.Sizing.appNavigatorHeight
        undo.top.constant = constant
        UIView.animate(withDuration: 0.55, delay: 0.0,usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut,.allowUserInteraction],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: {(value: Bool) in
            // pass
           })
    }
    
    // MARK: - Alculate Logic
    func alculate() {
        // create framework of array of lists that are not empty
        var lists: [(arr: (name: String, abv: String, size: String, price: String), ind: Int)]! = []
        // create framework of best alcohol of top items from each list
        var bestPrice: (name: String, best: String, ind: Int)!
        var bestRatio: (name: String, best: String, ind: Int)!
        // iterate through each type list to see if empty
        for (index, listPiece) in [Data.beerList,Data.liquorList,Data.wineList].enumerated() {
            // if the list is not empty, add the top item to lists to be compared (already sorted)
            if !listPiece.isEmpty {
                lists.append((arr: listPiece[0], ind: index))
            }
        }
        // if list of top item from each type has items, compare those against themselves
        if !lists.isEmpty {
            let info = lists[0].arr
            bestPrice = (name: info.name,
                         best: String(format: "%.2f", calculateValue(for: info)),
                         ind: lists[0].ind)
            for listPiece in lists {
                let tryBest = calculateValue(for: listPiece.arr)
                if tryBest < Double(bestPrice.best)! {
                    bestPrice = (name: listPiece.arr.name,
                                   best: String(format: "%.2f", tryBest),
                                   ind: listPiece.ind)
                }
            }
            bestRatio = (name: info.name,
                           best: String(format: "%.1f", calculateEffect(for: info)),
                           ind: lists[0].ind)
            for listPiece in lists {
                let tryBest = calculateEffect(for: listPiece.arr)
                if tryBest > Double(bestRatio.best)! {
                    bestRatio = (name: listPiece.arr.name,
                                   best: String(format: "%.1f", tryBest),
                                   ind: listPiece.ind)
                }
            }
            valueTopLine.drinkName.text = bestPrice.name.capitalizingFirstLetter()
            valueTopLine.value.text = "$"+bestPrice.best
            effectTopLine.drinkName.text = bestRatio.name.capitalizingFirstLetter()
            effectTopLine.value.text = bestRatio.best
        }
        // if all lists are empty, dont alculate
        else {
            for label in [valueTopLine.drinkName,valueTopLine.value,effectTopLine.drinkName,effectTopLine.value] {
                label.text = "?"
            }
        }
    }
    
    func calculateEffect(for info: (name: String, abv: String, size: String, price: String)) -> Double {
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        var correctedSize = Double(info.size.dropLast(2))!
        correctedSize = sizeUnit == "ml" ? correctedSize/29.5735296875 : correctedSize
        return ((Double(info.abv)!*0.01)*correctedSize)/0.6
    }
    
    func calculateValue(for info: (name: String, abv: String, size: String, price: String)) -> Double {
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        var correctedSize = Double(info.size.dropLast(2))!
        correctedSize = sizeUnit == "ml" ? correctedSize/29.5735296875 : correctedSize
        let price = Double(info.price)! >= 0 ? Double(info.price)! : 1
        return price/(((Double(info.abv)!*0.01)*correctedSize)/0.6)
    }
    
    // MARK: - Flip Alculate
    func flipAlculate() {
        // If sorting by effect, switch to value and vice versa
        (appNavigator.sortMethod == "effect") ? sortByValue() : sortByEffect()
        appNavigator.sortMethod = (appNavigator.sortMethod == "effect") ? "value" : "effect"
        // update button title with new order by
        appNavigator.sortDifferent.setTitle("Order by \(appNavigator.sortMethod.capitalizingFirstLetter())", for: .normal)
        // update top line
        alculate()
    }
    
    func sortByValue() {
        Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) < calculateValue(for: drink2)
        }
        reloadTable(table: Data.beerListID)
        //
        Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) < calculateValue(for: drink2)
        }
        reloadTable(table: Data.liquorListID)
        //
        Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) < calculateValue(for: drink2)
        }
        reloadTable(table: Data.wineListID)
    }
    
    func sortByEffect() {
        Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) > calculateEffect(for: drink2)
        }
        reloadTable(table: Data.beerListID)
        //
        Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) > calculateEffect(for: drink2)
        }
        reloadTable(table: Data.liquorListID)
        //
        Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) > calculateEffect(for: drink2)
        }
        reloadTable(table: Data.wineListID)
    }
        
    // MARK: - Protocol Delegate Functions
    func animateAppNavigator(by percent: CGFloat, reset: Bool) {
        appNavigator.top.constant = -UI.Sizing.appNavigatorHeight*(percent)
        // remove undo if it is on screen
        if undo.top.constant != 0 {
            undo.top.constant = (reset == false) ? (-UI.Sizing.undoHeight)*(1-percent) : -UI.Sizing.undoHeight
            if undo.top.constant == -UI.Sizing.undoHeight {
                removeABVfromCoreData()
            }
        }
        UIView.animate(withDuration: 0.55, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut], animations: { //Do all animations here
                        self.view.layoutIfNeeded()
        })
    }
    
    func displayAlert(alert : UIAlertController) {
        textEntry.field.resignFirstResponder()
        present(alert, animated: true, completion: nil)
    }
    
    func editSavedABV(name: String, abv: String, type: String) {
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: false)
        // reset output to saved data
        textEntry.outputFromSavedABV(name: name, abv: abv)
        textEntry.changeInputLevel(sender: textEntry.navigator.forward)
        // hide back and done buttons
        textEntry.navigator.backwardBottom.constant = UI.Sizing.appNavigatorHeight
    }
    
    func reloadTable(table: String) {
        if table == Data.masterListID {
            savedABV.savedABVTable.reloadData()
        }
        else {
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            let tables = [beerComparison,liquorComparison,wineComparison]
            for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
                if table == ID {
                    //tables[i].reloadData()
                    tables[i].reloadSections(sections as IndexSet, with: .automatic)
                }
            }
            alculate()
        }
    }
    
    func insertRowFor(table: String) {
        let tables = [beerComparison,liquorComparison,wineComparison]
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            if table == ID {
                tables[i].beginUpdates()
                tables[i].insertRows(at: [IndexPath(row: lists[i].count-1, section: 0)], with: .automatic)
                tables[i].endUpdates()
            }
        }
        alculate()
    }
    
    func makeDeletable(_ paramDeletable: Bool, lists: String) {
        var tables: [UITableView]! = []
        let possibleTables = [[beerComparison],[liquorComparison],[wineComparison],
                              [beerComparison,liquorComparison,wineComparison]]
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID,"all"].enumerated() {
            if lists == ID {
                tables = possibleTables[i]
            }
        }
        for table in tables as! [ComparisonTable] {
            for row in 0..<table.numberOfRows(inSection: 0) {
                let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as! ComparisonCell
                cell.stopAnimating(restartAnimations: paramDeletable)
            }
        }
    }
}
