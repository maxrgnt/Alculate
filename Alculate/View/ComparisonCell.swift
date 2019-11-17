//
//  ComparisonCell.swift
//  Alculate
//
//  Created by Max Sergent on 10/10/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

// Protocol to communicate with tableview/viewcontroller
protocol ComparisonCellDelegate: AnyObject {
    func delegateCell(animate: Bool, forCell: ComparisonCell)
    func delegateRemove(forCell: ComparisonCell)
    func delegatePopulate(forCell: ComparisonCell)
}

class ComparisonCell: UITableViewCell {
  
    // Delegate object for Protocol above
    var delegate: ComparisonCellDelegate?

    // Constraints
    var containerWidth: NSLayoutConstraint!
    var containerHeight: NSLayoutConstraint!
    var containerLeading: NSLayoutConstraint!
    
    // Objects
    let container = ComparisonContainer()
    let delete = UIButton()

    // Variables
    var needsConstraints = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // MARK: - View/Object Settings
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "ComparisonCell")
        
        // Miscelaneous view settings
        selectionStyle = .none
        backgroundColor = .clear
        //
        addSubview(container)
        container.build()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressActivated))
        container.addGestureRecognizer(longPressRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapActivated))
        container.addGestureRecognizer(tapRecognizer)
        //
        addSubview(delete)
        delete.alpha = 0.0
        delete.backgroundColor = .lightGray
        delete.setTitle("X", for: .normal)
        delete.setTitleColor(UI.Color.bgDarker, for: .normal)
        delete.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        delete.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.comparisonRemoveRadius)
    
        // MARK: - NSLayoutConstraints
        for obj in [container,delete] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        containerWidth = container.widthAnchor.constraint(equalToConstant: UI.Sizing.containerDiameter)
        containerHeight = container.heightAnchor.constraint(equalToConstant: UI.Sizing.containerHeight)
        containerLeading = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            containerWidth,
            containerLeading,
            containerHeight,
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            delete.widthAnchor.constraint(equalToConstant: UI.Sizing.comparisonRemoveDiameter),
            delete.heightAnchor.constraint(equalToConstant: UI.Sizing.comparisonRemoveDiameter),
            delete.trailingAnchor .constraint(equalTo: container.trailingAnchor , constant: UI.Sizing.comparisonRemoveOffset),
            delete.topAnchor.constraint(equalTo: container.topAnchor, constant: -UI.Sizing.comparisonRemoveOffset),
            ])
    }
    
    // MARK: - Label Setter
    func setLabels(with info: (name: String, abv: String, size: String, price: String)) {
        container.drinkName.text = "\(info.name.capitalized)"
        // convert price to $X.00 format
        let price = String(format: "%.2f", Double(info.price)!)
        // get the unitForSize by dropping the first part of string
        // using length of string minus the last two characters (oz or ml) ex. 24ml
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        // get the size by dropping last two characters (oz or ml) ex. 24ml
        let size = info.size.dropLast(2)
        // set info using price and size piece
        container.drinkInfo.text = "\(info.size.dropLast(2)) \(sizeUnit) | $\(price)"
        var correctedSize = Double(size)!
        // if unitForSize is ml, need to convert to oz for calculations
        if sizeUnit == "ml" {
            // convert ml size to ounces using ratio of ml per oz
            correctedSize = correctedSize/29.5735296875
        }
        // calculate the effectiveness
        let abvAsDecimal = (0.01)*Double(info.abv)!
        let standardShot = (0.4 /*ABV*/ * 1.5 /*oz*/) // = 0.6
        let effect = (abvAsDecimal*correctedSize)/standardShot
        // calculate the value
        let value = Double(info.price)!/effect
        container.value.text = "$"+String(format: "%.2f", value)
        container.effect.text = String(format: "%.1f", effect)
    }
    
    // MARK: - Gesture Recognizers
    @objc func longPressActivated(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.delegateCell(animate: true, forCell: self)
        }
    }
    
    @objc func tapActivated(_ sender: UITapGestureRecognizer) {
        (delete.alpha == 1.0) ? delegate?.delegateCell(animate: false, forCell: self) : delegate?.delegatePopulate(forCell: self)
    }
    
    @objc func deleteButtonPressed() {
        delegate?.delegateRemove(forCell: self)
    }
    
    // MARK: - Animation Functions
    func rotateTo(frac: Double) {
        // update view before animating
        self.layoutIfNeeded()
        // animate to the frac rotation
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat]
            , animations: ({
                // set rotation as animation
                self.container.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * frac))
                self.delete.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * frac))
                // update view as animation
                self.layoutIfNeeded()
            })
        )
    }
    
    func beginAnimating() {
        // shrink the container to desired size
        containerWidth.constant = UI.Sizing.containerDeleteSize
        containerHeight.constant = UI.Sizing.containerDeleteHeight
        // set starting animation
        UIView.animate(withDuration: 0.2, delay: 0
            , animations: ({
                // hide delete button
                self.delete.alpha = 1.0
                // animate shrinking of sizes above
                self.layoutIfNeeded()
            }), completion: { (completed) in
                // begin rotations
                self.rotateTo(frac: 0.025)
            }
        )
    }
    
    func stopAnimating(restartAnimations: Bool) {
        if !restartAnimations {
            // reset container sizes
            containerWidth.constant = UI.Sizing.containerDiameter
            containerHeight.constant = UI.Sizing.containerHeight
        }
        UIView.animate(withDuration: 0.3, delay: 0//, options: .repeat
            , animations: ({
                // hide delete button
                self.delete.alpha = 0.0
                // reset rotation animation
                self.container.transform = .identity
                self.delete.transform = .identity
                // reset scaling animation
                self.layoutIfNeeded()
            }), completion: { (completed) in
                // once back to identity, remove all animations to be safe
                self.subviews.forEach({$0.layer.removeAllAnimations()})
                self.layer.removeAllAnimations()
                // if restarting deletes, proceed
                if restartAnimations {
                    self.beginAnimating()
                }
            }
        )
    }
    
    func resetConstraints() {
        // reset border color
        self.container.layer.borderColor = UI.Color.bgDarkest.cgColor
        // hide delete button
        self.delete.alpha = 0.0
        // reset container sizes
        containerWidth.constant = UI.Sizing.containerDiameter
        containerHeight.constant = UI.Sizing.containerHeight
        // rotate back to normal
        self.container.transform = .identity
        self.delete.transform = .identity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
