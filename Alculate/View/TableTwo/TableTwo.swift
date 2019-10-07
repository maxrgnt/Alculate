//
//  TableTwo.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol TableTwoDelegate {
    // called when user taps subview/delete button
    func displayAlert(alert: UIAlertController)
    func reloadTable(table: String)
    func makeDeletable(_ paramDeletable: Bool, lists: String)
}

class TableTwo: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TableTwoCellDelegate {
            
    var tableTwoDelegate : TableTwoDelegate!
    var alculateType = "price"
    
    var varDeletable = false
    var toBeDeleted: [(name: String, abv: String, size: String, price: String)] = []

    var willDelete = false
    var alcoholType = ""
    
    var alcoholTitle = UILabel()

    var tableTwoLeading: NSLayoutConstraint!
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build(forType alcohol: String) {
        alcoholType = alcohol
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        if alcoholType == "BEER" {
            backgroundColor = UI.Color.alculatePurpleLite
        }
        else if alcoholType == "LIQUOR" {
            backgroundColor = UI.Color.alculatePurpleLite
        }
        else if alcoholType == "WINE" {
            backgroundColor = UI.Color.alculatePurpleLite
        }
        register(TableTwoCell.self, forCellReuseIdentifier: "TableTwoCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        showsVerticalScrollIndicator = false
//        self.addTopBorder(with: UI.Color.alculatePurpleDark, andWidth: CGFloat(UI.Sizing.cellObjectBorder))
//        self.addLeftBorder(with: UI.Color.alculatePurpleDark, andWidth: CGFloat(UI.Sizing.cellObjectBorder/2))
//        self.addRightBorder(with: UI.Color.alculatePurpleDark, andWidth: CGFloat(UI.Sizing.cellObjectBorder/2))
        layer.borderWidth = UI.Sizing.cellObjectBorder/3
        layer.borderColor = UI.Color.alculatePurpleDark.cgColor
        //separatorColor = .black
        estimatedRowHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.tableViewRadius)
        // Set constraints not related to superview (ViewController)
        tableTwoLeading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor)
        NSLayoutConstraint.activate([
            tableTwoLeading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewHeight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.tableViewTop)
            ])
        // 2.
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UI.Sizing.width/3, height: UI.Sizing.headerHeight*(1/2)))
        header.backgroundColor = .clear
        let headerLabel = UILabel()
        header.addSubview(headerLabel)
        headerLabel.font = UI.Font.cellHeaderFont
        headerLabel.textColor = UI.Color.softWhite
        headerLabel.textAlignment = .center
        headerLabel.text = alcoholType
        tableHeaderView = header
        // 3.
//        header.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: header.widthAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight*(1/3)).isActive = true
        // 4.
        tableHeaderView?.layoutIfNeeded()
        tableHeaderView = tableHeaderView
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableTwoCell = tableView.dequeueReusableCell(withIdentifier: "TableTwoCell") as! TableTwoCell
        cell.delegate = self
        var info = (name: "", abv: "", size: "", price: "")
        cell.type = alcoholType
        if alcoholType == "BEER" {
            info = Data.beerList[indexPath.row]
            cell.cellObject.backgroundColor = UI.Color.alcoholTypes[0]
        }
        else if alcoholType == "LIQUOR" {
            info = Data.liquorList[indexPath.row]
            cell.cellObject.backgroundColor = UI.Color.alcoholTypes[1]
        }
        else if alcoholType == "WINE" {
            info = Data.wineList[indexPath.row]
            cell.cellObject.backgroundColor = UI.Color.alcoholTypes[2]
        }
        if indexPath.row == 0 {
//            cell.cellObject.backgroundColor = UI.Color.softWhite
            //cell.cellObject.alpha = 0.6
        }
        cell.name.text = "\(info.name.capitalizingFirstLetter())"
        let price = String(format: "%.2f", Double(info.price)!)
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        cell.size.text = "\(info.size.dropLast(2)) \(sizeUnit) | $\(price)"
        var correctedSize = Double(info.size.dropLast(2))!
        if sizeUnit == "ml" {
            correctedSize = correctedSize/29.5735296875
        }
        let alcPerDollar = Double(info.price)!/(Double(info.abv)!*correctedSize*0.01/0.6)
        let cost = "$"+String(format: "%.2f", alcPerDollar)
        if alculateType == "price" {
            cell.sortedStat.text = cost
            cell.sortedLabel.text = "per shot"
            cell.otherStat.text = String(format: "%.1f",(Double(info.abv)!*correctedSize*0.01/0.6))
            cell.otherLabel.text = "shots"
        }
        else {
            cell.sortedStat.text = String(format: "%.1f",(Double(info.abv)!*correctedSize*0.01/0.6))
            cell.sortedLabel.text = "shots"
            cell.otherStat.text = cost
            cell.otherLabel.text = "per shot"
        }
        cell.nukeAllAnimations(restart: varDeletable)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if alcoholType == "BEER" {
            return Data.beerList.count
        }
        else if alcoholType == "LIQUOR" {
           return Data.liquorList.count
        }
        else if alcoholType == "WINE" {
           return Data.wineList.count
        }
        else {
            return Data.beerList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func cellWillDelete(cell: TableTwoCell) {
        varDeletable = true
        self.tableTwoDelegate.makeDeletable(true, lists: "all")
    }
    
    func stopDelete(cell: TableTwoCell) {
        varDeletable = false
        self.tableTwoDelegate.makeDeletable(false, lists: "all")
    }
    
    func remove(cell: TableTwoCell) {
        let indexPath = self.indexPath(for: cell)
        var info = (name: "", abv: "", size: "", price: "")
        if alcoholType == "BEER" {
            info = Data.beerList[indexPath!.row]
            Data.deleteFromList(Data.beerListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            self.tableTwoDelegate.reloadTable(table: Data.beerListID)
        }
        else if alcoholType == "LIQUOR" {
            info = Data.liquorList[indexPath!.row]
            Data.deleteFromList(Data.liquorListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            self.tableTwoDelegate.reloadTable(table: Data.liquorListID)
        }
        else if alcoholType == "WINE" {
            info = Data.wineList[indexPath!.row]
            Data.deleteFromList(Data.wineListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
            self.tableTwoDelegate.reloadTable(table: Data.wineListID)
        }
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

