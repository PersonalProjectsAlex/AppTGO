//
//  PaymentProfileController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension PaymentProfileHostController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        
        switch tableView {
        case paymentTableView:
            
            count = cards.count > 0 ? cards.count  : 0
            
        case depositTableView:
            count = bankAccount.count > 0 ? bankAccount.count  : 0
        default:
            print("Error")
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        switch tableView {
        case paymentTableView:
            
            guard let cardsCell = paymentTableView.dequeueReusableCell(withIdentifier: K.cells.table.methodTableCell, for: indexPath) as? MethodTableCell else { return UITableViewCell() }
            
            if cards.count > 0{
                cardsCell.setCards = cards[indexPath.row]
            }
            
            cell = cardsCell
            
        case depositTableView:
            guard let accountCell = depositTableView.dequeueReusableCell(withIdentifier: K.cells.table.methodTableCell, for: indexPath) as? MethodTableCell else { return UITableViewCell() }
            
            if bankAccount.count > 0{
                accountCell.setBankAccount = bankAccount[indexPath.row]
            }
            
            cell = accountCell
        default:
            print("Error")
        }
        
        return cell
        
        
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            if cards.count > 1{
//                let cardId = self.cards[indexPath.row].id
//                deleteCard(cardId)
//            }
//        }
//    }
    
}
