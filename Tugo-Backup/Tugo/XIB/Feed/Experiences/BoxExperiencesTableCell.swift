//
//  BoxExperiencesTableCell.swift
//  Tugo
//
//  Created by Alex on 6/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class BoxExperiencesTableCell: UITableViewCell {

    var setCounts: CountElement?{
        didSet {
            setupCell()
        }
    }
    
    
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    var countrie = String()
    
    

    func setupCell(){
        guard let countries = setCounts else { return }
        countryLabel.text = countries.country
        countLabel.text = "+\(countries.countryCount) experiencias"
    }
    
    
    
}
