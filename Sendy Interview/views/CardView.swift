//
//  CardView.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 1
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = .black
    @IBInspectable var shadowOpacity: Float = 0.2
    @IBInspectable var showTopLeftRadius: Bool = true
    @IBInspectable var showTopRightRadius: Bool = true
    @IBInspectable var showBottomLeftRadius: Bool = true
    @IBInspectable var showBottomRightRadius: Bool = true
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
        var corners: [Corner] = []
        if showTopRightRadius {
            corners.append(.topRight)
        }
        
        if showTopLeftRadius {
            corners.append(.topLeft)
        }
        
        if showBottomLeftRadius {
            corners.append(.bottomLeft)
        }
        
        if showBottomRightRadius {
            corners.append(.bottomRight)
        }
        
        if #available(iOS 11.0, *) {
            layer.maskedCorners = CACornerMask(rawValue: createMask(corners: corners))
        } 
    }
    
    private func createMask(corners: [Corner]) -> UInt {
        return corners.reduce(0, { (a, b) -> UInt in
            return a + parseCorner(corner: b).rawValue
        })
    }
    
    enum Corner:Int {
        case bottomRight = 0,
        topRight,
        bottomLeft,
        topLeft
    }
    
    private func parseCorner(corner: Corner) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[corner.rawValue]
    }
    
}
