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
import SimpleImageViewer

extension FeedController: UITableViewDataSource, UITableViewDelegate, FeedCellDelegate{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count > 0 ? experiences.count : 0
        //return experiences.count > 0 ? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.table.feedTableCell, for: indexPath) as? FeedTableCell else { return UITableViewCell() }
        if experiences.count > 0{
            cell.setExperiences = experiences[indexPath.row]
            cell.delegate = self
            cell.indexPath = indexPath
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if experiences.count > 0{
            selectedExperience = self.experiences[indexPath.row]
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1920, 2208:
                    performSegue(withIdentifier: K.segues.FeedStoryBoard.feedControllerToDetailsControllerBigger, sender: self)
                    
                case 2436:
                    performSegue(withIdentifier: K.segues.FeedStoryBoard.feedControllerToDetailsControllerBigger, sender: self)
                    
                default:
                    performSegue(withIdentifier: K.segues.FeedStoryBoard.feedControllerToDetailsController, sender: self)
                }
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 540
    }
    
    func pinchGesturesActivated(at index: IndexPath) {
        guard let cell = feedTableView.cellForRow(at: index) as? FeedTableCell else {return}
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.experienceImageView
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
    }
    
    
    
}
