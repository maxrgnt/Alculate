//
//  ViewController.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, InputDelegate, TableTwoDelegate, TableOneDelegate {
        
    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!

    var header = Header()
    var topLine = TopLine()
    var beerList = TableTwo()
    var liquorList = TableTwo()
    var wineList = TableTwo()
    var appNavigation = AppNavigation()
    var masterList = MasterList()
    var userInput = Input()
    
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
        
        for subview in [header, topLine, beerList, liquorList, wineList, appNavigation, masterList, userInput] {
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
        self.masterList.tableOne.tableOneDelegate = self
        
        //clearTestData()
        handleInit()
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

    @objc func navigateApp(sender: UIButton) {
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
            sender.setTitle("O", for: .normal)
            if beerList.willDelete {
                sender.setTitle("X", for: .normal)
            }
            beerList.willDelete = !beerList.willDelete
            liquorList.willDelete = !liquorList.willDelete
            wineList.willDelete = !wineList.willDelete
        }
        else if sender.tag == 2 {
            resetAddButton()
            masterList.animateLeadingAnchor(constant: 0)
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
            
    func reloadTable(table: String) {
        if table == Data.masterListID {
            masterList.tableOne.reloadData()
        }
        else {
            if table == Data.beerListID {
                beerList.reloadData()
            }
            else if table == Data.liquorListID {
                liquorList.reloadData()
            }
            else if table == Data.wineListID {
                wineList.reloadData()
            }
            resetDeleteButton()
            resetAddButton()
            alculate()
        }
    }

    func alculate() {
        // create framework of top item from first list
        var info: (name: String, abv: String, size: String, price: String)!
        // create framework of array of lists that are not empty
        var lists: [(arr: (name: String, abv: String, size: String, price: String), ind: Int)]! = []
        // create framework of best alcohol of top items from each list
        var bestAlcohol: (name: String, alc: String, avg: String, ind: Int)!
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
            bestAlcohol = (name: info.name,
                           alc: String(format: "%.2f", findBest(for: (abv: info.abv, size: info.size, price: info.price))),
                           avg: String(format: "%.1f", (Double(info.abv)!*Double(info.size)!*0.01/0.6)),
                           ind: lists[0].ind)
            for listPiece in lists {
                let tryBest = findBest(for: (abv: listPiece.arr.abv, size: listPiece.arr.size, price: listPiece.arr.price))
                if tryBest < Double(bestAlcohol.alc)! {
                    bestAlcohol = (name: listPiece.arr.name,
                                   alc: String(format: "%.2f", tryBest),
                                   avg: String(format: "%.1f", (Double(listPiece.arr.abv)!*Double(listPiece.arr.size)!*0.01/0.6)),
                                   ind: listPiece.ind)
                }
            }
            topLine.bestAlcohol.text = bestAlcohol.name+" | $"+bestAlcohol.alc+" | "+bestAlcohol.avg+"x"
            topLine.backgroundColor = UI.Color.alcoholTypes[bestAlcohol.ind]
            view.backgroundColor = UI.Color.alcoholTypes[bestAlcohol.ind]
        }
        // if all lists are empty, dont alculate
        else {
            topLine.bestAlcohol.text = "EMPTY!"
        }
    }
    
    func findBest(for alc: (abv: String, size: String, price: String)) -> Double {
        let abvDouble = Double(alc.abv)!*0.01
        let sizeDouble = Double(alc.size)!
        let priceDouble: Double
        if alc.price != "" {
            priceDouble = Double(alc.price)!
        }
        else {
            priceDouble = 1.0
        }
        return priceDouble/((abvDouble*sizeDouble)/0.6)
    }
    
}
