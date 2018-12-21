//
//  EditScheduleTableCell.swift
//  Tugo
//
//  Created by Alex on 9/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class EditScheduleTableCell: UITableViewCell {

    
    var setDate: ScheduleTemp?{
        didSet {
            setupCell()
        }
    }
    
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setupCell(){
        guard let date = setDate else {return}
        if let date = date.date{
            dateLabel.text = date
        }
        
    }
    
}
