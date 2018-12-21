//
//  CountriesExperiencesController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 24/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension CountriesExperiencesController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return count.count > 0 ? count.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.table.boxExperiencesTableCell, for: indexPath) as? BoxExperiencesTableCell else { return UITableViewCell() }
        let countSelected = count[indexPath.row]
        if count.count > 0 {
            cell.setCounts = count[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if count.count > 0{
            selectedCount = count[indexPath.row]
            performSegue(withIdentifier: K.segues.FeedStoryBoard.countriesToFeedForCountry, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
