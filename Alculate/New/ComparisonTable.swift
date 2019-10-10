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

    // Constraints
    var ComparisonTableDelegate : ComparisonTableDelegate!
    var tableTwoLeading: NSLayoutConstraint!

    // Objects
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []
    var alcoholTitle = UILabel()

    // Vairables
    var alcoholID = "price"
    var willDelete = false
    var varDeletable = false
    var alculateType = "price"
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build(forType ID: String) {
        alcoholID = ID
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
        
        // Set constraints not related to superview (ViewController)
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
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ComparisonCell = tableView.dequeueReusableCell(withIdentifier: "ComparisonCell") as! ComparisonCell
        cell.delegate = self
//        cell.type = alcoholType
//        cell.cellObject.backgroundColor = UI.Color.alcoholTypes[0]
        let info = fetchInfo(forRowAt: indexPath)
        if indexPath.row == 0 {
//            cell.cellObject.backgroundColor = UI.Color.softWhite
            //cell.cellObject.alpha = 0.6
        }
//        cell.name.text = "\(info.name.capitalizingFirstLetter())"
//        let price = String(format: "%.2f", Double(info.price)!)
        let sizeUnit = info.size.dropFirst(info.size.count-2)
//        cell.size.text = "\(info.size.dropLast(2)) \(sizeUnit) | $\(price)"
        var correctedSize = Double(info.size.dropLast(2))!
        if sizeUnit == "ml" {
            correctedSize = correctedSize/29.5735296875
        }
        let alcPerDollar = Double(info.price)!/(Double(info.abv)!*correctedSize*0.01/0.6)
//        let cost = "$"+String(format: "%.2f", alcPerDollar)
        if alculateType == "price" {
//            cell.sortedStat.text = cost
//            cell.sortedLabel.text = "per shot"
//            cell.otherStat.text = String(format: "%.1f",(Double(info.abv)!*correctedSize*0.01/0.6))
//            cell.otherLabel.text = "shots"
        }
        else {
//            cell.sortedStat.text = String(format: "%.1f",(Double(info.abv)!*correctedSize*0.01/0.6))
//            cell.sortedLabel.text = "shots"
//            cell.otherStat.text = cost
//            cell.otherLabel.text = "per shot"
        }
//        cell.nukeAllAnimations(restart: varDeletable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set list of each alcohol list count
        let listCounts = [Data.beerList.count,Data.liquorList.count,Data.wineList.count]
        // set row count variable to update for return
        var rowCount = 0
        // iterate through alcohol list ID's
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
            // if alcohol list id matches the tables id, return that lists count
            if alcoholID == ID {
                // set row count to list count
                rowCount = listCounts[i]
            }
        }
        // return the row count for a given alcohol list
        // should never be zero because each list represented as table
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pass
    }
    
    func fetchInfo(forRowAt indexPath: IndexPath) -> (name: String, abv: String, size: String, price: String) {
        // create list of each alcoholList
        let lists = [Data.beerList,Data.liquorList,Data.wineList]
        // set chosenList object
        var chosenList: [(name: String, abv: String, size: String, price: String)] = []
        // iterate through alcohol list ID's
        for (i, ID) in [Data.beerListID,Data.liquorListID,Data.wineListID].enumerated() {
           // if alcohol list id matches the tables id, return that lists count
           if alcoholID == ID {
               // set row count to list count
               chosenList = lists[i]
           }
        }
        return chosenList[indexPath.row]
    }

    func cellWillDelete(cell: TableTwoCell) {
        varDeletable = true
//        self.tableTwoDelegate.makeDeletable(true, lists: "all")
    }
    
    func stopDelete(cell: TableTwoCell) {
        varDeletable = false
//        self.tableTwoDelegate.makeDeletable(false, lists: "all")
    }
    
    func remove(cell: TableTwoCell) {
        let indexPath = self.indexPath(for: cell)
        var info = (name: "", abv: "", size: "", price: "")
        if alcoholID == "BEER" {
            info = Data.beerList[indexPath!.row]
            Data.deleteFromList(Data.beerListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
//            self.tableTwoDelegate.reloadTable(table: Data.beerListID)
        }
        else if alcoholID == "LIQUOR" {
            info = Data.liquorList[indexPath!.row]
            Data.deleteFromList(Data.liquorListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
//            self.tableTwoDelegate.reloadTable(table: Data.liquorListID)
        }
        else if alcoholID == "WINE" {
            info = Data.wineList[indexPath!.row]
            Data.deleteFromList(Data.wineListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
//            self.tableTwoDelegate.reloadTable(table: Data.wineListID)
        }
    }

    func delegateCell(animate: Bool, forCell: ComparisonCell) {
        //
    }
    
    func delegateRemove(forCell cell: ComparisonCell) {
        //
    }
    
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

