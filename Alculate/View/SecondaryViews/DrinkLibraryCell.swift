//
//  DrinkLibraryCell.swift
//  Alculate
//
//  Created by Max Sergent on 12/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol DrinkLibraryCellDelegate: AnyObject {
    func remove(cell: DrinkLibraryCell)
}

class DrinkLibraryCell: UITableViewCell {
  
    // Delegate object for Protocol above
    var delegate: DrinkLibraryCellDelegate?

    // Objects
    let icon = UIImageView()
    let drinkName = UILabel()
    let drinkInfo = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // MARK: - View/Object Settings
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "DrinkLibraryCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .clear
        // View object settings
        addSubview(icon)
        //
        addSubview(drinkName)
        drinkName.textColor = UI.Color.fontWhite
        drinkName.textAlignment = .left
        drinkName.font = UI.Font.cellHeaderFont
        //
        addSubview(drinkInfo)
        drinkInfo.textColor = UI.Color.fontWhite
        drinkInfo.textAlignment = .left
        drinkInfo.font = UI.Font.cellStubFont
        drinkInfo.alpha = 0.7
        
        // MARK: - NSLayoutConstraints
        for obj in [icon,drinkName,drinkInfo] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding/2),
            icon.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABViconDiameter),
            icon.widthAnchor.constraint(equalToConstant: UI.Sizing.savedABViconDiameter),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            drinkName.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: UI.Sizing.objectPadding/2),
            drinkName.topAnchor.constraint(equalTo: topAnchor),
            drinkName.widthAnchor.constraint(equalToConstant: UI.Sizing.savedABVmainWidth),
            drinkName.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVtopLineHeight),
            drinkInfo.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: UI.Sizing.objectPadding/2),
            drinkInfo.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            drinkInfo.widthAnchor.constraint(equalToConstant: UI.Sizing.savedABVmainWidth),
//            drinkInfo.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVsubLineHeight),
            ])
    }
    
    // MARK: - Label Setter
    func setLabels(forCellAt indexPath: IndexPath) {
        let headerSection = Data.headers[indexPath.section]
        let drinkNames = Data.matrix[headerSection]
        let nameFromMemory = drinkNames![indexPath.row]
        let abv = Data.masterList[nameFromMemory]!.abv
        let type = Data.masterList[nameFromMemory]!.type
        icon.image = UIImage(named: type)
        drinkName.text = nameFromMemory.capitalized
        drinkInfo.text = "\(abv)%"
    }
    
    func setBackgroundColor(R: CGFloat, G: CGFloat, B: CGFloat) {
        backgroundColor = UIColor(displayP3Red: R/255, green: G/255, blue: B/255, alpha: 1.0)
    }
    
    @objc func remove(sender: AnyObject) {
        delegate?.remove(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
