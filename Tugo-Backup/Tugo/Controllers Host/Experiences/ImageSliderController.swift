//
//  ImageSliderController.swift
//  Tugo
//
//  Created by Alex on 19/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class ImageSliderController: UIViewController {
    
    // MARK: - Let-Var
    var imagesArray = [UIImage]()
    var images = [KingfisherSource]()
    var imagePlaceHolder = [ImageSource]()
    
    // MARK: - Outlets
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlider()
        print(imagesArray.count)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.ExperiencesHost.sliderToStartSExperience {
            let detailController = segue.destination as! StarNewExperienceHostController
            detailController.imagesArray = imagesArray
        }
        
    }
 
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){}
    
    //Setting slider features
    private func setSlider(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        DispatchQueue.main.async(execute: {
            
            //General features
            Core.shared.imagesliderFeatures(slideShow: weak.slideShow)
            
            //PageControl features
            weak.slideShow.activityIndicator = DefaultActivityIndicator()
            
            //Datasource
            for i in weak.imagesArray{
                weak.imagePlaceHolder.append(ImageSource(image: i))
            }
            
             weak.slideShow.setImageInputs(weak.imagePlaceHolder)
            
            //Tap on slider
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(weak.didTap))
            weak.slideShow.addGestureRecognizer(recognizer)
        })
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextStepAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segues.ExperiencesHost.sliderToStartSExperience, sender: self)
    }
    
    
    
    // MARK: - Objective C
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

}
