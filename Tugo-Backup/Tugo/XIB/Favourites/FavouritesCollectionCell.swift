//
//  FavouritesCollectionCell.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage

class FavouritesCollectionCell: UICollectionViewCell {

    var setCategories: Category?{
        didSet {
            setupCell()
        }
    }
    
    var setFavourites: MyFavourite?{
        didSet {
            setupCellFavourite()
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
        activityImageView.image = image
    }
    
    override func prepareForReuse() {
//        backgroundColor = .white
//        activityImageView.image = nil
//        activityImageView.tintColor = nil
        selectedImageView.isHidden = true
        self.isSelected = false
    }
    
    
    func setupCellFavourite(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let categories = setFavourites else{return}
        
        nameLabel.text = categories.displayName
   
        let image = Core.shared.returnIconByCategory(Category: categories.name)
        
        if categories.isLiked{
            Core.shared.changeImageColor(image: image, color: .white, at: weak.activityImageView)
            weak.nameLabel.textColor = .white
            DispatchQueue.main.async {
                weak.selectedImageView.isHidden = false
            }
            
        }else{
            activityImageView.image = image
            weak.backgroundColor = .white
            weak.nameLabel.textColor = #colorLiteral(red: 0.9254901961, green: 0.4980392157, blue: 0.4823529412, alpha: 1)
            DispatchQueue.main.async {
                weak.selectedImageView.isHidden = true
            }
            
            
        }
    }
    
    override var isSelected: Bool{
        didSet{
            
            guard let categories = setFavourites else{return}
            if !categories.isLiked{
                let image = Core.shared.returnIconByCategory(Category: categories.name)
                let colorImage = !self.isSelected ? UIColor.orange : UIColor.white
                Core.shared.changeImageColor(image: image, color: colorImage, at: activityImageView)
                nameLabel.textColor = !self.isSelected ? #colorLiteral(red: 0.9254901961, green: 0.4980392157, blue: 0.4823529412, alpha: 1) : .white
                
                DispatchQueue.main.async {
                    self.selectedImageView.isHidden = !self.isSelected ? true : false
                }
            }
        }
    }
    
    
}
