//
//  RoundedImageView.swift
//  Tugo
//
//  Created by Alex on 25/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import TagListView


class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = self.frame.width/2.0
        layer.cornerRadius = radius
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque , 0.0)
        clipsToBounds = true // This could get called in the (requiered) initializer
        // or, ofcourse, in the interface builder if you are working with storyboards
    }
    
}


@IBDesignable public class SwiftyAvatar: UIImageView {
    
    init(size:CGFloat = 200, roundess:CGFloat = 2, borderWidth:CGFloat = 5, borderColor:UIColor = UIColor.blue, background:UIColor = UIColor.clear){
        self.roundness = roundess
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.background = background
        
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var roundness: CGFloat = 2 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 5 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var background: UIColor = UIColor.clear {
        didSet{
            setNeedsLayout()
        }
    }
    
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / roundness
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = background.cgColor
        clipsToBounds = true
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: bounds.width / roundness)
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        layer.mask = mask
    }
}




