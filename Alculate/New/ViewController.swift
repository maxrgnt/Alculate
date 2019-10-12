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

class ViewController: UIViewController, SavedABVDelegate {
    
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
    var appNavigator = AppNavigator()
    
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
        let drinkNames = ["Coors","Vodka"]
        let values = ["$2.00","3.0"]
        let valueDescriptions = ["per shot","shots"]
        let topLineIcons = ["beer","beer"]
        let alignments = [.left,.right] as [NSTextAlignment]
        for (i, topLinePiece) in [valueTopLine,effectTopLine].enumerated() {
            view.addSubview(topLinePiece)
            topLinePiece.build(iconName: topLineIcons[i], alignText: alignments[i], leadingAnchors: i)
            topLinePiece.category.text = categories[i]
            topLinePiece.drinkName.text = drinkNames[i]
            topLinePiece.value.text = values[i]
            topLinePiece.valueDescription.text = valueDescriptions[i]
        }

        let headerIcons = ["beer","liquor","wine"]
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

        view.addSubview(appNavigator)
        appNavigator.build()
        appNavigator.sortDifferent.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        appNavigator.showSavedABV.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)

        view.addSubview(savedABV)
        savedABV.build()
        self.savedABV.savedABVDelegate = self
                    
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
            let keyboardDouble = UserDefaults.standard.double(forKey: "keyboard")
            UI.Sizing.keyboard = CGFloat(keyboardDouble)
