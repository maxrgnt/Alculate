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
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build() {
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        register(TableTwoCell.self, forCellReuseIdentifier: "TableTwoCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        // Set constraints not related to superview (ViewController)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewHeight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.statusBar.height+UI.Sizing.headerHeight+UI.Sizing.topLineHeight+UI.Sizing.subLineHeight)
            ])
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableTwoCell = tableView.dequeueReusableCell(withIdentifier: "TableTwoCell") as! TableTwoCell
        let info = Data.beerList[indexPath.row]
        cell.name.text = "\(info.name)"
        cell.size.text = "\(info.size) oz."
        let totalAlc = Double(info.abv)!*Double(info.size)!*0.01
        cell.totalAlcohol.text = String(format: "%.2f", totalAlc)+" alc"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.beerList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.width/3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pass
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
