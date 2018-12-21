//
//  ExperiencesIncomeController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension ExperiencesIncomeController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = experiencesTableView.dequeueReusableCell(withIdentifier: K.cells.table.Host.experienceIncomeTableCell, for: indexPath) as? ExperienceIncomeTableCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.segues.Earninngs.incomeToExperienceIncomeDetail, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
    
    
}
