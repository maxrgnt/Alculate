//
//  Extensions.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

//MARK: UIView
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}

//MARK: String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func removeInvalidNameCharacters() -> String {
        let badHombres = ":,;!@#$%^&*()_-=+[{]}|<>./?" // 1234567890
        let invalidSet = CharacterSet.init(charactersIn: badHombres)
        return self.trimmingCharacters(in: invalidSet).trimmingCharacters(in: .newlines)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

//MARK: CALayer
extension CALayer {
    func addGradientBorder(colors:[UIColor],width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0,y:1.0)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }
}

/*
UIView.animate(withDuration: 0.55, delay: 0.0,
    // 1.0 is smooth, 0.0 is bouncy
    usingSpringWithDamping: 0.7,
    // 1.0 corresponds to the total animation distance traversed in one second
    // distance/seconds, 1.0 = total animation distance traversed in one second
    initialSpringVelocity: 1.0,
    options: [.curveEaseInOut],
    // [autoReverse, curveEaseIn, curveEaseOut, curveEaseInOut, curveLinear]
    animations: {
        //Do all animations here
        self.view.layoutIfNeeded()
}, completion: {
       //Code to run after animating
        (value: Bool) in
    }
)
*/

//let header = UIView(frame: CGRect(x: 0, y: 0, width: UI.Sizing.width/3, height: UI.Sizing.headerHeight*(1/2)))
//let header = ComparisonHeader()
//tableHeaderView = header
//tableHeaderView?.layoutIfNeeded()
//tableHeaderView = tableHeaderView
//let footer = UIView(frame: CGRect(x: 0, y: 0, width: UI.Sizing.width, height: UI.Sizing.objectPadding/2))
//footer.backgroundColor = backgroundColor
//tableFooterView = footer

/*
func updateTableContentInset() {
    // number of rows in table
    let numRows = tableView(self, numberOfRowsInSection: 0)
    // content inset
    var contentInsetTop = UI.Sizing.comparisonTableHeight
    // Reset inest based on rows in table
    contentInsetTop -= CGFloat(numRows)*UI.Sizing.comparisonRowHeight
    // If the inset is less than 0 make it 0
    contentInsetTop = (contentInsetTop < 0) ? 0 : contentInsetTop
    // Reset the inset
    self.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    //
    let lastCell = listForThisTable().count-1
    if lastCell > 0 {
        let indexPath = IndexPath(row: lastCell, section: 0)
        scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
*/

//DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//    background.sync { self.moveDrinkLibrary(to: "visible") }
//}

//    var gradient = CAGradientLayer()
//    var gradient2 = CAGradientLayer()
//    // MARK: Gradient Settings
//    func buildGradient() {
//        // Set origin of gradient (top left of screen)
//        let gradientOrigin = CGPoint(x: 0,y: UI.Sizing.DrinkLibrary.Header.height)
//        // Set frame of gradient (header height, because status bar will be solid color)
//        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.DrinkLibrary.Table.height)
//        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
//        // Set color progression for gradient, alphaComponent of zero important for color shifting to
//        gradient.colors = [UI.Color.Gradient.dark.withAlphaComponent(1.0).cgColor,
//                           UI.Color.Gradient.light.withAlphaComponent(1.0).cgColor]
//        // Set locations of where gradient will transition
//        gradient.locations = [0.0,1.0]
//        // Add gradient as bottom layer in sublayer array
//        self.layer.insertSublayer(gradient, at: 0)
//
//        // Set origin of gradient (top left of screen)
//        let gradientOrigin2 = CGPoint(x: 0,y: 0)
//        // Set frame of gradient (header height, because status bar will be solid color)
//        let gradientSize2 = CGSize(width: UI.Sizing.width, height: UI.Sizing.DrinkLibrary.Header.height)
//        gradient2.frame = CGRect(origin: gradientOrigin2, size: gradientSize2)
//        // Set color progression for gradient, alphaComponent of zero important for color shifting to
//        gradient2.colors = [UI.Color.Gradient.darkest.withAlphaComponent(1.0).cgColor,
//                            UI.Color.Gradient.darkest.withAlphaComponent(1.0).cgColor,
//                           UI.Color.Gradient.darkest.withAlphaComponent(1.0).cgColor]
//        // Set locations of where gradient will transition
//        gradient2.locations = [0.0,0.1,1.0]
//        // Add gradient as bottom layer in sublayer array
//        self.layer.insertSublayer(gradient2, at: 0)
//    }
