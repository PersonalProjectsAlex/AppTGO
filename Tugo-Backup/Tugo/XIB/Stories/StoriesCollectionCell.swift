//
//  StoriesCollectionCell.swift
//  Tugo
//
//  Created by Alex on 17/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage
import Hero

class StoriesCollectionCell: UICollectionViewCell {

    var setCategories: Category?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    
    func setupCell(){
        guard let categories = setCategories else{return}
        let replaced = categories.name.replacingOccurrences(of: "ig_", with: "")
        nameLabel.text = replaced.capitalizingFirstLetter()
        storyImageView.sd_setImage(with: URL(string: categories.assetLastExperience), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        self.hero.id = categories.id
    }
    
    
    //Setting design
    override func awakeFromNib() {
        super.awakeFromNib()
        self.storyImageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCircularImageView()
    }
    
    func setCircularImageView() {
        self.storyImageView.layer.cornerRadius = CGFloat(roundf(Float(self.storyImageView.frame.size.width / 2.0)))
    }
    
    
    
    
}
