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
    var valueSummary = Summary()
    var effectSummary = Summary()
    var newComparison = NewComparison()
    var beerComparison = ComparisonTable()
    var liquorComparison = ComparisonTable()
    var wineComparison = ComparisonTable()
    var savedABV = SavedABV()
    var tapDismiss = TapDismiss()
    var textEntry = TextEntry()
    var subMenu = SubMenu()
    var subMenuBG = SubMenuBG()
    var undo = Undo()
    
    var noComparisons = UILabel()
    
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
        view.backgroundColor = UI.Color.alculatePurpleDarker
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        Data.deleteCoreDataFor(entity: Data.masterListID)

        //clearTestData()
        handleInit()
        build()
        alculate()
        
    }
    
    // MARK: - Initialization / Testing
    func build() {
        view.addSubview(header)
        header.build()
        
        view.addSubview(noComparisons)
        noComparisons.text = "Add a drink below."
        noComparisons.font = UI.Font.topLinePrimary
        noComparisons.textColor = UI.Color.alculatePurpleDarkest
        noComparisons.alpha = 1.0
        noComparisons.textAlignment = .center
        noComparisons.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noComparisons.heightAnchor.constraint(equalTo: view.heightAnchor),
            noComparisons.widthAnchor.constraint(equalTo: view.widthAnchor),
            noComparisons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noComparisons.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let categories = ["Value","Effect"]
        let valueDescriptions = ["per shot","shots"]
        let topLineIcons = ["",""] // ["value","effect"]
        let alignments = [.left,.right] as [NSTextAlignment]
        for (i, topLinePiece) in [valueSummary,effectSummary].enumerated() {
            view.addSubview(topLinePiece)
            topLinePiece.build(iconName: topLineIcons[i], alignText: alignments[i], leadingAnchors: i)
            topLinePiece.category.text = categories[i]
            topLinePiece.valueDescription.text = valueDescriptions[i]
        }
        valueSummary.category.textColor = UIColor(displayP3Red: 77/255, green: 169/255, blue: 68/255, alpha: 1.0)
        effectSummary.category.textColor = UIColor(displayP3Red: 206/255, green: 137/255, blue: 83/255, alpha: 1.0)
           
        view.addSubview(newComparison)
        newComparison.build(anchorTo: valueSummary)
        for obj in [newComparison.addBeer,newComparison.addLiquor,newComparison.addWine] {
            obj.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        }
        
        let listIDs = [Data.beerListID,Data.liquorListID,Data.wineListID]
        for (i, comparisonTable) in [beerComparison,liquorComparison,wineComparison].enumerated() {
            view.addSubview(comparisonTable)
            let calculatedLeading = CGFloat(i)*UI.Sizing.comparisonTableWidth
            comparisonTable.build(forType: listIDs[i], withLeading: calculatedLeading, anchorTo: newComparison)
        }
        self.beerComparison.comparisonTableDelegate = self
        self.liquorComparison.comparisonTableDelegate = self
        self.wineComparison.comparisonTableDelegate = self
        
        view.addSubview(subMenuBG)
        subMenuBG.build()
        
        view.addSubview(savedABV)
        savedABV.build()
        self.savedABV.savedABVDelegate = self
        self.savedABV.savedABVTable.savedABVTableDelegate = self
            
        view.addSubview(undo)
        undo.build()
        undo.confirm.addTarget(self, action: #selector(confirmUndo), for: .touchUpInside)
        undo.cancel.addTarget(self, action: #selector(cancelUndo), for: .touchUpInside)
        
        view.addSubview(subMenu)
        subMenu.build()
        for obj in [subMenu.showSavedABV] {
            obj.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        }
        
        view.addSubview(tapDismiss)
        tapDismiss.build()
        
        view.addSubview(textEntry)
        textEntry.build()
        self.textEntry.textEntryDelegate = self
    }
    
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
            Data.txtFile()
            Data.loadList(for: Data.masterListID)
        }
        else {
            // normal run
            for list in [Data.masterListID,Data.beerListID,Data.liquorListID,Data.wineListID] {
                Data.loadList(for: list)
            }
            sortByValue()
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
//            flipAlculate()
        }
        else if sender.tag == 1 {
            savedABV.animateLeadingAnchor(constant: 0)
            subMenu.top.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Show Text Entry
    func showTextEntry(forType id: String, fullView: Bool, forLevel level: Int? = 0) {
        TapDismiss.dismissTop.constant = 0
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
        let constant = (onScreen == false) ? 0 : -UI.Sizing.subMenuHeight
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
                lists.append((arr: listPiece.last!, ind: index))
            }
        }
        // if list of top item from each type has items, compare those against themselves
        if !lists.isEmpty {
            valueSummary.moveTopAnchor(to: UI.Sizing.topLineTop)
            effectSummary.moveTopAnchor(to: UI.Sizing.topLineTop)
            noComparisons.alpha = 0.0
            //
            let info = lists.last!.arr
            bestPrice = (name: info.name,
                         best: String(format: "%.2f", calculateValue(for: info)),
                         ind: lists.last!.ind)
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
                           ind: lists.last!.ind)
            for listPiece in lists {
                let tryBest = calculateEffect(for: listPiece.arr)
                if tryBest > Double(bestRatio.best)! {
                    bestRatio = (name: listPiece.arr.name,
                                   best: String(format: "%.1f", tryBest),
                                   ind: listPiece.ind)
                }
            }
            valueSummary.drinkName.text = bestPrice.name.capitalized
            valueSummary.value.text = "$"+bestPrice.best
            effectSummary.drinkName.text = bestRatio.name.capitalized
            effectSummary.value.text = bestRatio.best
        }
        // if all lists are empty, dont alculate
        else {
            valueSummary.moveTopAnchor(to: -UI.Sizing.subMenuHeight)
            effectSummary.moveTopAnchor(to: -UI.Sizing.subMenuHeight)
            noComparisons.alpha = 1.0
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
//        (subMenu.sortMethod == "effect") ? sortByValue() : sortByEffect()
//        subMenu.sortMethod = (subMenu.sortMethod == "effect") ? "value" : "effect"
        // update button title with new order by
//        subMenu.sortDifferent.setTitle("Order by \(subMenu.sortMethod.capitalized)", for: .normal)
        // update top line
        alculate()
    }
    
    func sortByValue() {
        Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) > calculateValue(for: drink2)
        }
        reloadTable(table: Data.beerListID)
        //
        Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) > calculateValue(for: drink2)
        }
        reloadTable(table: Data.liquorListID)
        //
        Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) > calculateValue(for: drink2)
        }
        reloadTable(table: Data.wineListID)
    }
    
    func sortByEffect() {
        Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) < calculateEffect(for: drink2)
        }
        reloadTable(table: Data.beerListID)
        //
        Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) < calculateEffect(for: drink2)
        }
        reloadTable(table: Data.liquorListID)
        //
        Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) < calculateEffect(for: drink2)
        }
        reloadTable(table: Data.wineListID)
    }
        
    // MARK: - Protocol Delegate Functions
    func animateSubMenu(by percent: CGFloat, reset: Bool) {
        subMenu.top.constant = -UI.Sizing.subMenuHeight*(percent)
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
        textEntry.navigator.backwardBottom.constant = UI.Sizing.subMenuHeight
    }
    
    func adjustHeaderBackground() {
        if let cell = savedABV.savedABVTable.cellForRow(at: savedABV.savedABVTable.indexPathsForVisibleRows![0]) {
            savedABV.header.backgroundColor = cell.backgroundColor
            savedABV.statusBar.backgroundColor = cell.backgroundColor
        }
    }
    
    func editComparison(type: String, name: String, abv: String, size: String, price: String) {
        // reset output to saved data
        textEntry.outputFromComparison(name: name, abv: abv, size: size, price: price)
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: true)
    }
    
    func reloadTable(table: String) {
        if table == Data.masterListID {
            savedABV.savedABVTable.reloadData()
        }
        else {
            print("gotcha bitch")
            alculate()
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            let tables = [beerComparison,liquorComparison,wineComparison]
            for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
                if table == ID {
                    //tables[i].reloadData()
                    tables[i].reloadSections(sections as IndexSet, with: .automatic)
                }
            }
        }
    }
    
    func updateComparison(for name: String, ofType type: String, wABV newAbv: String) {
        let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
        let tables = [beerComparison,liquorComparison,wineComparison]
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            if type == ID {
                for x in 0..<lists[i].count {
                    if lists[i][x].name == name {
                        let abv = lists[i][x].abv
                        let size = lists[i][x].size
                        let price = lists[i][x].price
                        Data.deleteFromList(type, wName: name, wABV: abv, wSize: size, wPrice: price)
                        Data.saveToList(type, wName: name, wABV: newAbv, wSize: size, wPrice: price)
                        alculate()
                        tables[i].reloadSections(sections as IndexSet, with: .automatic)
                    }
                }
            }
        }
        
    }
    
    func insertRowFor(table: String) {
        let tables = [beerComparison,liquorComparison,wineComparison]
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            if table == ID {
                tables[i].beginUpdates()
                tables[i].insertRows(at: [IndexPath(row: lists[i].count-1, section: 0)], with: .bottom)
                tables[i].endUpdates()
                tables[i].updateTableContentInset()
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
