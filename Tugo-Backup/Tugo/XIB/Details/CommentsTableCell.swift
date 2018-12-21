//
//  CommentsTableCell.swift
//  Tugo
//
//  Created by Alex on 27/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class CommentsTableCell: UITableViewCell {

    var setReview: Review?{
        didSet {
            setupCell()
        }
    }
    
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    func setupCell(){
        guard let reviews = setReview else{return}
        
        userLabel.text = reviews.userID
        
        if let stars  = Double(exactly: reviews.stars){
            rateView.rating = stars
        }
        
        if let image  = URL(string: ""){
            userImageView.sd_setImage(with: image, placeholderImage: #imageLiteral(resourceName: "tugologo"))
        }
        
        commentLabel.text = reviews.content
    }
}
