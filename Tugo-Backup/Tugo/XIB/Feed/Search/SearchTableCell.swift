//
//  SearchTableCell.swift
//  Tugo
//
//  Created by Alex on 17/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class SearchTableCell: UITableViewCell {

    var setExperiences: SearchElement?{
        didSet {
            setupCell()
        }
    }
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var nameexperienceLabel: UILabel!
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var averageView: CosmosView!
    
    func setupCell(){
        guard let experiences = setExperiences else{return}
        
        hostnameLabel.text = "@"+experiences.hostUsername
        averageView.rating = Double(experiences.avgStars)
        nameexperienceLabel.text = experiences.name
        
        if let image = experiences.assets.first?.url{
            experienceImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        }
        
        
    }
    
}
