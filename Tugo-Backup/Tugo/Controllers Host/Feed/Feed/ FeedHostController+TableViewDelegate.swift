//
//  FeedController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 17/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import HexColors


extension FeedHostController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count > 0 ? experiences.count : 1
        //return experiences.count > 0 ? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.table.feedTableCell, for: indexPath) as? FeedTableCell else { return UITableViewCell() }
        if experiences.count > 0{
             
            cell.setExperiences = experiences[indexPath.row]
            
        }else{
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.experiences.count > 0{
            self.selectedExperience = self.experiences[indexPath.row]
            self.performSegue(withIdentifier: K.segues.FeedStoryBoard.feedControllerToDetailsController, sender: self)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 540
    }
}


