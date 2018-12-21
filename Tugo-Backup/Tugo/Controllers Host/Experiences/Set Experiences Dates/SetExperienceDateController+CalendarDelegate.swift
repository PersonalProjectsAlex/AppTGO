//
//  SetExperienceDateController+CalendarDelegate.swift
//  Tugo
//
//  Created by Alex on 20/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit

extension SetExperienceDateController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
   
    func setupMonthLabel(date: Date) {
        df.locale = Locale(identifier: "es_SV")
        df.dateFormat = "MMMM"
        let a  = df.string(from: date)
        monthLabel.text = a.description.capitalizingFirstLetter()
        
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CellView else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
       
    }
    
    func handleCellColor(cell: CellView, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.label.textColor = .gray
        } else {
            cell.label.textColor = .clear
        }
    }
    
    func handleCellSelection(cell: CellView, cellState: CellState) {
        
        cell.selectedView.isHidden = !cellState.isSelected
        
        
            if cellState.dateBelongsTo != .thisMonth {
                 cell.selectedView.isHidden = true
                
            }
        
        
      
          cell.selectedView.layer.cornerRadius =  13
        let backgroundImage: UIImageView = UIImageView(frame: cell.selectedView.bounds)
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.image = #imageLiteral(resourceName: "calendarcircle")
        cell.selectedView.addSubview(backgroundImage)
        cell.selectedView.backgroundColor = .clear
        
    }
    

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
      
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        cell.label.text = cellState.text
      
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print(date)
        
        if cellState.dateBelongsTo == .thisMonth {
            handleConfiguration(cell: cell, cellState: cellState)
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print(date)
        handleConfiguration(cell: cell, cellState: cellState)
       
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = Date()
        let endDate = df.date(from: "2035 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday)
       
        return parameter
    }
    
    
   
    
}

