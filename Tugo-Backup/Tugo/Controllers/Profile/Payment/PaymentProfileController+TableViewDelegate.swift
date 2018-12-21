//
//  PaymentProfileController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension PaymentProfileController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count > 0 ? cards.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = paymentTableView.dequeueReusableCell(withIdentifier: K.cells.table.methodTableCell, for: indexPath) as? MethodTableCell else { return UITableViewCell() }
        if cards.count > 0{
            cell.setCards = self.cards[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if cards.count > 1{
                let cardId = self.cards[indexPath.row].id
                deleteCard(cardId)
            }
        }
    }
    
}
