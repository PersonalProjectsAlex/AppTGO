//
//  StoriesDetailController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 28/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension StoriesDetailController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count  > 0 ? experiences.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.table.feedTableCell, for: indexPath) as? FeedTableCell else { return UITableViewCell() }
        if experiences.count  > 0 {
            cell.setExperiences = experiences[indexPath.row]
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if experiences.count  > 0 {
            selectedExperience = experiences[indexPath.row]
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1920, 2208:
                    performSegue(withIdentifier: K.segues.FeedStoryBoard.storiesdetailToDetailControllerBigger, sender: self)
                    
                case 2436:
                    performSegue(withIdentifier: K.segues.FeedStoryBoard.storiesdetailToDetailControllerBigger, sender: self)
                    
                default:
                    performSegue(withIdentifier: K.segues.FeedStoryBoard.storiesdetailToDetailController, sender: self)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 540
    }
    
    
    
}
