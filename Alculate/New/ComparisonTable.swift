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
    // called when user taps subview/delete button
    func displayAlert(alert: UIAlertController)
    func reloadTable(table: String)
    func makeDeletable(_ paramDeletable: Bool, lists: String)
}

class ComparisonTable: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComparisonCellDelegate {

    // Delegate object
    var ComparisonTableDelegate : ComparisonTableDelegate!
    
    // Constraints
    var tableTwoLeading: NSLayoutConstraint!

    // Vairables
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []
    var comparisonTableListID = "price"
    var willDelete = false
    var varDeletable = false
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build(forType ID: String) {
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
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.tableViewRadius)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        tableTwoLeading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor)
        NSLayoutConstraint.activate([
            tableTwoLeading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewHeight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.tableViewTop)
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
        // gather info for each cell
        let info = fetchInfo(forRowAt: indexPath)
        // update labels for each cell
        cell.setLabels(with: info)
        // do something for "best" alcohol from each type
        if indexPath.row == 0 {
            // pass
        }
        // I think you need to end animations when reloading table after deleting
//        cell.nukeAllAnimations(restart: varDeletable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listForTable().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pass
    }
    
    // MARK: - Data Related Functions
    func listForTable() -> [(name: String, abv: String, size: String, price: String)] {
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
    
    func fetchInfo(forRowAt indexPath: IndexPath) -> (name: String, abv: String, size: String, price: String) {
        return listForTable()[indexPath.row]
    }
    
    // MARK: - Comparison Cell Delegate
    func delegateCell(animate: Bool, forCell: ComparisonCell) {
        //
    }
    
    func delegateRemove(forCell cell: ComparisonCell) {
        //
    }

    // MARK: - Comparison Table Delegate
    func cellWillDelete(cell: TableTwoCell) {
//        varDeletable = true
//        self.tableTwoDelegate.makeDeletable(true, lists: "all")
    }
    
    func stopDelete(cell: TableTwoCell) {
//        varDeletable = false
//        self.tableTwoDelegate.makeDeletable(false, lists: "all")
    }
    
        func remove(cell: TableTwoCell) {
            let indexPath = self.indexPath(for: cell)
            let info = fetchInfo(forRowAt: indexPath!)
            Data.deleteFromList(comparisonTableListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
    //        self.tableTwoDelegate.reloadTable(table: Data.beerListID)
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

