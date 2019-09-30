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
    let name = UILabel()
    let size = UILabel()
    let totalAlcohol = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableTwoCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .lightGray
        // View object settings
        for label in [name, size, totalAlcohol] {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.textAlignment = .center
            label.font = UI.Font.cellFont
        }
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.width/9),
            name.centerXAnchor.constraint(equalTo: centerXAnchor),
            name.topAnchor.constraint(equalTo: topAnchor),
            size.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            size.heightAnchor.constraint(equalToConstant: UI.Sizing.width/9),
            size.centerXAnchor.constraint(equalTo: centerXAnchor),
            size.topAnchor.constraint(equalTo: name.bottomAnchor),
            totalAlcohol.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
            totalAlcohol.heightAnchor.constraint(equalToConstant: UI.Sizing.width/9),
            totalAlcohol.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalAlcohol.topAnchor.constraint(equalTo: size.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
