//
//  PlansTableCell.swift
//  Tugo
//
//  Created by Alex on 29/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage
import Spring

protocol RouteButtonActionDelegate{
    func showLocationAction(at index:IndexPath)
}

class PlansTableCell: UITableViewCell {

    var setBooking: Reservation?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutdateLabel: UILabel!
    @IBOutlet weak var infoDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var containerView: SpringView!
    @IBOutlet weak var maincontainerView: UIView!
    @IBOutlet weak var behindArrowImageview: UIImageView!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    var delegate:RouteButtonActionDelegate!
    var indexPath:IndexPath!
    let locale = Locale(identifier: "es_GT")
    
    
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
        guard let booking = setBooking, let photo = booking.experienceAssets.first else{return}
        experienceImageView.sd_setImage(with: URL(string: photo.url), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        nameLabel.text = booking.experienceName
        infoDateLabel.text = booking.startTime
        addressLabel.text = booking.experienceCountry
        aboutdateLabel.text = booking.reservationIn
        if let hour = transformStringDate(booking.startTime, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "hh:mm a"), let day = transformStringDate(booking.startTime, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "dd MMM")  {
            infoDateLabel.text = "\(day) - \(hour)"
            
            
        }
    
    }

    
    @IBAction func showLocationAction(_ sender: UIButton) {
        self.delegate?.showLocationAction(at: indexPath)
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
            weak.behindArrowImageview.isHidden = false
            
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
    
    //Tranform dates
    func transformStringDate(_ dateString: String,
                             fromDateFormat: String,
                             toDateFormat: String) -> String? {
        
        let initalFormatter = DateFormatter()
        
        initalFormatter.dateFormat = fromDateFormat
        guard let initialDate = initalFormatter.date(from: dateString) else {
            print ("Error in dateString or in fromDateFormat")
            return nil
        }
        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = toDateFormat
        resultFormatter.locale = locale
        return resultFormatter.string(from: initialDate)
    }
}
