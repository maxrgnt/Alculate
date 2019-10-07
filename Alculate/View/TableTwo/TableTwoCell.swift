//
//  TableTwoCell.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol TableTwoCellDelegate: AnyObject {
    func cellWillDelete(cell: TableTwoCell)
    func stopDelete(cell: TableTwoCell)
    func remove(cell: TableTwoCell)
}

class TableTwoCell: UITableViewCell {
  
    /*weak*/ var delegate: TableTwoCellDelegate?

    var cellObjectWidth: NSLayoutConstraint!
    var cellObjectHeight: NSLayoutConstraint!
    
    // Objects
    let cellObject = UIView()
    let delete = UIButton()
    
    var type = ""
    let name = UILabel()
    let size = UILabel()
    let otherStat = UILabel()
    let sortedStat = UILabel()
    
    var continueAnimating = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "TableTwoCell")
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .lightGray
        //
        addSubview(cellObject)
        cellObject.clipsToBounds = false
        cellObject.translatesAutoresizingMaskIntoConstraints = false
        cellObject.backgroundColor = .clear
        cellObject.layer.borderWidth = UI.Sizing.cellObjectBorder
        cellObject.layer.borderColor = UIColor.black.cgColor
        cellObject.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: UI.Sizing.cellObjectRadius)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        cellObject.addGestureRecognizer(longPressRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        cellObject.addGestureRecognizer(tapRecognizer)
        // View object settings
        for label in [name, size, otherStat, sortedStat] {
            cellObject.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.textAlignment = .left
            label.font = UI.Font.cellStubFont
        }
        size.alpha = 0.7
        name.font = UI.Font.cellHeaderFont
        sortedStat.font = UI.Font.cellHeaderFont
        otherStat.alpha = 0.7
        //
        addSubview(delete)
        delete.alpha = 0.0
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.backgroundColor = .red
        delete.setTitle("X", for: .normal)
        delete.setTitleColor(.white, for: .normal)
        delete.addTarget(self, action: #selector(remove), for: .touchUpInside)
        delete.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.cellObjectWidth/8)
        // MARK: - NSLayoutConstraints
        cellObjectWidth = cellObject.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth)
        cellObjectHeight = cellObject.heightAnchor.constraint(equalToConstant: UI.Sizing.cellObjectHeight)
        NSLayoutConstraint.activate([
            cellObjectWidth,
            cellObjectHeight,
            cellObject.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellObject.bottomAnchor.constraint(equalTo: bottomAnchor),
            delete.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth/4),
            delete.heightAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth/4),
            delete.trailingAnchor.constraint(equalTo: cellObject.trailingAnchor, constant: UI.Sizing.cellObjectWidth/12),
            delete.topAnchor.constraint(equalTo: cellObject.topAnchor, constant: -UI.Sizing.cellObjectWidth/12),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            name.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            name.topAnchor.constraint(equalTo: cellObject.topAnchor, constant: UI.Sizing.cellObjectBorder),
            size.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder*2),
            size.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/6),
            size.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            size.topAnchor.constraint(equalTo: name.bottomAnchor),
            sortedStat.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder),
            sortedStat.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/5),
            sortedStat.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            sortedStat.topAnchor.constraint(equalTo: size.bottomAnchor),
            otherStat.widthAnchor.constraint(equalToConstant: UI.Sizing.cellObjectWidth-UI.Sizing.cellObjectBorder),
            otherStat.heightAnchor.constraint(equalToConstant: UI.Sizing.tableViewWidth/6),
            otherStat.leadingAnchor.constraint(equalTo: cellObject.leadingAnchor, constant: UI.Sizing.cellObjectBorder*2),
            otherStat.topAnchor.constraint(equalTo: sortedStat.bottomAnchor)
            ])
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.cellWillDelete(cell: self)
        }
    }
    
    @objc func tapPressed(_ sender: UITapGestureRecognizer) {
        if continueAnimating == true {
            delegate?.stopDelete(cell: self)
        }
    }
    
    @objc func remove() {
        delegate?.remove(cell: self)
    }
    
    func beginDeleteAnimation() {
        cellObjectWidth.constant = UI.Sizing.cellObjectWidth*0.92
        cellObjectHeight.constant = UI.Sizing.cellObjectHeight*0.92
        continueAnimating = true
        UIView.animate(withDuration: 0.3, delay: 0//, options: .repeat
        , animations: ({
            self.delete.alpha = 1.0
            self.layoutIfNeeded()
        }))
        rotateTo(frac: 0.05)
    }
    
    func rotateTo(frac: Double) {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction] //.repeat
            , animations: ({
                self.cellObject.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * frac))
                self.delete.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * frac))
                self.layoutIfNeeded()
            }), completion: { (completed) in
                if self.continueAnimating == true {
                    self.rotateTo(frac: -frac)
                }
            }
        )
    }
    
    func nukeAllAnimations() {
        cellObjectWidth.constant = UI.Sizing.cellObjectWidth
        cellObjectHeight.constant = UI.Sizing.cellObjectHeight
        UIView.animate(withDuration: 0.3, delay: 0//, options: .repeat
        , animations: ({
            self.delete.alpha = 0.0
            self.layoutIfNeeded()
            self.cellObject.transform = .identity
            self.delete.transform = .identity
        }))
        continueAnimating = false
        self.subviews.forEach({$0.layer.removeAllAnimations()})
        self.layer.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
