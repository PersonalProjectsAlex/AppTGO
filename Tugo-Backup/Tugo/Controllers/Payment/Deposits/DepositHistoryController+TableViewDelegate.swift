//
//  DepositHistoryController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 24/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension DepositHistoryController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.table.depositTableCell, for: indexPath) as? DepositTableCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    
    
}
