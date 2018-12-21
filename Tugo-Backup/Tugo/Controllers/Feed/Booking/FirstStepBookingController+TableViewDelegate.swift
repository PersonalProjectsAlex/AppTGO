//
//  FirstStepBookingController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 10/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import HexColors

extension FirstStepBookingController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSchedules.count > 0 ? selectedSchedules.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: K.cells.table.dateTableCell, for: indexPath) as? DateTableCell else { return UITableViewCell() }
        if selectedSchedules.count > 0{
            cell.setSchedules = selectedSchedules[indexPath.row]
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get a reference to our storyboard cell
        
        
        selectedIndexPath = indexPath
       
        highlightCellHour(color: .orange, color2: .white, at: indexPath, schedule: selectedSchedules[indexPath.row])
        
        maxPeople = selectedSchedules[indexPath.row].availableReservations
        saveScehdule = selectedSchedules[indexPath.row]
        enableButton()
        guard let cell = tableView.cellForRow(at: indexPath) as? DateTableCell else{return}
        highlightCell(cell: cell, color: .orange, textColor: .white, at: indexPath.row.description)
       
    }
   
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DateTableCell else{return}
        
        maxPeople = 0
        deselectCell(cell: cell, color: .white, textColor: .orange, textColor2: .darkGray)
       
        deselectCellHour(color: .white, color2: .orange, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       guard let dateCell = cell as? DateTableCell else{return}
        if cell.isSelected {
            cell.isSelected = true
            maxPeople = selectedSchedules[indexPath.row].availableReservations
            highlightCell(cell: dateCell, color: .orange, textColor: .white, at: indexPath.row.description)
        } else {
            cell.isSelected = false
            
            deselectCell(cell: dateCell, color: .white, textColor: .orange, textColor2: .darkGray)
            deselectCellHour(color: .white, color2: .orange, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
       
    }
    
  //Setting selected and deselected states
    func highlightCell(cell: DateTableCell, color: UIColor, textColor: UIColor, at: String){
        let bgColorView = UIView()
        bgColorView.backgroundColor = color
        //cell.selectedBackgroundView = bgColorView
        cell.backgroundUIView.backgroundColor = color
        cell.booKlabel.textColor =  textColor
        cell.dateLabel.textColor = textColor
    }
    
    func deselectCell(cell: DateTableCell, color: UIColor, textColor: UIColor, textColor2: UIColor){
        let bgColorView = UIView()
        bgColorView.backgroundColor = color
        //cell.selectedBackgroundView = bgColorView
        cell.backgroundUIView.backgroundColor = color
        cell.booKlabel.textColor =  textColor2
        cell.dateLabel.textColor = textColor
    }
    
}
