//
//  ComparisonTable.swift
//  Alculate
//
//  Created by Max Sergent on 11/20/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol ComparisonTableDelegate {
    // called when user taps container or delete button
//    func reloadTable(table: String, realculate: Bool)
//    func makeDeletable(_ paramDeletable: Bool, lists: String)
    func editComparison(type: String, name: String, abv: String, size: String, price: String)
    func alculate()
    func resetHeight(for: String)
}

class ComparisonTable: UITableView, UITableViewDelegate, UITableViewDataSource {

    // Delegate object
    var customDelegate : ComparisonTableDelegate!

    // Constraints
    var height: NSLayoutConstraint!
    
    // Vairables
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []
    var comparisonTableListID = ""
    var willDelete = false
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    // MARK: - View/Object Settings
    func build(forType alcoholType: String, anchorTo anchorView: UIView) {
        comparisonTableListID = alcoholType
        backgroundColor = .clear
        register(ComparisonCell.self, forCellReuseIdentifier: "ComparisonCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        constraints(anchorTo: anchorView)
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ComparisonCell = tableView.dequeueReusableCell(withIdentifier: "ComparisonCell") as! ComparisonCell
        if listForThisTable().count == 0 {
//            cell.name.text = "Add a drink!"
        }
        else {
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
        let type = comparisonTableListID
        let name = list[indexPath.row].name
        let abv = list[indexPath.row].abv
        let size = list[indexPath.row].size
        let price = list[indexPath.row].price
        self.customDelegate.editComparison(type: type, name: name, abv: abv, size: size, price: price)
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let info = listForThisTable()[indexPath.row]
//            Data.deleteFromList(comparisonTableListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
//            self.deleteRows(at: [indexPath], with: .fade)
//            self.customDelegate.alculate()
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            print("Delete")
            let info = self.listForThisTable()[indexPath.row]
            Data.deleteFromList(self.comparisonTableListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            self.deleteRows(at: [indexPath], with: .fade)
            self.customDelegate.alculate()
            self.customDelegate.resetHeight(for: self.comparisonTableListID)
        })
        DeleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [DeleteAction])
      }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // pass
    }
    
    // MARK: - List Finder Function
    func listForThisTable() -> [(name: String, abv: String, size: String, price: String)] {
        // create list of each alcoholList
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        // set chosenList object
        var thisTablesList: [(name: String, abv: String, size: String, price: String)] = []
        // iterate through alcohol list ID's
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
           // if alcohol list id matches the tables id, return that lists count
           if comparisonTableListID == ID {
               // set row count to list count
               thisTablesList = lists[i]
           }
        }
        return thisTablesList
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
//        height = heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonHeader*2)
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonTable),
//            height,
            bottomAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: -UI.Sizing.Padding.comparison),
            topAnchor.constraint(equalTo: anchorView.topAnchor, constant: UI.Sizing.Height.comparisonHeader)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

