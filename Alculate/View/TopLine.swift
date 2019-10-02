//
//  TopLine.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TopLine: UIView {
         
    var nameLeading = NSLayoutConstraint()
    var statLeading = NSLayoutConstraint()
    var changeTrailing = NSLayoutConstraint()
    var calcMoney = true
    
    // Objects
    let name = UILabel()
    let stat = UILabel()
    let change = UIButton()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        clipsToBounds = true
        // Object settings
        addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .black
        name.font = UI.Font.headerFont
        name.textAlignment = .left
        //
        addSubview(stat)
        stat.translatesAutoresizingMaskIntoConstraints = false
        stat.textColor = .black
        stat.font = UI.Font.headerFont
        stat.textAlignment = .left
        //
        addSubview(change)
        change.translatesAutoresizingMaskIntoConstraints = false
        change.setTitleColor(.black, for: .normal)
        change.titleLabel?.font = UI.Font.headerFont
        change.contentHorizontalAlignment = .right
        change.contentVerticalAlignment = .center
        change.setTitle("xX", for: .normal)
        change.addTarget(self, action: #selector(changeCalc), for: .touchUpInside)
        // MARK: - NSLayoutConstraints
        nameLeading = name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding)
        statLeading = stat.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding)
        changeTrailing = change.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding*0.7),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            nameLeading,
            name.topAnchor.constraint(equalTo: topAnchor),
            stat.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding*0.7),
            stat.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            statLeading,
            stat.bottomAnchor.constraint(equalTo: bottomAnchor),
            change.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding*0.3),
            change.heightAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding*0.3),
            changeTrailing,
            change.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    @objc func changeCalc() {
        if calcMoney {
            name.textAlignment = .right
            stat.textAlignment = .right
            nameLeading.constant = UI.Sizing.widthObjectPadding*0.3+UI.Sizing.objectPadding
            statLeading.constant = UI.Sizing.widthObjectPadding*0.3+UI.Sizing.objectPadding
            change.contentHorizontalAlignment = .left
            changeTrailing.constant = -UI.Sizing.widthObjectPadding*0.7-UI.Sizing.objectPadding
            change.setTitle("$", for: .normal)
            stat.text = "1.2x"
        }
        else {
            name.textAlignment = .left
            stat.textAlignment = .left
            nameLeading.constant = UI.Sizing.objectPadding
            statLeading.constant = UI.Sizing.objectPadding
            change.contentHorizontalAlignment = .right
            changeTrailing.constant = -UI.Sizing.objectPadding
            change.setTitle("Xx", for: .normal)
            stat.text = "$3.43x"
        }
        calcMoney = !calcMoney
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
