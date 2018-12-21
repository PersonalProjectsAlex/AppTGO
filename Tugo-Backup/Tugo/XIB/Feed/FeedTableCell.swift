//
//  FeedTableCell.swift
//  Tugo
//
//  Created by Alex on 17/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import NVActivityIndicatorView
import SimpleImageViewer
import CoreMotion
import CTPanoramaView


protocol FeedCellDelegate{
    func pinchGesturesActivated(at index:IndexPath)
}

class FeedTableCell: UITableViewCell,NVActivityIndicatorViewable{

    var setExperiences: SearchElement?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var overImageview: UIImageView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var nameexperienceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var averageView: CosmosView!
    @IBOutlet weak var maskUIView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var maskHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var activyIndicator: NVActivityIndicatorView!

    
    
    var delegate:FeedCellDelegate!
    var indexPath:IndexPath!
    var motionManager = CMMotionManager()

    
    override func prepareForReuse() {
        experienceImageView.image = nil
       
    }
    
    override func awakeFromNib() {
        
    }
    
    
    
    func setupCell(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        guard let experiences = setExperiences else{return}
       
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        maskUIView.addGestureRecognizer(pinch)
        
        
        hostnameLabel.text = "@"+experiences.hostUsername
        averageView.rating = Double(experiences.avgStars)
        nameexperienceLabel.text = experiences.name.capitalizingFirstLetter()
        let price = Double(experiences.priceInCents/100)
        let roundedPrice = String(format: "%.2f", price)
        priceLabel.text = "$\(roundedPrice) por persona"
        if let image = experiences.assets.first?.url{
            activyIndicator.type = .circleStrokeSpin
            activyIndicator.startAnimating()
            
            experienceImageView.sd_setImage(with: URL(string: image)) { (image, error, cache, url) in
                if let error = error {
                    weak.experienceImageView.image = #imageLiteral(resourceName: "tugologo")
                    
                    weak.activyIndicator.stopAnimating()
                }else{
//                    DispatchQueue.main.async {
//                        self.motionManager.gyroUpdateInterval = 0.2
//                        
//                        self.motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
//                            if let myData = data
//                            {
//                                if myData.rotationRate.x > 1
//                                {
//                                    
//                                    print ("YOUR TILTED YOUR DEVICE")
//                                }
//                            }
//                        }
//                    }
                    
                    weak.activyIndicator.stopAnimating()
                    
                }
            }
        }
        
    }
    
    
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        self.delegate?.pinchGesturesActivated(at: indexPath)
    }
    
    
    
    
    
}
