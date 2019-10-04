//
//  TableOneCell.swift
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
    let header = UILabel()
    let stub = UILabel()
    let remove = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableOneCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .black
        // View object settings
        addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.textColor = .white
        header.textAlignment = .left
        header.font = UI.Font.cellHeaderFont
        addSubview(stub)
        stub.translatesAutoresizingMaskIntoConstraints = false
        stub.textColor = .lightGray
        stub.alpha = 0.7
        stub.textAlignment = .left
        stub.font = UI.Font.cellStubFont
        //
        addSubview(remove)
        remove.translatesAutoresizingMaskIntoConstraints = false
        remove.titleLabel?.font = UI.Font.cellHeaderFont
        remove.setTitle("X", for: .normal)
        remove.setTitleColor(.white, for: .normal)
        remove.addTarget(self, action: #selector(removeAlc), for: .touchUpInside)
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding-UI.Sizing.headerHeight),
            header.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight*2/3),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            header.topAnchor.constraint(equalTo: topAnchor),
            stub.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding-UI.Sizing.headerHeight),
            stub.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight/3),
            stub.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            stub.bottomAnchor.constraint(equalTo: bottomAnchor),
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
