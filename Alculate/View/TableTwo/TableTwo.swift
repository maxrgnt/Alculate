//
//  TableTwo.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class TableTwo: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var tableTwoDelegate : TableTwoDelegate!

    var willDelete = false
    var alcoholType = ""

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
            backgroundColor = .lightGray
        }
        else if alcoholType == "LIQUOR" {
           backgroundColor = .gray
        }
        else if alcoholType == "WINE" {
           backgroundColor = .darkGray
        }
        register(TableTwoCell.self, forCellReuseIdentifier: "TableTwoCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .singleLine
        separatorColor = .black
        // Set constraints not related to superview (ViewController)
        tableTwoLeading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor)
        NSLayoutConstraint.activate([
            tableTwoLeading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewHeight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.tableViewTop)
            ])
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableTwoCell = tableView.dequeueReusableCell(withIdentifier: "TableTwoCell") as! TableTwoCell
        var info = (name: "", abv: "", size: "", price: "")
        if alcoholType == "BEER" {
            info = Data.beerList[indexPath.row]
            cell.backgroundColor = .lightGray
        }
        else if alcoholType == "LIQUOR" {
            info = Data.liquorList[indexPath.row]
            cell.backgroundColor = .gray
        }
        else if alcoholType == "WINE" {
            info = Data.wineList[indexPath.row]
            cell.backgroundColor = .darkGray
        }
        cell.name.text = "\(info.name)"
        let price = String(format: "%.2f", Double(info.price)!)
        cell.size.text = "\(info.size) oz. | $\(price)"
        let alcPerDollar = Double(info.price)!/(Double(info.abv)!*Double(info.size)!*0.01/0.6)
        cell.totalAlcohol.text = String(format: "%.2f", alcPerDollar)+" $/drink"
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
        return UI.Sizing.width/3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if willDelete {
            if alcoholType == "BEER" {
                let info = Data.beerList[indexPath.row]
                Data.deleteFromList(Data.beerListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
                self.tableTwoDelegate.reloadTable(table: Data.beerListID)
            }
            else if alcoholType == "LIQUOR" {
                let info = Data.liquorList[indexPath.row]
                Data.deleteFromList(Data.liquorListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
                self.tableTwoDelegate.reloadTable(table: Data.liquorListID)
            }
            else if alcoholType == "WINE" {
                let info = Data.wineList[indexPath.row]
                Data.deleteFromList(Data.wineListID, wName: info.name, wABV: info.abv, wSize: info.size, wPrice: info.price)
                self.tableTwoDelegate.reloadTable(table: Data.wineListID)
            }
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

protocol TableTwoDelegate {
    // called when user taps subview/delete button
    func displayAlert(alert: UIAlertController)
    func reloadTable(table: String)
}
