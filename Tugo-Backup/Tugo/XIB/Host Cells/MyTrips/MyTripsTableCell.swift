//
//  MyTripsTableCell.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Spring
import Cosmos
import SDWebImage

protocol DeleteActionDelegate{
    func deleteTrip(at index:IndexPath)
    func openController(at index:IndexPath)
}

class MyTripsTableCell: UITableViewCell {

        var setExperiences: NewExperienceResponse?{
            didSet {
                setupCell()
            }
        }
    
    @IBOutlet weak var containerView: SpringView!
    @IBOutlet weak var maincontainerView: UIView!
    @IBOutlet weak var behindArrowImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var starsView: CosmosView!
     var delegate:DeleteActionDelegate!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Left gesture
        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.leftGestureRecognizer(_:)))
        leftGestureRecognizer.direction = (.left)
        maincontainerView.addGestureRecognizer(leftGestureRecognizer)
        
        //Right Gesture
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rightGestureRecognizer(_:)))
        rightGestureRecognizer.direction = (.right)
        maincontainerView.addGestureRecognizer(rightGestureRecognizer)
        
        
    }
        
        
    func setupCell(){
        guard let experiences = setExperiences, let photo = experiences.assets?.first else{return}
        
        nameLabel.text = experiences.name
        experienceImageView.sd_setImage(with: URL(string: photo.url), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        guard let raitingInt = experiences.avgStars, let raitingDouble = Double(exactly: raitingInt) else{return}
        starsView.rating = raitingDouble
        
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        self.delegate?.deleteTrip(at: indexPath)
    }

    @IBAction func openController(_ sender: UIButton) {
        self.delegate?.openController(at: indexPath)
    }
    
    // MARK: - Objective C
    
    @objc func leftGestureRecognizer(_ recognizer: UISwipeGestureRecognizer?) {
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        if containerView.isHidden{
            containerView.animation = "slideLeft"
            containerView.animate()
            weak.containerView.isHidden = false
            weak.containerView.isUserInteractionEnabled = true
            weak.behindArrowImageview.isHidden = true
        }
    }
    
    @objc func rightGestureRecognizer(_ recognizer: UISwipeGestureRecognizer?) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        containerView.animation = "fadeOut"
        containerView.animate()
        weak.behindArrowImageview.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            weak.containerView.isHidden = true
            weak.containerView.isUserInteractionEnabled = false
        }
        
       
    }
    
}
