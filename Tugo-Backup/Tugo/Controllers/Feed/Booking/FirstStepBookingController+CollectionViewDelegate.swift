//
//  FirstStepBookingController+CollectionViewDelegate.swift
//  Tugo
//
//  Created by Alex on 10/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension FirstStepBookingController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSchedulesHours.count > 0 ? selectedSchedulesHours.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  hoursCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.collection.hourCollectionCell, for: indexPath) as? HourCollectionCell else { return UICollectionViewCell() }
        if selectedSchedulesHours.count > 0{
            cell.setSchedules = selectedSchedulesHours[indexPath.row]
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         guard let hourCell = cell as? HourCollectionCell else{return}
        if cell.isSelected {
            hourCell.backgroundUIView.backgroundColor = .orange
            hourCell.hourLabel.textColor = .white
        }else{
            cell.isSelected = false
            hourCell.backgroundUIView.backgroundColor = .white
            hourCell.hourLabel.textColor = .orange
        }
    }
    
    func highlightCellHour( color: UIColor, color2:UIColor, at: IndexPath, schedule: Schedule){
         guard let cell = self.hoursCollectionView .cellForItem(at: at) as? HourCollectionCell else{return}
         cell.isSelected = true
       
         DispatchQueue.main.async {
            if cell.isSelected{
                    cell.backgroundUIView.backgroundColor = color
                    cell.hourLabel.textColor = color2
                
            }else{
                cell.backgroundUIView.backgroundColor = .white
                cell.hourLabel.textColor = .orange
            }
        }
        
    }
    
    func deselectCellHour( color: UIColor, color2:UIColor, at: IndexPath){
       guard let cell = self.hoursCollectionView .cellForItem(at: at) as? HourCollectionCell else{return}
        cell.isSelected = false
         
        if !cell.isSelected{
                cell.backgroundUIView.backgroundColor = color
                cell.hourLabel.textColor = color2
            
        }
    }
    
    
    
    
}
