//
//  SavedABVCell.swift
//  Alculate
//
//  Created by Max Sergent on 10/11/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol SavedABVCellDelegate: AnyObject {
    func remove(cell: SavedABVCell)
}

class SavedABVCell: UITableViewCell {
  
    // Delegate object for Protocol above
    var delegate: SavedABVCellDelegate?

    // Objects
    let icon = UIImageView()
    let drinkName = UILabel()
    let drinkInfo = UILabel()
    let delete = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // MARK: - View/Object Settings
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "SavedABVCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .clear
        // View object settings
        addSubview(icon)
        //
        addSubview(drinkName)
        drinkName.textColor = UI.Color.softWhite
        drinkName.textAlignment = .left
        drinkName.font = UI.Font.cellHeaderFont
        //
        addSubview(drinkInfo)
        drinkInfo.textColor = UI.Color.softWhite
        drinkInfo.textAlignment = .left
        drinkInfo.font = UI.Font.cellStubFont
        drinkInfo.alpha = 0.7
        //
        addSubview(delete)
        delete.titleLabel?.font = UI.Font.cellHeaderFont
        delete.setTitle("X", for: .normal)
        delete.setTitleColor(.white, for: .normal)
        delete.backgroundColor = UI.Color.alculatePurpleLite
        delete.contentVerticalAlignment = .center
        delete.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.savedABVdeleteRadius)
        delete.addTarget(self, action: #selector(remove), for: .touchUpInside)
        
        // MARK: - NSLayoutConstraints
        for obj in [icon,drinkName,drinkInfo,delete] {
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
            drinkInfo.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVsubLineHeight),
            delete.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            delete.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVdeleteDiameter),
            delete.widthAnchor.constraint(equalToConstant: UI.Sizing.savedABVdeleteDiameter),
            delete.centerYAnchor.constraint(equalTo: centerYAnchor)
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
        drinkName.text = nameFromMemory.capitalizingFirstLetter()
        drinkInfo.text = "\(abv)%"
    }
    
    @objc func remove(sender: AnyObject) {
        delegate?.remove(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
