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

class ViewController: UIViewController, SavedABVDelegate, SavedABVTableDelegate, ContainerTableDelegate, TextEntryDelegate {
    
    // Constraints
    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!
    
    // Objects
    var primaryView = PrimaryView()
    var secondaryView = SecondaryView()
    var savedABV = SavedABV()
    var tapDismiss = TapDismiss()
    var textEntry = TextEntry()
    var undo = Undo()
    var alert = UIAlertController(title: "title", message: "Hi", preferredStyle: .alert)
    
    var noComparisons = UILabel()
    
    static var typeValue: String! = ""
    static var typeEffect: String! = ""

    override func viewDidLoad() {
        
        ViewController.typeValue = ""
        
        // MARK: - View/Object Settings
        // Add keyboard observer to retrieve keyboard height when keyboard shown
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        //
        ViewController.leadingAnchor = view.leadingAnchor
        ViewController.topAnchor = view.topAnchor
        ViewController.trailingAnchor = view.trailingAnchor
        ViewController.bottomAnchor = view.bottomAnchor
        //
        view.backgroundColor = UI.Color.bgDarker
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        Data.deleteCoreDataFor(entity: Data.masterListID)

        //clearTestData()
        
        let background = DispatchQueue.global()
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            background.sync {
//                self.primaryView.header.value.calculateNameWidth()
//                self.primaryView.header.effect.calculateNameWidth()
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
//            background.sync {
//                self.primaryView.moveSummaryAnchor(to: "hidden")
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
//            background.sync {
//                self.primaryView.moveSummaryAnchor(to: "visible")
//            }
//        }
        
//        let background = DispatchQueue.global()
//        background.sync { self.handleInit() }
        background.sync { self.build()      }
//        self.view.layoutIfNeeded()
//        background.sync { self.alculate()   }
//        background.sync { primaryView.comparison.updateHeight(for: Data.beerListID) }
//        background.sync { primaryView.comparison.updateHeight(for: Data.liquorListID) }
//        background.sync { primaryView.comparison.updateHeight(for: Data.wineListID) }
//        primaryView.comparison.updateContentSize()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            background.sync { self.moveSummaryAnchor(to: -UI.Sizing.Height.summary)}
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "presentLegalAgreement") {
            presentLegalAgreement()
        }
    }
    
