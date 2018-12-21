//
//  SetExperienceDateController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 1/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension SetExperienceDateController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleHours.count > 0 ? scheduleHours.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = hoursTableView.dequeueReusableCell(withIdentifier: K.cells.table.Host.addScheduleTableCell, for: indexPath) as? AddScheduleTableCell else { return UITableViewCell() }
        if scheduleHours.count > 0{
            cell.setHour = scheduleHours[indexPath.row]
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    
    
}
