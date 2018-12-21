//
//  EditExperienceController+CollectionViewDelegate.swift
//  Tugo
//
//  Created by Alex on 9/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import TLPhotoPicker

extension EditExperienceController: UICollectionViewDelegate, UICollectionViewDataSource,SelectPhotoActionDelegate{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setAssetTemp.count > 0 ? setAssetTemp.count - 1: 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
     guard let cell =  assetsCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.complementaries.selectPhotoCollectionCell, for: indexPath) as? SelectPhotoCollectionCell else { return UICollectionViewCell() }
        
        
        if setAssetTemp.count > 0 {
            cell.setAsset = setAssetTemp[indexPath.row]
            cell.delegate = self
            cell.indexPath = indexPath
        }
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if setAssetTemp.count > 0{
            
            
        }
        
    }
    
    func selectPhotoAction() {
        showImagePicker()
    }
    
    func deleteTrip(at index: IndexPath) {
        let asset = setAssetTemp[index.row]
        if let id  = asset.id, !id.isEmpty{
            self.deleteAction(id)
            
            
            
        }
    }
    
    
    func deleteAction(_ id: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let refreshAlert = UIAlertController(title: "¿Deseas eliminar esta imagen?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Eliminar", style: .default, handler: { (action: UIAlertAction!) in
            ExperiencesManager().deleteAsset(header: self.header, assetId: id, completionHandler: { (asset) in
                guard let asset = asset else{return}
                
                guard let experience = weak.selectedExperience, let experienceID = experience.id else{return}
                ExperiencesManager().getExperienceById(id: experienceID, header: weak.header, completionHandler: {
                    response in
                    guard let response = response else{return}
                    weak.setScheduleTemp(experience: response)
                })
            })
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in}))
        
        weak.present(refreshAlert, animated: true, completion: nil)
    }

    
}



extension EditExperienceController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleTemp.count > 0 ? scheduleTemp.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: K.cells.table.Host.editScheduleTableCell, for: indexPath) as? EditScheduleTableCell else { return UITableViewCell() }
        if scheduleTemp.count > 0{
            cell.setDate = scheduleTemp[indexPath.row]
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        if editingStyle == .delete {
                let schedule = scheduleTemp[indexPath.row]
            guard let scheduleID = schedule.id else{return}
            ExperiencesManager().deleteSchedule(header: weak.header, id: scheduleID) {
                schedule in
                guard let schedule = schedule else{return}
                Core.shared.alert(message: "El horario fue eliminado de forma éxitosa", title: "Hecho", at: weak)
            }
           
            
        }
    }
    
}
