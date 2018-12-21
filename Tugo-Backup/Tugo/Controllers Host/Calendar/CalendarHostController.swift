//
//  CalendarHostController.swift
//  Tugo
//
//  Created by Alex on 1/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import CalendarKit
import Alamofire
import DateToolsSwift
import EventKit
import HexColors

class CalendarHostController: DayViewController{
    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    let locale = Locale(identifier: "es_GT")
    var mySchedules = MyShedules()
    
    // MARK: - LifeCycles
    
    
    override func viewWillAppear(_ animated: Bool) {
        gettingData()
         let header = DayHeaderStyle()
       
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        
        //Instance for events for calendar
        var events = [Event]()
        
        
        //Checking events from API
        if mySchedules.count > 0{
            self.title = "bjkbkk"
            for model in mySchedules {
                
                
                if let startDate = model.startTime, let endDate = model.endTime, let name = model.experience?.name, let reservations = model.confirmedReservations{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let event = Event()
                    if let startDate = dateFormatter.date(from: startDate) {
                        event.startDate = startDate
                    }
                    
                    if let endDate =  dateFormatter.date(from: endDate){
                        event.endDate = endDate
                    }
                    
                    if let startDate = stringToDate(dates: startDate), let endDate = stringToDate(dates: endDate){
                        let str = NSMutableAttributedString()
                        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "CircularStd-Black", size: 15.0)!, NSAttributedStringKey.foregroundColor: HexColor(K.colors.purple)!]
                        str.append(NSAttributedString(string:  "\(name.capitalizingFirstLetter())", attributes: myAttribute))
                        
                        str.append(NSAttributedString(string: "\n\(startDate)-\(endDate)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray]))
                        event.attributedText = str
                        
                        
                      //  event.attributedText = NSAttributedString(string:"\(name.capitalizingFirstLetter())\n\(startDate)-\(endDate)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
                    }
                    
                    
                    event.textColor = .white
                    event.backgroundColor = HexColor("#F8F8F8")!
                    
                    events.append(event)
                }
               
                
            }
        }
        return events
    }
    
    
    
    func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let params:Parameters = ["page": 1, "per_page": 35]
        HostManager().getSchedule(header: header, params: params) {
            schedule in
            guard let schedule = schedule else{return}
            weak.mySchedules = schedule
            weak.reloadData()
            print(schedule)
            
        }
    }
    
    
    func stringToDate(dates:String) -> String?{
        var dateTemp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
        if let date = dateFormatter.date(from: dates) {
            dateTemp = date
        }
        print(dateTemp)

        
        return  formatDateFromCalendar(dates: dateTemp)
    }
    
    func formatDateFromCalendar(dates:Date) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: dates.description)
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: date!)
        
    }
    
    
}
