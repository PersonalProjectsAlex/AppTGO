//
//  DepositTableCellTableViewCell.swift
//  Tugo
//
//  Created by Alex on 20/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import fluid_slider

class DepositTableCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var viewleft: UIView!
    @IBOutlet weak var viewright: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewleft.addBorders(edges: [ .right], color: .lightGray)
        
        viewright.addBorders(edges: [ .left], color: .lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
