//
//  ViewController.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, InputDelegate, TableTwoDelegate {

    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!

    var header = Header()
    var topLine = TopLine()
    var subLine = SubLine()
    var tableTwo = TableTwo()
    var appNavigation = AppNavigation()
    var tableOne = TableOne()
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
        
        for subview in [header, topLine, subLine, tableTwo, appNavigation, tableOne, userInput] {
            view.addSubview(subview)
        }
        
        header.build()
        //
        topLine.build()
        //
        subLine.build()
        //
        tableTwo.build()
        self.tableTwo.tableTwoDelegate = self
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
        tableOne.build()
        
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
            Data.loadList(for: "MasterList")
            Data.loadList(for: "BeerList")
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
            if tableTwo.willDelete {
                sender.setTitle("X", for: .normal)
            }
            tableTwo.willDelete = !tableTwo.willDelete
        }
        else if sender.tag == 2 {
            resetAddButton()
            tableOne.animateLeadingAnchor(constant: 0)
        }
    }
    
    func resetAddButton() {
        if appNavigation.selectingType {
            appNavigation.presentAlcoholTypes()
        }
    }
    
    func displayAlert(alert : UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
            
    func reloadTable(table: String) {
        if table == "masterList" {
            tableOne.reloadData()
        }
        else if table == "beerList" {
            if tableTwo.willDelete {
                tableTwo.willDelete = false
                appNavigation.left.setTitle("X", for: .normal)
            }
            tableTwo.reloadData()
        }
    }
}
