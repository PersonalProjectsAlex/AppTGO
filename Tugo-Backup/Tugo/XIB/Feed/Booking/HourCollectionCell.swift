//
//  HourCollectionCell.swift
//  Tugo
//
//  Created by Alex on 24/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class HourCollectionCell: UICollectionViewCell {
    var setSchedules: Schedule?{
        didSet {
            setupCell()
        }
    }
    
    
    @IBOutlet weak var backgroundUIView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    
    
    func setupCell(){
        guard let schedules = setSchedules else{return}
        hourLabel.text = schedules.startHour
        
    }
    
    
}
