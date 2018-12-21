//
//  FavouritesCollectionCell.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage

class FavouritesHostCollectionCell: UICollectionViewCell {

    var setCategories: Category?{
        didSet {
            setupCell()
        }
    }

    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    let instanceHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.signInhost)
    
    func setupCell(){
        guard let categories = setCategories else{return}
        nameLabel.text = categories.name
        let image = Core.shared.returnIconByCategory(Category: categories.name)
        let tintImage = image.withRenderingMode(.alwaysTemplate)
        activityImageView.tintColor = #colorLiteral(red: 0.4862745098, green: 0.2039215686, blue: 0.9764705882, alpha: 1)
        activityImageView.image = tintImage
    }
    
    override func prepareForReuse() {
//        backgroundColor = .white
//        activityImageView.image = nil
//        activityImageView.tintColor = nil
        selectedImageView.isHidden = true
        self.isSelected = false
    }
    
    
    override var isSelected: Bool{
        didSet{
            guard let categories = setCategories else{return}
            
                let image = Core.shared.returnIconByCategory(Category: categories.name)
                backgroundColor = !self.isSelected ? .clear : .orange
                let colorImage = !self.isSelected ? #colorLiteral(red: 0.4862745098, green: 0.2039215686, blue: 0.9764705882, alpha: 1) : UIColor.white
                Core.shared.changeImageColor(image: image, color: colorImage, at: activityImageView)
                nameLabel.textColor = !self.isSelected ? #colorLiteral(red: 0.4862745098, green: 0.2039215686, blue: 0.9764705882, alpha: 1) : .white
                selectedImageView.isHidden = !self.isSelected ? true : false
            
        }
    }
    
    
    
    
}
