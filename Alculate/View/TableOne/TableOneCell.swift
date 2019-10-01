//
//  TableOneCel.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol TableOneCellDelegate: AnyObject {
    func remove(cell: TableOneCell)
}

class TableOneCell: UITableViewCell {
  
    /*weak*/ var delegate: TableOneCellDelegate?

    // Objects
    let cellLabel = UILabel()
    let remove = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableOneCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .black
        // View object settings
        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.textColor = .white
        cellLabel.textAlignment = .left
        cellLabel.font = UI.Font.headerFont
        //
        addSubview(remove)
        remove.translatesAutoresizingMaskIntoConstraints = false
        remove.titleLabel?.font = UI.Font.headerFont
        remove.setTitle("X", for: .normal)
        remove.setTitleColor(.white, for: .normal)
        remove.addTarget(self, action: #selector(removeAlc), for: .touchUpInside)
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            cellLabel.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding-UI.Sizing.headerHeight),
            cellLabel.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            remove.centerYAnchor.constraint(equalTo: centerYAnchor),
            remove.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            remove.widthAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            remove.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight)
            ])
    }
    
    @objc func removeAlc(sender: AnyObject) {
        generateSuccessVibration()
        delegate?.remove(cell: self)
    }
    
    func generateSuccessVibration() {
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
