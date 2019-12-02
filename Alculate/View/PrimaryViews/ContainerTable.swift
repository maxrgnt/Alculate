//
//  ContainerTable.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol ContainerTableDelegate {
    func editComparison(type: String, name: String, abv: String, size: String, price: String)
    func alculate()
    func resetHeight(for: String)
    func animateUndo(onScreen: Bool)
}

class ContainerTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Definitions
    // Delegate object
    var customDelegate : ContainerTableDelegate!
    // Constraints
    var height: NSLayoutConstraint!
    // Variables
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []
    var type = ""
    var willDelete = false
    
    //MARK: - Initialization
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup(forType id: String) {
        
        type = id
        backgroundColor = .clear
        register(ContainerCell.self, forCellReuseIdentifier: "ContainerCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
    
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContainerCell = tableView.dequeueReusableCell(withIdentifier: "ContainerCell") as! ContainerCell
        if listForThisTable().count == 0 {
//            cell.name.text = "Add a drink!"
//            for obj in [cell.effect,cell.effectUnit,cell.value,cell.valueUnit] {
//                obj.isHidden = true
//            }
        }
        else {
            for obj in [cell.effect,cell.effectUnit,cell.value,cell.valueUnit] {
                obj.isHidden = false
            }
            // gather info for each cell
            let info = listForThisTable()[indexPath.row]
            // update labels for each cell
            cell.setLabels(with: info)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if listForThisTable().count == 0 {return 1}
//        else {return listForThisTable().count}
        return listForThisTable().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.Height.comparisonRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = listForThisTable()
        let name = list[indexPath.row].name
        let abv = list[indexPath.row].abv
        let size = list[indexPath.row].size
        let price = list[indexPath.row].price
        self.customDelegate.editComparison(type: type, name: name, abv: abv, size: size, price: price)
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let info = listForThisTable()[indexPath.row]
//            Data.deleteFromList(type, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
//            self.deleteRows(at: [indexPath], with: .fade)
//            self.customDelegate.alculate()
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            let info = self.listForThisTable()[indexPath.row]
            var i = 0
            i = (self.type == Data.liquorListID) ? 1 : i
            i = (self.type == Data.wineListID) ? 2 : i
            print(self.type, i)
            print(self.toBeDeleted)
            Data.toBeDeleted[i].append(info)
            Data.deleteFromList(self.type, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            self.deleteRows(at: [indexPath], with: .fade)
            self.customDelegate.alculate()
            self.customDelegate.animateUndo(onScreen: true)
            self.customDelegate.resetHeight(for: self.type)
        })
        
        var bgColor = (type == Data.beerListID) ? UI.Color.Background.beerHeader : nil
        bgColor = (type == Data.liquorListID) ? UI.Color.Background.liquorHeader : bgColor
        bgColor = (type == Data.wineListID) ? UI.Color.Background.wineHeader : bgColor
        
        DeleteAction.backgroundColor = bgColor
        return UISwipeActionsConfiguration(actions: [DeleteAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // pass
    }

    //MARK: - List Finder Function
    func listForThisTable() -> [(name: String, abv: String, size: String, price: String)] {
        // create list of each alcoholList
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        // set chosenList object
        var thisTablesList: [(name: String, abv: String, size: String, price: String)] = []
        // iterate through alcohol list ID's
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
           // if alcohol list id matches the tables id, return that lists count
           if type == ID {
               // set row count to list count
               thisTablesList = lists[i]
           }
        }
        return thisTablesList
    }
    
}
