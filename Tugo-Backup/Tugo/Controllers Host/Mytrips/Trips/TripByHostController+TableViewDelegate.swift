//
//  TripByHostController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit

extension TripByHostController: UITableViewDelegate,UITableViewDataSource, DeleteActionDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count > 0 ? experiences.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tripTableView.dequeueReusableCell(withIdentifier: K.cells.table.Host.myTripsTableCell, for: indexPath) as? MyTripsTableCell else { return UITableViewCell() }
        if experiences.count > 0{
            cell.setExperiences = experiences[indexPath.row]
            cell.delegate = self
            cell.indexPath = indexPath
        }
        
        return cell
    }
    
    func deleteTrip(at index: IndexPath) {
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let experience = experiences[index.row]
        guard let experienceID = experience.id else{return}
        
        let refreshAlert = UIAlertController(title: "¿Deseas eliminar esta imagen?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Eliminar", style: .default, handler: { (action: UIAlertAction!) in
            weak.delete(at: experienceID)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in}))
        
        weak.present(refreshAlert, animated: true, completion: nil)
        
    }
   
    
    func openController(at index: IndexPath) {
        selectedExperience = experiences[index.row]
        performSegue(withIdentifier: K.segues.Trips.myTripsToEdit, sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if experiences.count > 0{
             selectedExperience = experiences[indexPath.row]
             self.performSegue(withIdentifier: "TripControllerToDetail", sender: self)
        }
    }
    
    func delete(at: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        ExperiencesManager().deleteExperience(id: at, header: header) {
            result in
            guard let result = result else{return}
            Core.shared.alert(message: "La experiencia fue eliminada ", title: "éxito", at: weak)
            weak.gettingData()
        }
    }
    
    
    
}

