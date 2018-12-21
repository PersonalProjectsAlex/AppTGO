//
//  AddScheduleTableCell.swift
//  Tugo
//
//  Created by Alex on 1/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class AddScheduleTableCell: UITableViewCell {

    var setHour: String?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var atLabel: UILabel!
    
    func setupCell(){
        guard let hour = setHour else{return}
        var items = hour.components(separatedBy: ":")
        var items2 = hour.components(separatedBy: " ")
        hourLabel.text = items[0]
        
        let result = String(items[1].filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        minuteLabel.text = result
        
        let at = String(items2[1].filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "AMPM")) != nil })
        atLabel.text = at
        
    }
    
}
