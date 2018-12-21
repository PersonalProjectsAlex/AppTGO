//
//  DetailsController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 27/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension DetailsController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        
        switch tableView {
        case datesTableView:
            if let experiences = selectedExperience{
                count = experiences.schedules.count > 0 ? experiences.schedules.count  : 0
            }else{
                count = 0
            }
            
        case commentsTableView:
            count = 1
        default:
            print("Error")
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        switch tableView {
        case datesTableView:
            
            guard let datesTableCell = datesTableView.dequeueReusableCell(withIdentifier: K.cells.table.Complementaries.tripDetailDateTableCell, for: indexPath) as? TripDetailDateTableCell else { return UITableViewCell() }
            
            if let experiences = selectedExperience{
                if experiences.schedules.count > 0 {
                    datesTableCell.setSchedule = experiences.schedules [indexPath.row]
                }
            }
            
            cell = datesTableCell
            
        case commentsTableView:
             guard let commentsTableCell = commentsTableView.dequeueReusableCell(withIdentifier: K.cells.table.commentsTableCell, for: indexPath) as? CommentsTableCell else { return UITableViewCell() }
             
             if  let review = selectedExperience?.reviews{
                if review.count > 0{
                    commentsTableCell.setReview = review[indexPath.row]
                }else{
                    commentsTableCell.userLabel.text = "Sin comentarios"
                    commentsTableCell.rateView.isHidden = true
                    commentsTableCell.commentLabel.isHidden = true
                    
                }
             }
             cell = commentsTableCell
        default:
            print("Error")
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var size = CGFloat()
        switch tableView {
        case datesTableView:
            size = 44
        case commentsTableView:
            size = 120
        default:
            print("Error")
        }
        return size
    }
    
    
}
