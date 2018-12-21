//
//  PlansController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 29/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension PlansController: UITableViewDelegate,UITableViewDataSource,RouteButtonActionDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count > 0 ? bookings.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.table.plansTableCell, for: indexPath) as? PlansTableCell else { return UITableViewCell() }
        
        if bookings.count > 0{
            cell.setBooking = bookings[indexPath.row]
            cell.delegate = self
            cell.indexPath = indexPath
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bookings.count > 0{
            selectedBook = bookings[indexPath.row]
            self.performSegue(withIdentifier: K.segues.Plans.plansToDetail, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    func showLocationAction(at index: IndexPath) {
        
        let book = bookings[index.row]
        print(book)
        showplaceActionSheet(book: book)
    }
    
    
    func showplaceActionSheet(book: Reservation){
        guard let lat = book.lat.toDouble() else{return}
        guard let long = book.long.toDouble() else{return}
        print(lat)
        print(long)
        let actionSheetController: UIAlertController = UIAlertController(title: K.titles.mapTitleActionSheet, message: K.titles.mapMessageActionSheet, preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in}
        
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let openWaze: UIAlertAction = UIAlertAction(title: K.titles.waze, style: .default) { action -> Void in
            Core.shared.openWaze(latitude: lat, longitude: long)
            
        }
        actionSheetController.addAction(openWaze)
        
        //Create and add a second option action
        let openGoogleMap: UIAlertAction = UIAlertAction(title: K.titles.googleMaps, style: .default) { action -> Void in
            Core.shared.openGoogleMaps()
        }
        actionSheetController.addAction(openGoogleMap)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Objective C
    
    
}
