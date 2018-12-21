//
//  UIDatePicker+Validation.swift
//  Tugo
//
//  Created by Alex on 13/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension UIDatePicker {
    
    func setYearValidation(year: Int) {
        let currentDate: NSDate = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.year = -year
        let maxDate: NSDate = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        components.year = -150
        let minDate: NSDate = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        self.minimumDate = minDate as Date
        self.maximumDate = maxDate as Date
    }
}