//            userInput.layoutIfNeeded()
        }
        // onboarding done
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
            alculate()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // keyboard is set with approximate height prior to running (using ratio of keyboard to screen height)
            // if the keyboard has not been set, the exact height is found once keyboard is shown
            if !UserDefaults.standard.bool(forKey: "keyboardSet") {
                let keyboardRectangle = keyboardFrame.cgRectValue
                UI.Sizing.keyboard = keyboardRectangle.height
                UserDefaults.standard.set(keyboardRectangle.height, forKey: "keyboard")
                UserDefaults.standard.set(true, forKey: "keyboardSet")
            }
        }
    }

    // MARK: - App Navigator Functions
    @objc func navigateApp(sender: UIButton) {
        // Set haptic feedback
        let hapticFeedback = UINotificationFeedbackGenerator()
//        makeDeletable(false, lists: "all")
        if sender.tag >= 20 {
//            let types = ["BEER","LIQUOR","WINE"]
//            userInput.type.text = types[sender.tag-20]
//            userInput.backgroundColor = UI.Color.alcoholTypes[sender.tag-20]
//            let inputTop = -(UI.Sizing.keyboard+(UI.Sizing.headerHeight*2)+UI.Sizing.userInputRadius)
//            userInput.inputTop.constant = inputTop
//            userInput.textField.becomeFirstResponder()
        }
        else if sender.tag == 0 {
            hapticFeedback.notificationOccurred(.warning)
            flipAlculate()
        }
        else if sender.tag == 1 {
            hapticFeedback.notificationOccurred(.warning)
            savedABV.animateLeadingAnchor(constant: 0)
            appNavigator.navigatorBottom.constant = UI.Sizing.appNavigatorHeight
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func flipAlculate() {
        // Stop delete animation if animating
        makeDeletable(false, lists: "all")
        // Set lists of Data to iterate over
        var lists = [Data.beerList,Data.liquorList,Data.wineList]
        // If sorting by effect, switch to value
        if appNavigator.sortMethod == "effect" {
            appNavigator.sortMethod = "value"
            // for each ID in list below, update the appropriate list (above in lists) by sorting
            for (i, id) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
                lists[i] = lists[i].sorted { (drink1, drink2) -> Bool in
                    let value1 = calculateValue(for: drink1)
                    let value2 = calculateValue(for: drink2)
                    return value1 < value2
                }
                reloadTable(table: id)
            }
        }
        else {
            appNavigator.sortMethod = "effect"
            // for each ID in list below, update the appropriate list (above in lists) by sorting
            for (i, id) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
                lists[i] = lists[i].sorted { (drink1, drink2) -> Bool in
                    let effect1 = calculateEffect(for: drink1)
                    let effect2 = calculateEffect(for: drink2)
                    return effect1 > effect2
                }
                reloadTable(table: id)
            }
        }
        // update button title with new order by
        appNavigator.sortDifferent.setTitle("Order by \(appNavigator.sortMethod.capitalizingFirstLetter())", for: .normal)
        // update top line
        alculate()
    }
    
    // MARK: - Confirm Undo
    @objc func confirmUndo() {
//        if !masterList.tableOne.toBeDeleted.isEmpty {
//            for info in masterList.tableOne.toBeDeleted {
//                Data.masterList[info.name] = (type: info.type, abv: info.abv)
//            }
//            //let sections = NSIndexSet(indexesIn: NSMakeRange(0,masterList.tableOne.numberOfSections))
//            //masterList.tableOne.reloadSections(sections as IndexSet, with: .automatic)
//            masterList.tableOne.reloadData()
//        }
//        masterList.minimizeUndo()
    }

    // MARK: - Alculate Functions
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
        
    // MARK: - Protocol Delegate Functions
    @objc func closeUndo() {
//        for info in masterList.tableOne.toBeDeleted {
//            Data.isEditable = true
//            Data.masterList = Data.masterList
//            Data.deleteMaster(wName: info.name, wABV: info.abv, wType: info.type)
//        }
//        masterList.minimizeUndo()
    }
    
    
    func delegateHideUndo() {
        //
    }
    
    func animateAppNavigator(by percent: CGFloat, animate: Bool) {
        appNavigator.navigatorBottom.constant = UI.Sizing.appNavigatorHeight*(1-percent)
        if animate {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func displayAlert(alert : UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
     
    func offerUndo() {
//        masterList.undoBottom.constant = 0
//        masterList.undo.confirm.setTitle("Undo delete [ \(masterList.tableOne.toBeDeleted.count) ] ?", for: .normal)
    }
    
    func reloadTable(table: String) {
//        if table == Data.masterListID {
//            masterList.tableOne.reloadData()
//        }
//        else {
//            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
//            if table == Data.beerListID {
//                //beerList.reloadData()
//                beerList.reloadSections(sections as IndexSet, with: .automatic)
//            }
//            else if table == Data.liquorListID {
//                //liquorList.reloadData()
//                liquorList.reloadSections(sections as IndexSet, with: .automatic)
//            }
//            else if table == Data.wineListID {
//                //wineList.reloadData()
//                wineList.reloadSections(sections as IndexSet, with: .automatic)
//            }
//            resetAddButton()
//            alculate(for: appNavigation.alculateType)
//        }
    }
    
    func updateAppNavBottom(by percent: CGFloat, animate: Bool) {
//        appNavigation.appNavBottom.constant = UI.Sizing.appNavigationHeight*(1-percent)
//        if appNavigation.appNavBottom.constant == CGFloat(0.0) {
//
//        }
//        if animate {
//            UIView.animate(withDuration: 0.2, animations: {
//                self.view.layoutIfNeeded()
//            })
//        }
    }
    
    func makeDeletable(_ paramDeletable: Bool, lists: String) {
        var tables: [UITableView]! = []
//        if lists == "all" {
//            tables = [beerList,liquorList,wineList]
//        }
//        else if lists == Data.beerListID {
//            tables = [beerList]
//        }
//        else if lists == Data.liquorListID {
//            tables = [liquorList]
//        }
//        else if lists == Data.wineListID {
//            tables = [wineList]
//        }
        for table in tables as! [TableTwo] {
            table.varDeletable = paramDeletable
            for row in 0..<table.numberOfRows(inSection: 0) {
                let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as! TableTwoCell
                cell.nukeAllAnimations(restart: paramDeletable)
//                if deletable {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
//                       // Code you want to be delayed
//                        cell.beginDeleteAnimation()
//                    }
//                }
            }
        }
    }
}
