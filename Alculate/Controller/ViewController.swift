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
    var subLine = SubLine()
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
        
        for subview in [header, topLine, subLine, beerList, liquorList, wineList, appNavigation, masterList, userInput] {
            view.addSubview(subview)
        }
        
        header.build()
        //
        topLine.build()
        //
        subLine.build()
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
        Data.deleteCoreDataFor(entity: "Alcohol")
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
            for list in ["MasterList","BeerList","LiquorList","WineList"] {
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
        print("reload")
        if table == "masterList" {
            masterList.tableOne.reloadData()
        }
        else {
            if table == "beerList" {
                beerList.reloadData()
            }
            else if table == "liquorList" {
                liquorList.reloadData()
            }
            else if table == "wineList" {
                wineList.reloadData()
            }
            resetDeleteButton()
            resetAddButton()
            alculate()
        }
    }

    func alculate() {
        var bestAlcohol = (name: "", alc: "0.0")
        var bestBeer = (name: "", alc: "0.0")
        var bestLiquor = (name: "", alc: "0.0")
        var bestWine = (name: "", alc: "0.0")
        for alc in Data.beerList {
            if Double(alc.abv)!*Double(alc.size)!*0.01 > Double(bestBeer.alc)! {
                bestBeer = (name: alc.name, alc: String(format: "%.2f", Double(alc.abv)!*Double(alc.size)!*0.01))
            }
        }
        for alc in Data.liquorList {
            if Double(alc.abv)!*Double(alc.size)!*0.01 > Double(bestLiquor.alc)! {
                bestLiquor = (name: alc.name, alc: String(format: "%.2f", Double(alc.abv)!*Double(alc.size)!*0.01))
            }
        }
        for alc in Data.wineList {
            if Double(alc.abv)!*Double(alc.size)!*0.01 > Double(bestWine.alc)! {
                bestWine = (name: alc.name, alc: String(format: "%.2f", Double(alc.abv)!*Double(alc.size)!*0.01))
            }
        }
        for alc in [bestBeer, bestLiquor, bestWine] {
            if Double(alc.alc)! > Double(bestAlcohol.alc)! {
                bestAlcohol = (name: alc.name, alc: alc.alc)
            }
        }
        subLine.bestBeer.text = "\(bestBeer.name): \(bestBeer.alc) alc"
        subLine.bestLiquor.text = "\(bestLiquor.name): \(bestLiquor.alc) alc"
        subLine.bestWine.text = "\(bestWine.name): \(bestWine.alc) alc"
        topLine.bestAlcohol.text = "\(bestAlcohol.name): \(bestAlcohol.alc) alc"
    }
}
