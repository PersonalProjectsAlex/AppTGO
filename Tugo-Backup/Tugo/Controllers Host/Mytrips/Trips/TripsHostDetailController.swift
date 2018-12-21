//
//  TripsHostDetailController.swift
//  Tugo
//
//  Created by Alex on 22/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import ImageSlideshow
import Kingfisher

class TripsHostDetailController: UIViewController {
    
    // MARK: - Let-Var
    var selectedExperience: NewExperienceResponse?
    var selectedSchedule = [ScheduleUpdated]()
    var images = [SDWebImageSource]()
    var imagePlaceHolder = [ImageSource]()
    
    // MARK: - Outlets
    @IBOutlet weak var datesTableView: UITableView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var raitingView: CosmosView!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    @IBOutlet weak var maxReservationsLabel: UILabel!
    @IBOutlet weak var availableReservationsLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        //Setting data
        settingData()
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
 
    
    // MARK: - SetUps / Funcs
    
    
    func setUpUI(){
        //Changin separator on tableview
        datesTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        //Tableview Delegate
        datesTableView.delegate = self
        datesTableView.dataSource = self
        
        //CollectionView Delegate
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: datesTableView, named: K.cells.complementaries.tripDetailDateTableCell)
        
        Core.shared.registerCellCollection(at: hourCollectionView, named: K.cells.complementaries.startHourCollectionCell)
        
        
        //Setting slider features
        
        setSlider()
        
    }
    
    private func settingData(){
        
        guard let experience = selectedExperience else { return }
        print(experience)
        
        if let schedules = experience.schedules{
            selectedSchedule = schedules
        }
        
        
//        if let image = experience.assets?.first?.url{
//            experienceImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "tugologo"))
//        }
        
        guard let name = experience.name else{return}
        experienceNameLabel.text = name.capitalizingFirstLetter()
        
        if let stars = experience.avgStars, let starsDouble = Double(exactly: stars) {
            raitingView.rating = starsDouble
        }
        
        
        if let maxReservations = experience.schedules?.first?.maxReservations {
            
            maxReservationsLabel.text = maxReservations.description
            
        }
        
        if let availableReservations = experience.schedules?.first?.availableReservations {
             availableReservationsLabel.text = availableReservations.description
            
        }else if let maxReservations = experience.schedules?.first?.maxReservations {
            
            availableReservationsLabel.text = maxReservations.description
            
        }
        
    }
    
    
    
    
    
    
    //Setting slider features
    private func setSlider(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        DispatchQueue.main.async(execute: {
            
            //General features
            Core.shared.imagesliderFeaturesCustom(slideShow: weak.slideShow)
            
            //PageControl features
            //Datasource
            guard let assets = weak.selectedExperience?.assets, assets.count > 0 else {
                weak.imagePlaceHolder = [ImageSource(image: UIImage(named: "guatemala")!)]
                weak.slideShow.setImageInputs(weak.imagePlaceHolder)
                return
            }
            
            for i in assets{
                guard let url = URL(string: i.url) else{return}
                weak.images.append(SDWebImageSource(url: url, placeholder: #imageLiteral(resourceName: "tugologo") ))
                
            }
            
            weak.slideShow.currentPageChanged = { page in
                let urlString = assets[page].url
                guard let url = URL(string: urlString) else{return}
                DispatchQueue.main.async {
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        guard let image = image else{return}
                        
                        
                    })
                }
            }
            
            
            weak.slideShow.setImageInputs(weak.images)
            
            //Tap on slider
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(weak.didTap))
            weak.slideShow.addGestureRecognizer(recognizer)
        })
    }
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

}

