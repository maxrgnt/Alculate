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
}

class ComparisonCell: UITableViewCell {
  
    // Delegate object for Protocol above
    var delegate: ComparisonCellDelegate?

    // Constraints
    var containerWidth: NSLayoutConstraint!
    var containerHeight: NSLayoutConstraint!
    
    // Objects
    let container = ComparisonContainer()
    let delete = UIButton()

    // Variables
    var continueAnimating = false
    
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
        delete.backgroundColor = .red
        delete.setTitle("X", for: .normal)
        delete.setTitleColor(UI.Color.softWhite, for: .normal)
        delete.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        delete.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.comparisonRemoveRadius)
    }
    
    func setConstraints(withLeading leadingConstant: CGFloat, withTrailing trailingConstant: CGFloat) {
        // MARK: - NSLayoutConstraints
        for obj in [container,delete] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        containerWidth = container.widthAnchor.constraint(equalToConstant: UI.Sizing.containerDiameter)
        containerHeight = container.heightAnchor.constraint(equalToConstant: UI.Sizing.containerDiameter)
        NSLayoutConstraint.activate([
            containerWidth,
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant),
            containerHeight,
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            delete.widthAnchor.constraint(equalToConstant: UI.Sizing.comparisonRemoveDiameter),
            delete.heightAnchor.constraint(equalToConstant: UI.Sizing.comparisonRemoveDiameter),
            delete.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: UI.Sizing.comparisonRemoveOffset),
            delete.topAnchor.constraint(equalTo: container.topAnchor, constant: -UI.Sizing.comparisonRemoveOffset),
            ])
    }
    
    // MARK: - Label Setter
    func setLabels(with info: (name: String, abv: String, size: String, price: String)) {
        container.drinkName.text = "\(info.name.capitalizingFirstLetter())"
        // convert price to $X.00 format
        let price = String(format: "%.2f", Double(info.price)!)
        // get the unitForSize by dropping the first part of string
        // using length of string minus the last two characters (oz or ml) ex. 24ml
        let unitForSize = info.size.dropFirst(info.size.count-2)
        // get the size by dropping last two characters (oz or ml) ex. 24ml
        let size = info.size.dropLast(2)
        // set info using price and size piece
        container.drinkInfo.text = "\(info.abv) | \(info.size.dropLast(2)) \(unitForSize) | $\(price)"
        var correctedSize = Double(size)!
        // if unitForSize is ml, need to convert to oz for calculations
        if unitForSize == "ml" {
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
        // Do I need to check this? Can it just always stop animating when tapped, what is best practice?
        if continueAnimating == true {
            delegate?.delegateCell(animate: false, forCell: self)
        }
    }
    
    @objc func removeButtonPressed() {
        delegate?.delegateRemove(forCell: self)
    }
    
    // MARK: - Animation Functions
    func rotateTo(frac: Double) {
        // update view before animating
        self.layoutIfNeeded()
        // animate to the frac rotation
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction] //.repeat
            , animations: ({
                // set rotation as animation
                self.container.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * frac))
                self.delete.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * frac))
                // update view as animation
                self.layoutIfNeeded()
            }), completion: { (completed) in
                // once animation complete, check if should repeat
                if self.continueAnimating == true {
                    // if should repeat, rotate to opposite side
                    self.rotateTo(frac: -frac)
                }
                else {
                    // if should not repeat, do nothing
                }
            }
        )
    }
    
    func beginAnimating() {
        // shrink the container to desired size
        containerWidth.constant = UI.Sizing.comparisonContainerShrunk
        containerHeight.constant = UI.Sizing.comparisonContainerShrunk
        // permit animations
        continueAnimating = true
        // set starting animation
        UIView.animate(withDuration: 0.3, delay: 0
            , animations: ({
                // hide delete button
                self.delete.alpha = 1.0
                // animate shrinking of sizes above
                self.layoutIfNeeded()
            }), completion: { (completed) in
                // begin rotations
                self.rotateTo(frac: 0.03)
            }
        )
    }
    
    func stopAnimating(restartAnimations: Bool) {
        // stop rotateTo(frac: ) from repeating
        continueAnimating = false
        //
        if !restartAnimations {
            // hide delete button
            self.delete.alpha = 0.0
            // reset container sizes
            containerWidth.constant = UI.Sizing.containerDiameter
            containerHeight.constant = UI.Sizing.containerDiameter
        }
        UIView.animate(withDuration: 0.3, delay: 0//, options: .repeat
            , animations: ({
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
