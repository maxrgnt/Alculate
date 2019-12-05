//
//  DrinkLibraryTable.swift
//  Alculate
//
//  Created by Max Sergent on 12/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol DrinkLibraryTableDelegate {
    func animateUndo(onScreen: Bool)
    func reloadTable(table: String, realculate: Bool)
    func editDrinkLibrary(name: String, abv: String, type: String)
    func adjustHeaderConstant(to: CGFloat)
    func resetHeader()
    func finishScrolling()
}

class DrinkLibraryTable: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    //MARK: Definitions
    // Delegate object
    var customDelegate : DrinkLibraryTableDelegate!
    // Variables
    var toBeDeleted: [(name: String, abv: String, type: String)] = []
    var isMoving   = false
    
    //MARK: - Initialization
    override init (frame: CGRect, style: UITableView.Style) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        
        backgroundColor = .clear //UI.Color.alculatePurpleLite
        register(DrinkLibraryCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.drinkLibraryCell)
        delegate                     = self
        dataSource                   = self
        tableHeaderView              = nil
        separatorStyle               = .singleLine
        separatorColor               = .lightGray
        alwaysBounceHorizontal       = false
        showsVerticalScrollIndicator = false
        sectionIndexColor            = UI.Color.Font.standard
        sectionIndexBackgroundColor  = UIColor.clear
    
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DrinkLibraryCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.drinkLibraryCell) as! DrinkLibraryCell
        cell.setLabels(forCellAt: indexPath)
        // color = x * start_color + (x-1) * end_color
        let totalSections: CGFloat = CGFloat(tableView.numberOfSections) // CGFloat(Data.masterList.count)
        let section: CGFloat = CGFloat(indexPath.section)
        let blah: CGFloat = section/totalSections // ((section*(section+1))/2)/totalSections
        let R: CGFloat = ((1-blah) * CGFloat(UI.Color.Gradient.darkestRGB[0]))  + (blah * CGFloat(UI.Color.Gradient.darkRGB[0]))
        let G: CGFloat = ((1-blah) * CGFloat(UI.Color.Gradient.darkestRGB[1]))  + (blah * CGFloat(UI.Color.Gradient.darkRGB[1]))
        let B: CGFloat = ((1-blah) * CGFloat(UI.Color.Gradient.darkestRGB[2]))  + (blah * CGFloat(UI.Color.Gradient.darkRGB[2]))
        cell.setBackgroundColor(R: R, G: G, B: B)
        backgroundColor = UIColor(displayP3Red: R/255, green: G/255, blue: B/255, alpha: 1.0)
        return cell
    }
        
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let indexTitles: [String]? = (isMoving) ? nil : Data.headers
        return indexTitles
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Data.headers.count
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.matrix[Data.headers[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UI.Sizing.DrinkLibrary.Row.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let headerLetter = Data.headers[indexPath.section]
        let nameList     = Data.matrix[headerLetter]
        let name         = nameList![indexPath.row]
        let abv          = Data.masterList[name]!.abv
        let type         = Data.masterList[name]!.type
        self.customDelegate.editDrinkLibrary(name: name, abv: abv, type: type)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            let headerLetter = Data.headers[indexPath.section]
            let nameList     = Data.matrix[headerLetter]
            let name         = nameList![indexPath.row]
            let abv          = Data.masterList[name]!.abv
            let type         = Data.masterList[name]!.type
            self.toBeDeleted.append((name: name, abv: abv, type: type))
            Data.isEditable = true // false
            // Checking for specific name / abv / type combo
            if Data.masterList[name]!.abv == abv && Data.masterList[name]!.type == type {
                Data.masterList[name] = nil
            }
            self.customDelegate.reloadTable(table: Data.masterListID, realculate: false)
            self.customDelegate.animateUndo(onScreen: true)
        })
        DeleteAction.backgroundColor = UI.Color.begonia
        return UISwipeActionsConfiguration(actions: [DeleteAction])
    }
 
    //MARK: Functions
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            self.customDelegate.adjustHeaderConstant(to: contentOffset.y)
            scrollView.contentOffset.y = 0
        }
        if scrollView.contentOffset.y > 0 {
            self.customDelegate.resetHeader()
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // pass
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.customDelegate.finishScrolling()
        isMoving = false
        reloadSectionIndexTitles()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate.finishScrolling()
        isMoving = false
        reloadSectionIndexTitles()
    }

}
