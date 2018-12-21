//
//  DateTableCell.swift
//  Tugo
//
//  Created by Alex on 10/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class DateTableCell: UITableViewCell {
    var setSchedules: Schedule?{
        didSet {
            setupCell()
        }
    }
    

    @IBOutlet weak var backgroundUIView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var booKlabel: UILabel!
    let dateFormatter = DateFormatter()
    let locale = Locale(identifier: "es_GT")
   
    func setupCell(){
        guard let schedules = setSchedules else{return}
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = locale
        let date = dateFormatter.date(from: schedules.startDate)
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        let dateFormatted =  dateFormatter.string(from: date!)
        
        dateLabel.text = dateFormatted
        
        booKlabel.text = "\(schedules.availableReservations.description) cupos disponibles"
    }
    
    
}
