//
//  TripDetailDateTableCell.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import TagListView

class TripDetailDateTableCell: UITableViewCell {

    var setSchedule: Schedule?{
        didSet {
            setupCell()
        }
    }
    
    var setScheduleUpdated: ScheduleUpdated?{
        didSet {
            setupCellTrip()
        }
    }
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    override func prepareForReuse() {
        tagListView.removeAllTags()
        setSchedule = nil
    }
    
    func setupCell(){
        
        guard let schedule = setSchedule else { return}
        
        guard let month = transformStringDate(schedule.startDate, fromDateFormat: "yyyy-MM-dd", toDateFormat: "MMM") else{return}
        monthLabel.text = month
        
        guard let day = transformStringDate(schedule.startDate, fromDateFormat: "yyyy-MM-dd", toDateFormat: "dd") else{return}

        tagListView.addTags([day])
        
    }
    
    func setupCellTrip(){
        
        guard let schedule = setScheduleUpdated else { return}
        guard let startTime = schedule.startTime else {return}
        guard let startDate = schedule.startTime else {return}
        
        guard let month = transformStringDate(startTime, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "MMM") else{return}
        monthLabel.text = month
        
        guard let day = transformStringDate(startDate, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "dd") else{return}
        
        tagListView.addTags([day])
        
    }
    
    func transformStringDate(_ dateString: String,
                             fromDateFormat: String,
                             toDateFormat: String) -> String? {
        
        let initalFormatter = DateFormatter()
        initalFormatter.dateFormat = fromDateFormat
        
        guard let initialDate = initalFormatter.date(from: dateString) else {
            print ("Error in dateString or in fromDateFormat")
            return nil
        }
        
        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = toDateFormat
        
        return resultFormatter.string(from: initialDate)
    }
    
    
}
