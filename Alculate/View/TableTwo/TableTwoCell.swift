//
//  TableTwoCell.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol TableTwoCellDelegate: AnyObject {
    func remove(cell: TableTwoCell)
}

class TableTwoCell: UITableViewCell {
  
    /*weak*/ var delegate: TableTwoCellDelegate?

    // Objects
    let cellObject = UIView()
    
    var type = ""
    let name = UILabel()
    let size = UILabel()
    let perDrink = UILabel()
    let avg = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableTwoCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .lightGray
        //
        addSubview(cellObject)
        cellObject.translatesAutoresizingMaskIntoConstraints = false
        cellObject.backgroundColor = .clear
        cellObject.layer.borderWidth = UI.Sizing.cellObjectBorder
        cellObject.layer.borderColor = UIColor.black.cgColor
        cellObject.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: UI.Sizing.cellObjectRadius)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        cellObject.addGestureRecognizer(longPressRecognizer)
        // View object settings
        for label in [name, size, perDrink, avg] {
            cellObject.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.textAlignment = .left
            label.font = UI.Font.cellStubFont
        }
        size.alpha = 0.7
        name.font = UI.Font.cellHeaderFont
        avg.font = UI.Font.cellHeaderFont
        perDrink.text = "per avg drink"
        perDrink.alpha = 0.7
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            cellObject.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth),
            cellObject.heightAnchor.constraint(equalToConstant: UI.Sizing.cellObjectHeight),
            cellObject.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellObject.bottomAnchor.constraint(equalTo: bottomAnchor),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            name.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            name.topAnchor.constraint(equalTo: cellObject.topAnchor, constant: UI.Sizing.cellObjectBorder),
            size.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder*2),
            size.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/6),
            size.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            size.topAnchor.constraint(equalTo: name.bottomAnchor),
            avg.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder),
            avg.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            avg.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            avg.topAnchor.constraint(equalTo: size.bottomAnchor),
            perDrink.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder),
            perDrink.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/6),
            perDrink.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            perDrink.topAnchor.constraint(equalTo: avg.bottomAnchor)
            ])
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        cellObject.backgroundColor = .red
        delegate?.remove(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
