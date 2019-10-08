//
//  ViewController.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, InputDelegate, TableTwoDelegate, TableOneDelegate, MasterListDelegate {
     
    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!

    var statusBar = StatusBar()
    var header = Header()
    var topLine = TopLine()
    var beerList = TableTwo()
    var liquorList = TableTwo()
    var wineList = TableTwo()
    var appNavigation = AppNavigation()
    var masterList = MasterList()
    var userInput = Input()
    
    var bestAlcoholInd: Int = 3
    
    override func viewDidLoad() {
        
        // Add keyboard observer to retrieve keyboard height when keyboard shown
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil
        )
        
        ViewController.leadingAnchor = view.leadingAnchor
        ViewController.topAnchor = view.topAnchor
        ViewController.trailingAnchor = view.trailingAnchor
        ViewController.bottomAnchor = view.bottomAnchor
        
        for subview in [statusBar, header, topLine, beerList, liquorList, wineList, masterList, appNavigation, userInput] {
            view.addSubview(subview)
        }
        
        header.build()
        //
        topLine.build()
        //
        beerList.build(forType: "BEER")
        self.beerList.tableTwoDelegate = self
        beerList.tableTwoLeading.constant = 0
        //
        liquorList.build(forType: "LIQUOR")
        self.liquorList.tableTwoDelegate = self
        liquorList.tableTwoLeading.constant = UI.Sizing.width*(1/3)
        //
        wineList.build(forType: "WINE")
        self.wineList.tableTwoDelegate = self
        wineList.tableTwoLeading.constant = UI.Sizing.width*(2/3)
        //
        appNavigation.build()
        appNavigation.left.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        appNavigation.beer.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        appNavigation.liquor.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        appNavigation.wine.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        appNavigation.right.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        //
        userInput.build()
        self.userInput.inputDelegate = self
        //
        masterList.build()
        self.masterList.masterListDelegate = self
        self.masterList.tableOne.tableOneDelegate = self
        masterList.undo.close.addTarget(self, action: #selector(closeUndo), for: .touchUpInside)
        masterList.undo.confirm.addTarget(self, action: #selector(confirmUndo), for: .touchUpInside)
            
        //clearTestData()
        handleInit()
        print(Data.masterList)
        print(Data.beerList)
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
            let keyboardDouble = UserDefaults.standard.double(forKey: "keyboard")
            UI.Sizing.keyboard = CGFloat(keyboardDouble)
            userInput.layoutIfNeeded()
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
            alculate(for: "price")
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

    @objc func navigateApp(sender: UIButton) {
        makeDeletable(false, lists: "all")
        if sender.tag >= 20 {
            let types = ["BEER","LIQUOR","WINE"]
            userInput.type.text = types[sender.tag-20]
            userInput.backgroundColor = UI.Color.alcoholTypes[sender.tag-20]
            let inputTop = -(UI.Sizing.keyboard+(UI.Sizing.headerHeight*2)+UI.Sizing.userInputRadius)
            userInput.inputTop.constant = inputTop
            userInput.textField.becomeFirstResponder()
        }
        else if sender.tag == 0 {
            resetAddButton()
            flipAlculate()
        }
        else if sender.tag == 2 {
            resetAddButton()
            masterList.animateLeadingAnchor(constant: 0)
            appNavigation.appNavBottom.constant = UI.Sizing.appNavigationHeight
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func flipAlculate() {
        makeDeletable(false, lists: "all")
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        if appNavigation.alculateType == "ratio" {
            appNavigation.alculateType = "price"
            for tableTwo in [beerList,liquorList,wineList] {
                tableTwo.alculateType = "price"
            }
            appNavigation.left.setTitle("$/%", for: .normal)
            Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
                let sizeUnit1 = drink1.size.dropFirst(drink1.size.count-2)
                var correctedSize1 = Double(drink1.size.dropLast(2))!
                if sizeUnit1 == "ml" {
                    correctedSize1 = correctedSize1/29.5735296875
                }
                let sizeUnit2 = drink2.size.dropFirst(drink2.size.count-2)
                var correctedSize2 = Double(drink2.size.dropLast(2))!
                if sizeUnit2 == "ml" {
                    correctedSize2 = correctedSize2/29.5735296875
                }
                let calc1 = (Double(drink1.abv)!*correctedSize1)/0.6
                let calc2 = (Double(drink2.abv)!*correctedSize2)/0.6
                return Double(drink1.price)!/calc1 < Double(drink2.price)!/calc2
                }
            reloadTable(table: Data.beerListID)
            Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
                let sizeUnit1 = drink1.size.dropFirst(drink1.size.count-2)
                var correctedSize1 = Double(drink1.size.dropLast(2))!
                if sizeUnit1 == "ml" {
                    correctedSize1 = correctedSize1/29.5735296875
                }
                let sizeUnit2 = drink2.size.dropFirst(drink2.size.count-2)
                var correctedSize2 = Double(drink2.size.dropLast(2))!
                if sizeUnit2 == "ml" {
                    correctedSize2 = correctedSize2/29.5735296875
                }
                let calc1 = (Double(drink1.abv)!*correctedSize1)/0.6
                let calc2 = (Double(drink2.abv)!*correctedSize2)/0.6
                return Double(drink1.price)!/calc1 < Double(drink2.price)!/calc2
                }
            reloadTable(table: Data.liquorListID)
            Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
                let sizeUnit1 = drink1.size.dropFirst(drink1.size.count-2)
                var correctedSize1 = Double(drink1.size.dropLast(2))!
                if sizeUnit1 == "ml" {
                    correctedSize1 = correctedSize1/29.5735296875
                }
                let sizeUnit2 = drink2.size.dropFirst(drink2.size.count-2)
                var correctedSize2 = Double(drink2.size.dropLast(2))!
                if sizeUnit2 == "ml" {
                    correctedSize2 = correctedSize2/29.5735296875
                }
                let calc1 = (Double(drink1.abv)!*correctedSize1)/0.6
                let calc2 = (Double(drink2.abv)!*correctedSize2)/0.6
                return Double(drink1.price)!/calc1 < Double(drink2.price)!/calc2
                }
            reloadTable(table: Data.wineListID)
        }
        else {
            appNavigation.alculateType = "ratio"
            for tableTwo in [beerList,liquorList,wineList] {
                tableTwo.alculateType = "ratio"
            }
            appNavigation.left.setTitle("%/$", for: .normal)
            Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
                let sizeUnit1 = drink1.size.dropFirst(drink1.size.count-2)
                var correctedSize1 = Double(drink1.size.dropLast(2))!
                if sizeUnit1 == "ml" {
                    correctedSize1 = correctedSize1/29.5735296875
                }
                let sizeUnit2 = drink2.size.dropFirst(drink2.size.count-2)
                var correctedSize2 = Double(drink2.size.dropLast(2))!
                if sizeUnit2 == "ml" {
                    correctedSize2 = correctedSize2/29.5735296875
                }
                let calc1 = (Double(drink1.abv)!*correctedSize1)/0.6
                let calc2 = (Double(drink2.abv)!*correctedSize2)/0.6
                return calc1 > calc2
                }
            reloadTable(table: Data.beerListID)
            Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
                let sizeUnit1 = drink1.size.dropFirst(drink1.size.count-2)
                var correctedSize1 = Double(drink1.size.dropLast(2))!
                if sizeUnit1 == "ml" {
                    correctedSize1 = correctedSize1/29.5735296875
                }
                let sizeUnit2 = drink2.size.dropFirst(drink2.size.count-2)
                var correctedSize2 = Double(drink2.size.dropLast(2))!
                if sizeUnit2 == "ml" {
                    correctedSize2 = correctedSize2/29.5735296875
                }
                let calc1 = (Double(drink1.abv)!*correctedSize1)/0.6
                let calc2 = (Double(drink2.abv)!*correctedSize2)/0.6
                return calc1 > calc2
                }
            reloadTable(table: Data.liquorListID)
            Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
                let sizeUnit1 = drink1.size.dropFirst(drink1.size.count-2)
                var correctedSize1 = Double(drink1.size.dropLast(2))!
                if sizeUnit1 == "ml" {
                    correctedSize1 = correctedSize1/29.5735296875
                }
                let sizeUnit2 = drink2.size.dropFirst(drink2.size.count-2)
                var correctedSize2 = Double(drink2.size.dropLast(2))!
                if sizeUnit2 == "ml" {
                    correctedSize2 = correctedSize2/29.5735296875
                }
                let calc1 = (Double(drink1.abv)!*correctedSize1)/0.6
                let calc2 = (Double(drink2.abv)!*correctedSize2)/0.6
                return calc1 > calc2
                }
            reloadTable(table: Data.wineListID)
        }
        alculate(for: appNavigation.alculateType)
    }
    
    func updateAppNavBottom(by percent: CGFloat, animate: Bool) {
        appNavigation.appNavBottom.constant = UI.Sizing.appNavigationHeight*(1-percent)
        if appNavigation.appNavBottom.constant == CGFloat(0.0) {
            print(bestAlcoholInd)
            view.backgroundColor = UI.Color.alcoholTypes[bestAlcoholInd]
        }
        if animate {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func resetAddButton() {
        if appNavigation.selectingType {
            appNavigation.presentAlcoholTypes()
        }
    }
    
    func resetDeleteButton() {
        beerList.willDelete = false
        liquorList.willDelete = false
        wineList.willDelete = false
        appNavigation.left.setTitle("X", for: .normal)
    }
    
    func displayAlert(alert : UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
     
    func offerUndo() {
        masterList.undoBottom.constant = 0
        masterList.undo.confirm.setTitle("Undo delete [ \(masterList.tableOne.toBeDeleted.count) ] ?", for: .normal)
    }
    
    @objc func closeUndo() {
        for info in masterList.tableOne.toBeDeleted {
            Data.isEditable = true
            Data.masterList = Data.masterList
            Data.deleteMaster(wName: info.name, wABV: info.abv, wType: info.type)
        }
        masterList.minimizeUndo()
    }
    
    @objc func confirmUndo() {
        if !masterList.tableOne.toBeDeleted.isEmpty {
            for info in masterList.tableOne.toBeDeleted {
                Data.masterList[info.name] = (type: info.type, abv: info.abv)
            }
            //let sections = NSIndexSet(indexesIn: NSMakeRange(0,masterList.tableOne.numberOfSections))
            //masterList.tableOne.reloadSections(sections as IndexSet, with: .automatic)
            masterList.tableOne.reloadData()
        }
        masterList.minimizeUndo()
    }
    
    func reloadTable(table: String) {
        if table == Data.masterListID {
            masterList.tableOne.reloadData()
        }
        else {
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            if table == Data.beerListID {
                //beerList.reloadData()
                beerList.reloadSections(sections as IndexSet, with: .automatic)
            }
            else if table == Data.liquorListID {
                //liquorList.reloadData()
                liquorList.reloadSections(sections as IndexSet, with: .automatic)
            }
            else if table == Data.wineListID {
                //wineList.reloadData()
                wineList.reloadSections(sections as IndexSet, with: .automatic)
            }
            resetAddButton()
            alculate(for: appNavigation.alculateType)
        }
    }
    
    func makeDeletable(_ paramDeletable: Bool, lists: String) {
        var tables: [UITableView]! = []
        if lists == "all" {
            tables = [beerList,liquorList,wineList]
        }
        else if lists == Data.beerListID {
            tables = [beerList]
        }
        else if lists == Data.liquorListID {
            tables = [liquorList]
        }
        else if lists == Data.wineListID {
            tables = [wineList]
        }
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

    func alculate(for type: String) {
        // create framework of top item from first list
        var info: (name: String, abv: String, size: String, price: String)!
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
            info = lists[0].arr
            bestPrice = (name: info.name,
                           best: String(format: "%.2f", findBestPrice(for: (abv: info.abv, size: info.size, price: info.price))),
                           ind: lists[0].ind)
            for listPiece in lists {
                let tryBest = findBestPrice(for: (abv: listPiece.arr.abv, size: listPiece.arr.size, price: listPiece.arr.price))
                if tryBest < Double(bestPrice.best)! {
                    bestPrice = (name: listPiece.arr.name,
                                   best: String(format: "%.2f", tryBest),
                                   ind: listPiece.ind)
                }
            }
            bestRatio = (name: info.name,
                           best: String(format: "%.1f", findBestRatio(for: (abv: info.abv, size: info.size))),
                           ind: lists[0].ind)
            for listPiece in lists {
                let tryBest = findBestRatio(for: (abv: listPiece.arr.abv, size: listPiece.arr.size))
                if tryBest > Double(bestRatio.best)! {
                    bestRatio = (name: listPiece.arr.name,
                                   best: String(format: "%.1f", tryBest),
                                   ind: listPiece.ind)
                }
            }
            topLine.bestPriceName.text = bestPrice.name.capitalizingFirstLetter()
            topLine.bestPriceStat.text = "$"+bestPrice.best
            topLine.bestCountName.text = bestRatio.name.capitalizingFirstLetter()
            topLine.bestCountStat.text = bestRatio.best+"x"
            if type == "price" {
                topLine.bestCountName.alpha = 0.4
                topLine.bestCountStat.alpha = 0.4
                topLine.bestPriceName.alpha = 1
                topLine.bestPriceStat.alpha = 1
                bestAlcoholInd = bestPrice.ind
            }
            else {
                topLine.bestPriceName.alpha = 0.4
                topLine.bestPriceStat.alpha = 0.4
                topLine.bestCountName.alpha = 1
                topLine.bestCountStat.alpha = 1
                bestAlcoholInd = bestRatio.ind
            }
            view.backgroundColor = UI.Color.alcoholTypes[bestAlcoholInd]
            Header.gradient.colors = [UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                                UI.Color.alculatePurpleLite.withAlphaComponent(1.0).cgColor,
                                UI.Color.alcoholTypes[bestAlcoholInd].withAlphaComponent(0.0).cgColor]
        }
        // if all lists are empty, dont alculate
        else {
            topLine.bestPriceName.text = "EMPTY!"
            topLine.bestCountName.text = "EMPTY!"
            view.backgroundColor = UI.Color.alculatePurpleLite
            bestAlcoholInd = 3
            Header.gradient.colors = [UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                                UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                                UI.Color.alculatePurpleLite.cgColor]
        }
    }
    
    func findBestPrice(for alc: (abv: String, size: String, price: String)) -> Double {
        let abvDouble = Double(alc.abv.dropLast())!*0.01
        let sizeUnit = alc.size.dropFirst(alc.size.count-2)
        var correctedSize = Double(alc.size.dropLast(2))!
        if sizeUnit == "ml" {
            correctedSize = correctedSize/29.5735296875
        }
        let priceDouble: Double
        if alc.price != "" {
            priceDouble = Double(alc.price)!
        }
        else {
            priceDouble = 1.0
        }
        return priceDouble/((abvDouble*correctedSize)/0.6)
    }
    
    func findBestRatio(for alc: (abv: String, size: String)) -> Double {
        let abvDouble = Double(alc.abv.dropLast())!*0.01
        let sizeUnit = alc.size.dropFirst(alc.size.count-2)
        var correctedSize = Double(alc.size.dropLast(2))!
        if sizeUnit == "ml" {
            correctedSize = correctedSize/29.5735296875
        }
        return (abvDouble*correctedSize)/0.6
    }
    
}
