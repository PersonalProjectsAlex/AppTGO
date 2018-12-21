//
//  TripsHostDetailController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 22/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension TripsHostDetailController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSchedule.count > 0 ? selectedSchedule.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = datesTableView.dequeueReusableCell(withIdentifier: K.cells.complementaries.tripDetailDateTableCell, for: indexPath) as? TripDetailDateTableCell else { return UITableViewCell() }
        if selectedSchedule.count > 0{
            cell.setScheduleUpdated = selectedSchedule[indexPath.row]
        }
        
        return cell
    }
    
    
}



extension TripsHostDetailController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSchedule.count > 0 ? selectedSchedule.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  hourCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.complementaries.startHourCollectionCell, for: indexPath) as? StartHourCollectionCell else { return UICollectionViewCell() }
        
        if selectedSchedule.count > 0{
            
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
