//
//  CellView.swift
//  testApplicationCalendar
//
//  Created by JayT on 2016-03-04.
//  Copyright © 2016 OS-Tech. All rights reserved.
//


import JTAppleCalendar

class CellView: JTAppleCell {
    
   
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var label: UILabel!
    
    
    
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        selectedView.layer.masksToBounds = true
        selectedView.clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // selectedView.frame = CGRect(x: selectedView.frame.origin.x, y: selectedView.frame.origin.y + 8, width:34, height:34)
        let radius = selectedView.frame.width/2.0
        selectedView.cornerRadiusView =  radius
        
    }
    
}
