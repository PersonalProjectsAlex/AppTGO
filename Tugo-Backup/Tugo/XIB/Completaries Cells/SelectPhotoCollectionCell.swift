//
//  SelectPhotoCollectionCell.swift
//  Tugo
//
//  Created by Alex on 11/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage

protocol SelectPhotoActionDelegate{
    func selectPhotoAction()
    func deleteTrip(at index:IndexPath)
}

class SelectPhotoCollectionCell: UICollectionViewCell {
    
    var setAsset: assetTemp?{
        didSet {
            setupCell()
        }
    }

    var delegate:SelectPhotoActionDelegate!
    var indexPath:IndexPath!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    
    func setupCell(){
        guard let asset = setAsset else { return }
        
        if let url = asset.url, !url.isEmpty{
            addButton.isHidden = true
            addButton.isUserInteractionEnabled = false
            deleteButton.isHidden = false
            experienceImageView.isHidden = false
            experienceImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        }else{
            
            experienceImageView.isHidden = true
            deleteButton.isHidden = true
            addButton.isHidden = false
            addButton.isUserInteractionEnabled = true
        }
        
        
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        self.delegate?.deleteTrip(at: indexPath)
    }

    
    @IBAction func showAddAssetAction(_ sender: UIButton) {
        self.delegate?.selectPhotoAction()
    }
}
