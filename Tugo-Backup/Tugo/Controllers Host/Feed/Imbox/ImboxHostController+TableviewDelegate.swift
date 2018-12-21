//
//  ImboxHostController+TableviewDelegate.swift
//  Tugo
//
//  Created by Alex on 18/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension ImboxHostController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = imboxTableView.dequeueReusableCell(withIdentifier: K.cells.table.Host.imboxHostTableCell, for: indexPath) as? ImboxHostTableCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
