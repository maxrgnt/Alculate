//
//  DrinkLibraryCell.swift
//  Alculate
//
//  Created by Max Sergent on 12/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class DrinkLibraryCell: UITableViewCell {

    // Objects
    let icon = UIImageView()
    let drinkName = UILabel()
    let drinkInfo = UILabel()
    
    //MARK: Initialization
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
        drinkName.textColor = UI.Color.Font.standard
        drinkName.textAlignment = .left
        drinkName.font = UI.Font.DrinkLibrary.rowHeader
        //
        addSubview(drinkInfo)
        drinkInfo.textColor = UI.Color.Font.standard
        drinkInfo.textAlignment = .left
        drinkInfo.font = UI.Font.DrinkLibrary.rowStub
        drinkInfo.alpha = 0.7
        
        // MARK: - NSLayoutConstraints
        for obj in [icon,drinkName,drinkInfo] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding/2),
            icon.heightAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Icon.diameter),
            icon.widthAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Icon.diameter),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            drinkName.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: UI.Sizing.objectPadding/2),
            drinkName.topAnchor.constraint(equalTo: topAnchor),
            drinkName.widthAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Row.contentWidth),
            drinkName.heightAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Row.headerHeight),
            drinkInfo.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: UI.Sizing.objectPadding/2),
            drinkInfo.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            drinkInfo.widthAnchor.constraint(equalToConstant: UI.Sizing.DrinkLibrary.Row.contentWidth),
//            drinkInfo.heightAnchor.constraint(equalToConstant: UI.Sizing.savedABVsubLineHeight),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    //MARK: Object Settings
    func objectSettings() {
        
    }
    
    //MARK: Label Setter
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
    
    //MARK: Constraints
    func constraints() {
        
    }
    
}
