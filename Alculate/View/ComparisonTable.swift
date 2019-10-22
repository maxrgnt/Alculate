//
//  ComparisonTable.swift
//  Alculate
//
//  Created by Max Sergent on 10/10/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol ComparisonTableDelegate {
    // called when user taps container or delete button
    func reloadTable(table: String)
    func makeDeletable(_ paramDeletable: Bool, lists: String)
    func editComparison(type: String, name: String, abv: String, size: String, price: String)
}

class ComparisonTable: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComparisonCellDelegate {

    // Delegate object
    var comparisonTableDelegate : ComparisonTableDelegate!

    // Vairables
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []
    var comparisonTableListID = ""
    var willDelete = false
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build(forType ID: String, withLeading constantParameter: CGFloat) {
        // MARK: - View/Object Settings
        comparisonTableListID = ID
        // Miscelaneous view settings
        backgroundColor = UI.Color.alculatePurpleLite
        register(ComparisonCell.self, forCellReuseIdentifier: "ComparisonCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        showsVerticalScrollIndicator = false
//        layer.borderWidth = UI.Sizing.cellObjectBorder/3
//        layer.borderColor = UI.Color.alculatePurpleDark.cgColor
        estimatedRowHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
//        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.tableViewRadius)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: constantParameter),
            widthAnchor.constraint(equalToConstant: UI.Sizing.comparisonTableWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.comparisonTableHeight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.comparisonTableTop)
            ])
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: UI.Sizing.width/3, height: UI.Sizing.headerHeight*(1/2)))
//        let header = ComparisonHeader()
//        tableHeaderView = header
//        tableHeaderView?.layoutIfNeeded()
//        tableHeaderView = tableHeaderView
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ComparisonCell = tableView.dequeueReusableCell(withIdentifier: "ComparisonCell") as! ComparisonCell
        cell.delegate = self
        //
        let constraints = UI.Sizing.containerConstraints
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            if comparisonTableListID == ID {
                cell.containerLeading.constant = constraints[i].lead
            }
        }
        // gather info for each cell
        let info = listForThisTable()[indexPath.row]
        // update labels for each cell
        cell.setLabels(with: info)
        // do something for "best" alcohol from each type
        if indexPath.row == 0 {
            // pass
        }
        // I think you need to end animations when reloading table after deleting
        cell.resetConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listForThisTable().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.comparisonRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
    // MARK: - Comparison Cell Delegate
    func delegatePopulate(forCell cell: ComparisonCell) {
        let indexPath = self.indexPath(for: cell)
        let list = listForThisTable()
        let type = comparisonTableListID
        let name = list[indexPath!.row].name
        let abv = list[indexPath!.row].abv
        let size = list[indexPath!.row].size
        let price = list[indexPath!.row].price
        self.comparisonTableDelegate.editComparison(type: type, name: name, abv: abv, size: size, price: price)
    }
    
    func delegateCell(animate: Bool, forCell: ComparisonCell) {
        self.comparisonTableDelegate.makeDeletable(animate, lists: "all")
    }
    
    func delegateRemove(forCell cell: ComparisonCell) {
        let indexPath = self.indexPath(for: cell)
        let info = listForThisTable()[indexPath!.row]
        Data.deleteFromList(comparisonTableListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
        self.deleteRows(at: [indexPath!], with: .automatic)
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // pass
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // pass
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // pass
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // pass
    }
    
    func resetHeader() {
        // pass
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

