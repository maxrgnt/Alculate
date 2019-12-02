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

class ViewController: UIViewController, ContainerTableDelegate, TextEntryDelegate, DrinkLibraryTableDelegate {
    
    // Constraints
    static var leadingAnchor: NSLayoutXAxisAnchor!
    static var topAnchor: NSLayoutYAxisAnchor!
    static var trailingAnchor: NSLayoutXAxisAnchor!
    static var bottomAnchor: NSLayoutYAxisAnchor!
    static var secondaryTop: NSLayoutConstraint!
    
    // Objects
    var primaryView = PrimaryView()
    var secondaryView = SecondaryView()
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
        background.sync { self.handleInit() }
        background.sync { self.build()      }
        self.primaryView.layoutIfNeeded()
//        background.sync { self.alculate()   }
//        background.sync { primaryView.comparison.updateHeight(for: Data.beerListID) }
//        background.sync { primaryView.comparison.updateHeight(for: Data.liquorListID) }
//        background.sync { primaryView.comparison.updateHeight(for: Data.wineListID) }
//        primaryView.comparison.updateContentSize()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            background.sync { self.moveDrinkLibrary(to: "visible") }
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "presentLegalAgreement") {
            presentLegalAgreement()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        primaryView.menu.showDrinkLibrary.addTarget(self, action: #selector(navigateApp), for: .touchUpInside)
        
        view.addSubview(secondaryView)
        secondaryView.translatesAutoresizingMaskIntoConstraints                                               = false
        ViewController.secondaryTop = secondaryView.topAnchor.constraint(equalTo: ViewController.bottomAnchor)
        secondaryView.leadingAnchor.constraint(equalTo: ViewController.leadingAnchor).isActive                = true
        secondaryView.trailingAnchor.constraint(equalTo: ViewController.trailingAnchor).isActive              = true
        ViewController.secondaryTop.isActive                                                                    = true
        secondaryView.heightAnchor.constraint(equalToConstant: UI.Sizing.Secondary.height).isActive             = true
        secondaryView.setup()
        
        self.secondaryView.drinkLibrary.table.customDelegate = self
        
        
//        self.primaryView.comparison.beer.delegate = self
        self.primaryView.comparison.beer.table.customDelegate = self
//        self.primaryView.comparison.liquor.delegate = self
        self.primaryView.comparison.liquor.table.customDelegate = self
//        self.primaryView.comparison.wine.delegate = self
        self.primaryView.comparison.wine.table.customDelegate = self
                
//        view.addSubview(savedABV)
//        savedABV.build()
//        self.savedABV.savedABVDelegate = self
//        self.savedABV.savedABVTable.savedABVTableDelegate = self
//
        view.addSubview(undo)
        undo.build()
        undo.confirm.addTarget(self, action: #selector(confirmUndo), for: .touchUpInside)
        undo.cancel.addTarget(self, action: #selector(cancelUndo), for: .touchUpInside)

        view.addSubview(tapDismiss)
        tapDismiss.build()

        view.addSubview(textEntry)
        textEntry.build()
        self.textEntry.textEntryDelegate = self

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
        let message = """
            \nBy using Alculate the user certifies they are of legal drinking age and will consume alcohol responsibly.\n\nThe user certifies they will never drink and drive or use the alcohol effect metric (converting drinks into shots) to determine one's ability to drive.\n\nAlculate will never save any information stored within the app. Data is stored locally on this device.
            """
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let messageText = NSAttributedString(
            string: message,
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
        // stop long name animations
        for obj in [primaryView.comparison.beer, primaryView.comparison.liquor, primaryView.comparison.wine,
                    primaryView.header.value, primaryView.header.effect] {
            obj.subviews.forEach({$0.layer.removeAllAnimations()})
            obj.layer.removeAllAnimations()
            obj.layoutIfNeeded()
        }
    }

    @objc func willEnterForeground() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            for id in Data.IDs {
                reloadTable(table: id, realculate: false)
            }
            primaryView.comparison.updateContentSize()
            primaryView.comparison.checkIfEmpty()
            alculate()
//            if (ViewController.typeValue != "" && ViewController.typeEffect != "") {
//                primaryView.header.value.calculateNameWidth()
//                primaryView.header.effect.calculateNameWidth()
//            }
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
            didEnterBackground()
            primaryView.moveMenu(to: "hidden")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.moveDrinkLibrary(to: "visible")
            }
        }
    }
    
    //MARK: - Animations
    func moveDrinkLibrary(to state: String) {
        let new: CGFloat = (state == "hidden") ? 0.0 : -UI.Sizing.Secondary.height
        ViewController.secondaryTop.constant = new
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut
            , animations: ({
                self.view.layoutIfNeeded()
            }), completion: { (completed) in
                // re animate long labels on primary view when hiding secondary
                (state == "hidden") ? self.animateComparisonLabels(to: "moving") : self.animateComparisonLabels(to: "still")
        })
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
        if ViewController.secondaryTop.constant != 0.0 {
            if !secondaryView.drinkLibrary.table.toBeDeleted.isEmpty {
                // for every object in toBeDeleted, add it back to the Data master list
                for info in secondaryView.drinkLibrary.table.toBeDeleted {
                    Data.masterList[info.name] = (type: info.type, abv: info.abv)
                }
                secondaryView.drinkLibrary.table.reloadData()
            }
        }
        else {
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
        if ViewController.secondaryTop.constant != 0.0 {
            removeABVfromCoreData()
        }
        else {
//            for (i,list) in Data.toBeDeleted.enumerated() {
//                print(i, list)
//            }
            Data.toBeDeleted = [[],[],[]]
        }
        animateUndo(onScreen: false)
    }
    
    func removeABVfromCoreData() {
        // iterate over every object in the toBeDeleted table
        for info in secondaryView.drinkLibrary.table.toBeDeleted {
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
        for (index, listPiece) in Data.lists.enumerated() {
            // if the list is not empty, add the top item to lists to be compared (already sorted)
            if !listPiece.isEmpty {
                lists.append((arr: listPiece.first!, ind: index))
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
            let info = lists.first!.arr
            bestPrice = (name: info.name,
                         best: String(format: "%.2f", calculateValue(for: info)),
                         ind: lists.first!.ind)
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
                           ind: lists.first!.ind)
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
//            primaryView.header.value.calculateNameWidth()
//            primaryView.header.effect.calculateNameWidth()
        }
        // if all lists are empty, dont alculate
        else {
            primaryView.comparison.checkIfEmpty()
            primaryView.moveSummaryAnchor(to: "hidden")
            ViewController.typeEffect = ""
            ViewController.typeValue = ""
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
        for i in 0..<Data.lists.count {
            Data.lists[i] = Data.lists[i].sorted { (drink1, drink2) -> Bool in
                return calculateValue(for: drink1) < calculateValue(for: drink2)
            }
            reloadTable(table: Data.IDs[i], realculate: false)
        }
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
        primaryView.comparison.updateContentSize()
        primaryView.comparison.checkIfEmpty()
    }
    
    func animateComparisonLabels(to state: String) {
        (state == "moving") ? willEnterForeground() : nukeBothComparisonLabels()
    }
    
    func nukeBothComparisonLabels() {
        primaryView.header.value.nukeAllAnimations()
        primaryView.header.effect.nukeAllAnimations()
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
        if let cell = secondaryView.drinkLibrary.table.cellForRow(at: secondaryView.drinkLibrary.table.indexPathsForVisibleRows![0]) {
            secondaryView.drinkLibrary.gradient2.colors = [cell.backgroundColor!.cgColor,cell.backgroundColor!.cgColor,cell.backgroundColor!.cgColor]
        }
    }
    
    func resetHeader() {
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        if ViewController.secondaryTop.constant != secondaryViewAtTop {
            ViewController.secondaryTop.constant = secondaryViewAtTop
            finishScrolling()
        }
    }
    
    func adjustHeaderConstant(to constant: CGFloat) {
        // Allow movement of contact card back/forth when not fully visible
        ViewController.secondaryTop.constant += -constant
        // If contact card is fully visible, don't allow movement further left
        let currentConstant = ViewController.secondaryTop.constant
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        ViewController.secondaryTop.constant = currentConstant < secondaryViewAtTop ? secondaryViewAtTop : currentConstant
        secondaryView.layoutIfNeeded()
    }
    
    func finishScrolling() {
        let dismissRatio: CGFloat = 0.7
        let secondaryViewAtTop = -UI.Sizing.Secondary.height
        let currentRatio: CGFloat = ViewController.secondaryTop.constant / secondaryViewAtTop
        (currentRatio >= dismissRatio) ? moveDrinkLibrary(to: "visible") : moveDrinkLibrary(to: "hidden")
        (currentRatio >= dismissRatio) ? nil : primaryView.moveMenu(to: "visible")
    }
    
    func editComparison(type: String, name: String, abv: String, size: String, price: String) {
        // reset output to saved data
        textEntry.outputFromComparison(name: name, abv: abv, size: size, price: price)
        // use type in future, but saved types dont work right now
        showTextEntry(forType: type, fullView: true)
    }
    
    func reloadTable(table: String, realculate: Bool = true) {
        if table == Data.masterListID {
            secondaryView.drinkLibrary.table.reloadData()
        }
        else {
            if realculate {
                sortByValue()
                alculate()
            }
            let sections = NSIndexSet(indexesIn: NSMakeRange(0,1))
            let tables = [primaryView.comparison.beer.table,primaryView.comparison.liquor.table,primaryView.comparison.wine.table]
            for (i, ID) in Data.IDs.enumerated() {
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
        for (i, ID) in Data.IDs.enumerated() {
            if type == ID {
                for x in 0..<Data.lists[i].count {
                    if Data.lists[i][x].name == name {
                        let abv = Data.lists[i][x].abv
                        let size = Data.lists[i][x].size
                        let price = Data.lists[i][x].price
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
        let lists = Data.lists
        for (i, ID) in Data.IDs.enumerated() {
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
        primaryView.comparison.checkIfEmpty()
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
}

