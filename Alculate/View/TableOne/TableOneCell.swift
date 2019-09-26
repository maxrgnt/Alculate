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
        backgroundColor = .lightGray
        // View object settings
        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.textColor = UI.Color.softWhite
        cellLabel.textAlignment = .left
        cellLabel.font = UI.Font.headerFont
        cellLabel.text = "Test"
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            cellLabel.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            cellLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight*2),
            cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
