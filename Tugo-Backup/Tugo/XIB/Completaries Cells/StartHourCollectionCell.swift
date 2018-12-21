//
//  StartHourCollectionCell.swift
//  Tugo
//
//  Created by Alex on 22/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class StartHourCollectionCell: UICollectionViewCell {

    var setSchedule: ScheduleUpdated?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var hourLabel: UILabel!
    
    
    func setupCell(){
        guard let schedule = setSchedule, let startTime = schedule.startTime else{return}
        
        hourLabel.text = startTime
    }

}
