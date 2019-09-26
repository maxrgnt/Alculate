//
//  TableOne.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TableOne: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build() {
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray
        register(TableOneCell.self, forCellReuseIdentifier: "TableOneCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        // Set constraints not related to superview (ViewController)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewHeight),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.statusBar.height + UI.Sizing.headerHeight)
            ])
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeader = ContactSection()
//        sectionHeader.buildView(cointactsUI: cointactsUI)
//        sectionHeader.label.text = data.headers[section]
//        return sectionHeader
//    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["MAX"]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableOneCell = tableView.dequeueReusableCell(withIdentifier: "TableOneCell") as! TableOneCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.headerHeight*3
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
