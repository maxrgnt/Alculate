//
//  TableOne.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TableOne: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var tableOneLeading: NSLayoutConstraint!
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build() {
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        register(TableOneCell.self, forCellReuseIdentifier: "TableOneCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .none
        sectionIndexColor = UIColor.black
        sectionIndexBackgroundColor = UIColor.clear
        // Initialize pan gesture recognizer to dismiss view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(reactToPanGesture(_:)))
        addGestureRecognizer(pan)
        // Set constraints not related to superview (ViewController)
        tableOneLeading = leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.width)
        NSLayoutConstraint.activate([
            tableOneLeading,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.height-(UI.Sizing.headerHeight)),
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
        return Data.headers
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Data.headers.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableOneCell = tableView.dequeueReusableCell(withIdentifier: "TableOneCell") as! TableOneCell
        let headerLetter = Data.headers[indexPath.section]
        let nameList = Data.matrix[headerLetter]
        let name = nameList![indexPath.row]
        let abv = Data.masterList[name]!.abv
        let type = Data.masterList[name]!.type
        cell.cellLabel.text = "\(name): \(abv)% [\(type)]"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.matrix[Data.headers[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.headerHeight
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

    @objc func reactToPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        // Allow movement of contact card back/forth when not fully visible
        tableOneLeading.constant += translation.x
        // If contact card is fully visible, don't allow movement further left
        if tableOneLeading.constant < 0 {
            tableOneLeading.constant = 0
        }
        // Set recognizer to start new drag gesture in future
        sender.setTranslation(CGPoint.zero, in: self)
        // Handle auto-scroll in/out of frame depending on location of ending pan gesture
        if sender.state == UIGestureRecognizer.State.ended {
            // Auto-scroll left (in frame)
            var constant: CGFloat = 0.0
            // Auto-scroll right (out of frame)
            if tableOneLeading.constant > UI.Sizing.width/4 {
                constant = UI.Sizing.width
            }
            // Animate to end-point
            animateLeadingAnchor(constant: constant)
        }
    }
    
    func animateLeadingAnchor(constant: CGFloat) {
        tableOneLeading.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
