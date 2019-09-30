//
//  TableOneCel.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TableOneCell: UITableViewCell {
  
    // Objects
    let cellLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableOneCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .gray
        // View object settings
        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.textColor = .black
        cellLabel.textAlignment = .left
        cellLabel.font = UI.Font.headerFont
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            cellLabel.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            cellLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
