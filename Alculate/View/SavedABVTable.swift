//
//  SavedABVTable.swift
//  Alculate
//
//  Created by Max Sergent on 10/11/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol SavedABVTableDelegate {
    // called when user taps subview/delete button
    func animateUndo(onScreen: Bool)
    func reloadTable(table: String)
    func editSavedABV(name: String, abv: String, type: String)
}

class SavedABVTable: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SavedABVCellDelegate {

    // Delegate object
    var savedABVTableDelegate : SavedABVTableDelegate!
    
    // Variables
    var toBeDeleted: [(name: String, abv: String, type: String)] = []
    var isMoving = false
    
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear //UI.Color.alculatePurpleLite
        register(SavedABVCell.self, forCellReuseIdentifier: "SavedABVCell")
        delegate = self
        dataSource = self
        tableHeaderView = nil
        separatorStyle = .singleLine
        separatorColor = .gray
        sectionIndexColor = UI.Color.softWhite
        sectionIndexBackgroundColor = UIColor.clear
    }
        
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SavedABVCell = tableView.dequeueReusableCell(withIdentifier: "SavedABVCell") as! SavedABVCell
        cell.delegate = self
        cell.setLabels(forCellAt: indexPath)
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexTitles: [String]? = Data.headers
        if isMoving {
            indexTitles = nil
        }
        return indexTitles
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Data.headers.count
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.matrix[Data.headers[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.savedABVrowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let headerLetter = Data.headers[indexPath.section]
        let nameList = Data.matrix[headerLetter]
        let name = nameList![indexPath.row]
        let abv = Data.masterList[name]!.abv
        let type = Data.masterList[name]!.type
        self.savedABVTableDelegate.editSavedABV(name: name, abv: abv, type: type)
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeader = ContactSection()
//        sectionHeader.buildView(cointactsUI: cointactsUI)
//        sectionHeader.label.text = data.headers[section]
//        return sectionHeader
//    }
    
    // MARK: - SavedABV Cell Delegate
    func remove(cell: SavedABVCell) {
        let indexPath = self.indexPath(for: cell)
        let headerLetter = Data.headers[indexPath!.section]
        let nameList = Data.matrix[headerLetter]
        let name = nameList![indexPath!.row]
        let abv = Data.masterList[name]!.abv
        let type = Data.masterList[name]!.type
        toBeDeleted.append((name: name, abv: abv, type: type))
        Data.isEditable = true // false
        // Checking for specific name / abv / type combo
        if Data.masterList[name]!.abv == abv && Data.masterList[name]!.type == type {
            Data.masterList[name] = nil
        }
        self.savedABVTableDelegate.reloadTable(table: Data.masterListID)
        self.savedABVTableDelegate.animateUndo(onScreen: true)
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
