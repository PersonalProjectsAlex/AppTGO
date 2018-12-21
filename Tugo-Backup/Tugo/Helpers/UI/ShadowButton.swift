//
//  ShadowButton.swift
//  Tugo
//
//  Created by Alex on 21/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//
import UIKit

class CustomButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 1
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
}
