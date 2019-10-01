//
//  TableTwoCell.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TableTwoCell: UITableViewCell {
  
    // Objects
    let cellObject = UIView()
    
    let name = UILabel()
    let size = UILabel()
    let cost = UILabel()
    let perDrink = UILabel()
    let avg = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableTwoCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .lightGray
        addSubview(cellObject)
        cellObject.translatesAutoresizingMaskIntoConstraints = false
        cellObject.backgroundColor = .clear
        cellObject.layer.borderWidth = UI.Sizing.tableViewWidth*(1/30)
        cellObject.layer.borderColor = UIColor.black.cgColor
        // View object settings
        for label in [name, size, cost, perDrink, avg] {
            cellObject.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.textAlignment = .left
            label.font = UI.Font.cellStubFont
        }
        size.alpha = 0.7
        name.font = UI.Font.cellHeaderFont
        cost.font = UI.Font.cellHeaderFont
        avg.font = UI.Font.cellHeaderFont
        perDrink.text = "per avg drink"
        perDrink.alpha = 0.7
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            cellObject.widthAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth-UI.Sizing.objectPadding),
            cellObject.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth*(4/5)),
            cellObject.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellObject.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.tableViewWidth*(1/20)),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth-UI.Sizing.objectPadding),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            name.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor),
            name.topAnchor.constraint(equalTo: cellObject.topAnchor),
            size.widthAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth-UI.Sizing.objectPadding),
            size.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/6),
            size.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor),
            size.topAnchor.constraint(equalTo: name.bottomAnchor),
            cost.widthAnchor.constraint(equalToConstant: (UI.Sizing.tableViewWidth-UI.Sizing.objectPadding)/2),
            cost.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            cost.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor),
            cost.topAnchor.constraint(equalTo: size.bottomAnchor),
            perDrink.widthAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth-UI.Sizing.objectPadding),
            perDrink.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/6),
            perDrink.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor),
            perDrink.topAnchor.constraint(equalTo: cost.bottomAnchor),
            avg.widthAnchor.constraint(equalToConstant: (UI.Sizing.tableViewWidth-UI.Sizing.objectPadding)/2),
            avg.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            avg.trailingAnchor.constraint(equalTo: cellObject.trailingAnchor),
            avg.topAnchor.constraint(equalTo: size.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
