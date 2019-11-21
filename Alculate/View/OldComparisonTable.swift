//
//  ComparisonTable.swift
//  Alculate
//
//  Created by Max Sergent on 10/10/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol OldComparisonTableDelegate {
    // called when user taps container or delete button
    func reloadTable(table: String, realculate: Bool)
    func makeDeletable(_ paramDeletable: Bool, lists: String)
    func editComparison(type: String, name: String, abv: String, size: String, price: String)
    func alculate()
}

class OldComparisonTable: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, OldComparisonCellDelegate {

    // Delegate object
    var comparisonTableDelegate : OldComparisonTableDelegate!

    // Vairables
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []
    var comparisonTableListID = ""
    var willDelete = false
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build(forType ID: String, withLeading constantParameter: CGFloat, anchorTo anchorView: UIView) {
        // MARK: - View/Object Settings
        comparisonTableListID = ID
        // Miscelaneous view settings
        backgroundColor = .clear
        register(OldComparisonCell.self, forCellReuseIdentifier: "OldComparisonCell")
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
            bottomAnchor.constraint(equalTo: anchorView.topAnchor)
            ])
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: UI.Sizing.width/3, height: UI.Sizing.headerHeight*(1/2)))
//        let header = ComparisonHeader()
//        tableHeaderView = header
//        tableHeaderView?.layoutIfNeeded()
//        tableHeaderView = tableHeaderView
//        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UI.Sizing.width, height: UI.Sizing.objectPadding/2))
//        footer.backgroundColor = backgroundColor
//        tableFooterView = footer
        updateTableContentInset()
    }

    func updateTableContentInset() {
        // number of rows in table
        let numRows = tableView(self, numberOfRowsInSection: 0)
        // content inset
        var contentInsetTop = UI.Sizing.comparisonTableHeight
        // Reset inest based on rows in table
        contentInsetTop -= CGFloat(numRows)*UI.Sizing.comparisonRowHeight
        // If the inset is less than 0 make it 0
        contentInsetTop = (contentInsetTop < 0) ? 0 : contentInsetTop
        // Reset the inset
        self.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
        //
        let lastCell = listForThisTable().count-1
        if lastCell > 0 {
            let indexPath = IndexPath(row: lastCell, section: 0)
            scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OldComparisonCell = tableView.dequeueReusableCell(withIdentifier: "OldComparisonCell") as! OldComparisonCell
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

//            let sublayer: CALayer = CALayer()
//            sublayer.borderColor = UIColor(displayP3Red: 206/255, green: 137/255, blue: 83/255, alpha: 1.0).cgColor
//            sublayer.backgroundColor = UIColor.clear.cgColor
//            sublayer.cornerRadius = UI.Sizing.containerRadius
//            sublayer.frame = CGRect(x:2, y: 2, width: UI.Sizing.containerDiameter - 4, height: UI.Sizing.containerHeight - 4)
//            sublayer.borderWidth = 4.0
//            cell.container.layer.addSublayer(sublayer)
        
        // I think you need to end animations when reloading table after deleting
        cell.resetConstraints()
        
        // do something for "best" alcohol from each type
        let maxRow = (listForThisTable().count-1 < 0) ? 0 : listForThisTable().count-1
        if indexPath.row == maxRow && comparisonTableListID == ViewController.typeValue {
            cell.container.layer.borderColor = UI.Color.value.cgColor
        }
        if indexPath.row == maxRow && comparisonTableListID == ViewController.typeEffect {
            cell.container.layer.borderColor = UI.Color.effect.cgColor
        }
        if indexPath.row == maxRow && comparisonTableListID == ViewController.typeValue && comparisonTableListID == ViewController.typeEffect {
            cell.container.layer.borderColor = UI.Color.best.cgColor
        }
        
        cell.container.calculateNameWidth()
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
//            print("end reached for \(comparisonTableListID)")
        }
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
    func delegatePopulate(forCell cell: OldComparisonCell) {
        let indexPath = self.indexPath(for: cell)
        let list = listForThisTable()
        let type = comparisonTableListID
        let name = list[indexPath!.row].name
        let abv = list[indexPath!.row].abv
        let size = list[indexPath!.row].size
        let price = list[indexPath!.row].price
        self.comparisonTableDelegate.editComparison(type: type, name: name, abv: abv, size: size, price: price)
    }
    
    func delegateCell(animate: Bool, forCell: OldComparisonCell) {
        self.comparisonTableDelegate.makeDeletable(animate, lists: "all")
    }
    
    func delegateRemove(forCell cell: OldComparisonCell) {
        let indexPath = self.indexPath(for: cell)
        let info = listForThisTable()[indexPath!.row]
        Data.deleteFromList(comparisonTableListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
        self.deleteRows(at: [indexPath!], with: .bottom)
        updateTableContentInset()
        self.comparisonTableDelegate.alculate()
        self.comparisonTableDelegate.makeDeletable(true, lists: "all")
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

