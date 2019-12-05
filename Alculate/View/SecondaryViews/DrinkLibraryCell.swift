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
        super.init(style: style, reuseIdentifier: Constants.CellIdentifiers.drinkLibraryCell)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    //MARK: Setup
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        objectSettings()
        constraints()
    }
    
    //MARK: Object Settings
    func objectSettings() {
       addSubview(icon)
       addSubview(drinkName)
        addSubview(drinkInfo)
       drinkName.textColor     = UI.Color.Font.standard
       drinkName.textAlignment = .left
       drinkName.font          = UI.Font.DrinkLibrary.rowHeader
       drinkInfo.textColor     = UI.Color.Font.standard
       drinkInfo.textAlignment = .left
       drinkInfo.font          = UI.Font.DrinkLibrary.rowStub
       drinkInfo.alpha         = 0.7
    }
    
    //MARK: Label Setter
    func setLabels(forCellAt indexPath: IndexPath) {
        let headerSection  = Data.headers[indexPath.section]
        let drinkNames     = Data.matrix[headerSection]
        let nameFromMemory = drinkNames![indexPath.row]
        let abv            = Data.masterList[nameFromMemory]!.abv
        let type           = Data.masterList[nameFromMemory]!.type
        icon.image         = UIImage(named: type)
        drinkName.text     = nameFromMemory.capitalized
        drinkInfo.text     = "\(abv)%"
    }
    
    func setBackgroundColor(R: CGFloat, G: CGFloat, B: CGFloat) {
        backgroundColor = UIColor(displayP3Red: R/255, green: G/255, blue: B/255, alpha: 1.0)
    }
    
    //MARK: Constraints
    func constraints() {
        iconConstraints()
        drinkNameConstraints()
        drinkInfoConstraints()
    }
    
}
