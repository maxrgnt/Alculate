//
//  TextEntry.swift
//  Alculate
//
//  Created by Max Sergent on 10/14/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol TextEntryDelegate: AnyObject {
    func hideTextEntry()
}

class TextEntry: UIView, UITextFieldDelegate {
 
    // Delegate object for Protocol above
    var textEntryDelegate: TextEntryDelegate?

    // Constraints
    var top: NSLayoutConstraint!
    
    // Objects
    let field = UITextField()
    let navigator = TextNavigator()
    let icon = UIImageView()
    let name = UIButton()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.textEntryRadius)
        layer.borderWidth = UI.Sizing.containerBorder*2
        layer.borderColor = UI.Color.alculatePurpleLite.cgColor
        addSubview(field)
        field.delegate = self
        field.autocorrectionType = .no
        // Blur object settings
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        // Vibrancy object settings
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        //
        vibrancyView.contentView.addSubview(navigator)
        navigator.build()
        for button in [navigator.exit,navigator.backward,navigator.forward] {
            button.addTarget(self, action: #selector(navigateTextEntry), for: .touchUpInside)
        }
        //
        addSubview(icon)
        //
        let titles = ["Begin typing Name"]
        for (i,field) in [name].enumerated() {
            field.tag = i
            addSubview(field)
            field.setTitle(titles[i], for: .normal)
            field.contentHorizontalAlignment = .left
            field.setTitleColor(UI.Color.softWhite, for: .normal)
        }
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        for obj in [icon,name] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryHeight+UI.Sizing.textEntryBounceBuffer),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            top,
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            vibrancyView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            vibrancyView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            name.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.objectPadding),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldHeight),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldWidth),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            icon.bottomAnchor.constraint(equalTo: name.bottomAnchor),
            icon.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
            icon.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding)
            ])
    }

    @objc func navigateTextEntry(sender: UIButton) {
        print("c: \(top.constant) top: \(UI.Sizing.textEntryTop) max:\(UI.Sizing.textEntryTopMax) tag: \(sender.tag)")
        if sender.tag == 0 {
            self.textEntryDelegate?.hideTextEntry()
        }
        else {
            if (top.constant < UI.Sizing.textEntryTop && sender.tag == -1) {
                top.constant += CGFloat(-sender.tag)*UI.Sizing.headerHeight
            }
            else if (top.constant > UI.Sizing.textEntryTopMax && sender.tag == 1) {
                top.constant += CGFloat(-sender.tag)*UI.Sizing.headerHeight
            }
            UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3,
                           options: [.curveEaseOut], animations: {
                            self.superview!.layoutIfNeeded()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