    // MARK: - Build
    func build() {
        
        view.addSubview(primaryView)
        primaryView.translatesAutoresizingMaskIntoConstraints                                               = false
        primaryView.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                = true
        primaryView.trailingAnchor.constraint(equalTo: ViewController.trailingAnchor).isActive              = true
        primaryView.topAnchor.constraint(equalTo: ViewController.topAnchor).isActive                        = true
        primaryView.heightAnchor.constraint(equalToConstant: UI.Sizing.Primary.height).isActive             = true
        primaryView.setup()
        
        for obj in [primaryView.comparison.beer,primaryView.comparison.liquor,primaryView.comparison.wine] {
            obj.header.add.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        }
        
        view.addSubview(secondaryView)
        secondaryView.translatesAutoresizingMaskIntoConstraints                                               = false
        secondaryView.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                = true
        secondaryView.trailingAnchor.constraint(equalTo: ViewController.trailingAnchor).isActive              = true
        secondaryView.topAnchor.constraint(equalTo: ViewController.bottomAnchor).isActive                        = true
        secondaryView.heightAnchor.constraint(equalToConstant: UI.Sizing.Secondary.height).isActive             = true
        secondaryView.setup()
        
//        self.primaryView.comparison.beer.delegate = self
//        self.primaryView.comparison.beer.table.customDelegate = self
//        self.primaryView.comparison.liquor.delegate = self
//        self.primaryView.comparison.liquor.table.customDelegate = self
//        self.primaryView.comparison.wine.delegate = self
//        self.primaryView.comparison.wine.table.customDelegate = self
        
//        view.addSubview(subMenuBG)
//        subMenuBG.build()
//
//        view.addSubview(savedABV)
//        savedABV.build()
//        self.savedABV.savedABVDelegate = self
//        self.savedABV.savedABVTable.savedABVTableDelegate = self
//
//        view.addSubview(subMenu)
//        subMenu.build()
//        for obj in [subMenu.showSavedABV] {
//            obj.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
//        }
//
//        view.addSubview(undo)
//        undo.build()
//        undo.confirm.addTarget(self, action: #selector(confirmUndo), for: .touchUpInside)
//        undo.cancel.addTarget(self, action: #selector(cancelUndo), for: .touchUpInside)
//
//        view.addSubview(tapDismiss)
//        tapDismiss.build()
//
//        view.addSubview(textEntry)
//        textEntry.build()
//        self.textEntry.textEntryDelegate = self

    }
    
    
    // MARK: TraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        var textColor: UIColor!
        let userInterfaceStyle = traitCollection.userInterfaceStyle // Either .unspecified, .light, or .dark
        // Update your user interface based on the appearance
        if userInterfaceStyle == .light || userInterfaceStyle == .light {
            textColor = .black
        }
        if userInterfaceStyle == .dark {
            textColor = UI.Color.fontWhite
        }
        if !UserDefaults.standard.bool(forKey: "presentLegalAgreement") {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let messageText = NSAttributedString(
                string: "\nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor : textColor!,
                    NSAttributedString.Key.font : UI.Font.Comparison.row!
                ]
            )
            alert.setValue(messageText, forKey: "attributedMessage")
        }
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
    
    func presentLegalAgreement(/*title: String, message: String*/) {
        var textColor: UIColor!
        let userInterfaceStyle = traitCollection.userInterfaceStyle // Either .unspecified, .light, or .dark
        // Update your user interface based on the appearance
        if userInterfaceStyle == .light || userInterfaceStyle == .light {
            textColor = .black
        }
        if userInterfaceStyle == .dark {
            textColor = UI.Color.fontWhite
        }
        let title = "User Agreement"
//        let message = "By using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly. The user certifies they will never drink and drive or use Alculate's 'alcohol effect' metric to determine one's ability to drive."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let messageText = NSAttributedString(
            string: "\nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor : textColor!,
                NSAttributedString.Key.font : UI.Font.Comparison.row!
            ]
        )
        alert = UIAlertController(title: title, message: "Hi", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Agree", style: .default, handler: agreed))
        self.present(alert, animated: true)
    }
    
    func agreed(action:UIAlertAction) {
        UserDefaults.standard.set(true, forKey: "presentLegalAgreement")
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
    
    @objc func didEnterBackground() {
        for obj in [primaryView.comparison.beer, primaryView.comparison.liquor, primaryView.comparison.wine,
                    primaryView.header.value, primaryView.header.effect] {
            obj.subviews.forEach({$0.layer.removeAllAnimations()})
            obj.layer.removeAllAnimations()
            obj.layoutIfNeeded()
        }
    }

    @objc func willEnterForeground() {
        print("uncomment foreground when done")
//        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
//            for id in [Data.beerListID,Data.liquorListID,Data.wineListID] {
//                reloadTable(table: id, realculate: false)
//            }
//            alculate()
//            if (ViewController.typeValue != "" && ViewController.typeEffect != "") {
//                header.summary.value.calculateNameWidth()
//                header.summary.effect.calculateNameWidth()
//            }
//        }
    }
    
    // MARK: - App Navigator Functions
    @objc func navigateApp(sender: UIButton) {
//        let hapticFeedback = UINotificationFeedbackGenerator()
//        hapticFeedback.notificationOccurred(.warning)
        makeDeletable(false, lists: "all")
        if sender.tag >= 20 {
            print(Data.IDs[sender.tag-20])
            let iconNames = [Data.beerListID,Data.liquorListID,Data.wineListID]
            showTextEntry(forType: iconNames[sender.tag-20], fullView: true)
        }
        else if sender.tag == 0 {
//            flipAlculate()
        }
        else if sender.tag == 1 {
            didEnterBackground()
            savedABV.animateTopAnchor(constant: UI.Sizing.savedABVtop)
            primaryView.menu.bottom.constant = 0
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
        for obj in [textEntry.inputs.size,textEntry.inputs.price] {
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
        if savedABV.savedABVtop.constant != UI.Sizing.height {
            if !savedABV.savedABVTable.toBeDeleted.isEmpty {
                // for every object in toBeDeleted, add it back to the Data master list
                for info in savedABV.savedABVTable.toBeDeleted {
                    Data.masterList[info.name] = (type: info.type, abv: info.abv)
                }
                savedABV.savedABVTable.reloadData()
            }
        }
        else {
            print("CONFIRM")
            let ids = [Data.beerListID,Data.liquorListID,Data.wineListID]
            for (i,list) in Data.toBeDeleted.enumerated() {
                if !list.isEmpty {
                    for obj in list {
                        Data.saveToList(ids[i], wName: obj.name, wABV: obj.abv, wSize: obj.size, wPrice: obj.price)
                        insertRowFor(table: ids[i])
                    }
                }
            }
            Data.toBeDeleted = [[],[],[]]
        }
        animateUndo(onScreen: false)
    }
    
    @objc func cancelUndo() {
        if savedABV.savedABVtop.constant != UI.Sizing.height {
            removeABVfromCoreData()
        }
        else {
            print("CANCEL")
            for (i,list) in Data.toBeDeleted.enumerated() {
                print(i, list)
            }
            Data.toBeDeleted = [[],[],[]]
        }
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
            primaryView.comparison.checkIfEmpty()
            primaryView.moveSummaryAnchor(to: "visible")
            //summaryContainer.moveTopAnchor(to: UI.Sizing.topLineTop)
            //summaryContainer.valueSummary.moveTopAnchor(to: UI.Sizing.topLineTop)
            //summaryContainer.effectSummary.moveTopAnchor(to: UI.Sizing.topLineTop)
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
            ViewController.typeValue = [Data.beerListID,Data.liquorListID,Data.wineListID][bestPrice.ind]
            ViewController.typeEffect = [Data.beerListID,Data.liquorListID,Data.wineListID][bestRatio.ind]
            for id in [Data.beerListID,Data.liquorListID,Data.wineListID] {
                reloadTable(table: id, realculate: false)
            }
            
            let i = bestPrice.ind
            let priceColor = [UI.Color.Background.beerHeader, UI.Color.Background.liquorHeader, UI.Color.Background.wineHeader][i]
            let j = bestRatio.ind
            let effectColor = [UI.Color.Background.beerHeader, UI.Color.Background.liquorHeader, UI.Color.Background.wineHeader][j]
            
            primaryView.header.value.category.textColor = priceColor
            primaryView.header.effect.category.textColor = effectColor
            
            primaryView.header.value.name.text = bestPrice.name.capitalized
            primaryView.header.value.stat.text = "$"+bestPrice.best
            primaryView.header.effect.name.text = bestRatio.name.capitalized
            primaryView.header.effect.stat.text = bestRatio.best
            primaryView.header.value.calculateNameWidth()
            primaryView.header.effect.calculateNameWidth()
        }
        // if all lists are empty, dont alculate
        else {
            primaryView.comparison.checkIfEmpty()
            primaryView.moveSummaryAnchor(to: "hidden")
            ViewController.typeEffect = ""
            ViewController.typeValue = ""
            //summaryContainer.moveTopAnchor(to: -UI.Sizing.subMenuHeight)
            //summaryContainer.valueSummary.moveTopAnchor(to: -UI.Sizing.subMenuHeight)
            //summaryContainer.effectSummary.moveTopAnchor(to: -UI.Sizing.subMenuHeight)
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
            return calculateValue(for: drink1) < calculateValue(for: drink2)
        }
        // had to specify because of sortByValue on load
        reloadTable(table: Data.beerListID, realculate: false)
        //
        Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) < calculateValue(for: drink2)
        }
        reloadTable(table: Data.liquorListID, realculate: false)
        //
        Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
            return calculateValue(for: drink1) < calculateValue(for: drink2)
        }
        reloadTable(table: Data.wineListID, realculate: false)
    }
    
    func sortByEffect() {
        Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) > calculateEffect(for: drink2)
        }
        reloadTable(table: Data.beerListID, realculate: false)
        //
        Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) > calculateEffect(for: drink2)
        }
        reloadTable(table: Data.liquorListID, realculate: false)
        //
        Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
            return calculateEffect(for: drink1) > calculateEffect(for: drink2)
        }
        reloadTable(table: Data.wineListID, realculate: false)
        alculate()
    }
        
    // MARK: - Protocol Delegate Functions
    func resetHeight(for table: String) {
        primaryView.comparison.updateHeight(for: table)
    }
    
    func animateSubMenu(by percent: CGFloat, reset: Bool) {
        primaryView.menu.bottom.constant = -UI.Sizing.subMenuHeight*(percent)
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
    
    func animateComparisonLabels() {
        willEnterForeground()
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
            savedABV.gradient2.colors = [cell.backgroundColor!.cgColor,cell.backgroundColor!.cgColor,cell.backgroundColor!.cgColor]
//            savedABV.statusBar.backgroundColor = cell.backgroundColor
        }
    }
    
    func resetHeader() {
        if savedABV.savedABVtop.constant != UI.Sizing.savedABVtop {
            savedABV.savedABVtop.constant = UI.Sizing.savedABVtop
            finishScrolling()
        }
    }
    
    func adjustHeaderConstant(to constant: CGFloat) {
        // Allow movement of contact card back/forth when not fully visible
        savedABV.savedABVtop.constant += -constant
        // If contact card is fully visible, don't allow movement further left
        savedABV.savedABVtop.constant = savedABV.savedABVtop.constant < UI.Sizing.savedABVtop ? UI.Sizing.savedABVtop : savedABV.savedABVtop.constant
        savedABV.layoutIfNeeded()
    }
    
    func finishScrolling() {
        let newConstant = savedABV.savedABVtop.constant / UI.Sizing.height <= 0.4 ? UI.Sizing.savedABVtop : UI.Sizing.height
        let percent: CGFloat = (savedABV.savedABVtop.constant / UI.Sizing.height <= 0.4) ? 0.0 : 1.0
        percent == 1.0 ? animateSubMenu(by: 1.0, reset: false) : nil
        savedABV.animateTopAnchor(constant: newConstant)
    }
    
    func editComparison(type: String, name: String, abv: String, size: String, price: String) {
        // reset output to saved data
        textEntry.outputFromComparison(name: name, abv: abv, size: size, price: price)
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: true)
    }
    
    func reloadTable(table: String, realculate: Bool = true) {
        if table == Data.masterListID {
            savedABV.savedABVTable.reloadData()
        }
        else {
            if realculate {
                alculate()
            }
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            let tables = [primaryView.comparison.beer.table,primaryView.comparison.liquor.table,primaryView.comparison.wine.table]
            for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
                if table == ID {
                    //tables[i].reloadData()
                    tables[i].reloadSections(sections as IndexSet, with: .automatic)
//                    tables[i].updateTableContentInset()
                }
            }
        }
    }
    
    func updateComparison(for name: String, ofType type: String, wABV newAbv: String) {
        let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
        let tables = [primaryView.comparison.beer.table,primaryView.comparison.liquor.table,primaryView.comparison.wine.table]
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
//                        tables[i].updateTableContentInset()
                    }
                }
            }
        }
        
    }
    
    func insertRowFor(table: String) {
        let tables = [primaryView.comparison.beer.table,primaryView.comparison.liquor.table,primaryView.comparison.wine.table]
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            if table == ID {
                tables[i].beginUpdates()
                let index = (lists[i].count-1 < 0) ? 0 : lists[i].count-1
                tables[i].insertRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
                tables[i].endUpdates()
//                tables[i].updateTableContentInset()
                primaryView.comparison.updateHeight(for: table)
                break
            }
        }
        primaryView.comparison.updateContentSize()
        sortByValue()
        alculate()
    }
    
    func makeDeletable(_ paramDeletable: Bool, lists: String) {
//        var tables: [UITableView]! = []
//        let possibleTables = [[comparison.beer.table],[comparison.liquor.table],[comparison.wine.table],
//                              [comparison.beer.table,comparison.liquor.table,comparison.wine.table]]
//        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID,"all"].enumerated() {
//            if lists == ID {
//                tables = possibleTables[i]
//            }
//        }
//        for table in tables as! [ComparisonTable] {
//            for row in 0..<table.numberOfRows(inSection: 0) {
//                let cell = table.cellForRow(at: IndexPath(row: row, section: 0)) as! ComparisonCell
//                cell.stopAnimating(restartAnimations: paramDeletable)
//            }
//        }
    }
    
    @objc func clearList(sender: UIButton) {
        if sender.tag == 0 {
            for info in Data.beerList {
                Data.deleteFromList(Data.beerListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            }
            Data.beerList = []
            reloadTable(table: Data.beerListID, realculate: true)
            primaryView.comparison.updateHeight(for: Data.beerListID)
        }
        else if sender.tag == 1 {
            for info in Data.beerList {
                Data.deleteFromList(Data.liquorListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            }
            Data.liquorList = []
            reloadTable(table: Data.liquorListID, realculate: true)
            primaryView.comparison.updateHeight(for: Data.liquorListID)
        }
        else if sender.tag == 2 {
            for info in Data.beerList {
                Data.deleteFromList(Data.wineListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            }
            Data.wineList = []
            reloadTable(table: Data.wineListID, realculate: true)
            primaryView.comparison.updateHeight(for: Data.wineListID)
        }
        primaryView.comparison.updateContentSize()
    }
}

