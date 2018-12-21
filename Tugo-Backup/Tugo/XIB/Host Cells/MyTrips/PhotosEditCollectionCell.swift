//
//  PhotosEditCollectionCell.swift
//  Tugo
//
//  Created by Alex on 9/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage


class PhotosEditCollectionCell: UICollectionViewCell {

    var setAsset: Asset?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var experienceImageView: UIImageView!
    
    func setupCell(){
        guard let asset = setAsset else { return }
        experienceImageView.sd_setImage(with: URL(string: asset.url), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        
    }

}
