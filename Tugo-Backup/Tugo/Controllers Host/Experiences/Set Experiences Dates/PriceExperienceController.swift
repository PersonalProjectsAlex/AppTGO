//
//  PriceExperienceController.swift
//  Tugo
//
//  Created by Alex on 9/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftMoment
import NVActivityIndicatorView

class PriceExperienceController: UIViewController, NVActivityIndicatorViewable{

    // MARK: - Let-Var
    
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    let locale = Locale(identifier: "es_GT")
    let timeZone = TimeZone(secondsFromGMT: -10800)!
    var experienceResponse: NewExperienceResponse?
    
    //From segue
    var tempExperienceData = [TempNewExperience]()
    var imagesArray = [UIImage]()
    var scheduleHours = [String]()
    var selectedDates = [Date]()
    var favourites = [FavouritesModel]()
    var maxReservation: Int?
    var longExperience = Int()
    
    // MARK: - Outlets
    @IBOutlet weak var priceTextfield: UITextField!
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tempExperienceData = tempExperienceData.first else{return}
        print(tempExperienceData)
        print(selectedDates)
        print(scheduleHours)
        print(favourites)
        print(imagesArray.count)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {}
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.ExperiencesHost.setPriceToMyTrips{
            let detailController = segue.destination as! TripByHostController
            detailController.fromState = true
            
        }
    }
    
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){}
    
    private func settingData(){}
    
    
    @IBAction func publishAction(_ sender: UIButton) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        startAnimating()
        //Data to be published
        
        guard let price = priceTextfield.text, !price.isEmpty else{
            Core.shared.alert(message: "Debes ingresar el precio de tu experiencia", title: "Error:", at: weak)
            weak.stopAnimating()
            return
        }
        
        guard let  priceDouble = Double(price) else{return}
        
        let priceInCent = priceDouble * 100
        
        //Creating the new experience
        guard let tempExperienceData = weak.tempExperienceData.first else{return}
        let experienceName = tempExperienceData.experienceName
        let experienceDescription = tempExperienceData.experienceDescription
        let lat = tempExperienceData.lat
        let lon = tempExperienceData.lon
        let country = tempExperienceData.country
        let include = tempExperienceData.include
        
        let params:Parameters = ["name":experienceName, "description": experienceDescription,"price": priceInCent, "lat": lat, "long": lon, "country": country, "que_incluye": include]
        ExperiencesManager().newExperience(header: header, params: params) {
            newExperience in
            guard let newExperience = newExperience, let experienceID = newExperience.id else{return}
            
            
            for i in weak.favourites{
                guard let categoryID = i.index else{return}
                weak.setCategories(experienceID: experienceID, categoryID: categoryID)
            }
            
            for i in weak.imagesArray{
                weak.changeImage(image: i, newExperience: newExperience)
            }
            
            
            for (e1, e2) in zip(weak.selectedDates, weak.scheduleHours) {
                
                guard let date = weak.formatDateFromCalendar(dates: e1) else{return}
                guard let hour = weak.formatHour(dates: e2) else{return}
                guard let maxReservation = weak.maxReservation else{return}
                
                guard let myDate = moment("\(date) \(hour)", dateFormat: "yyyyMMdd HH:mm", timeZone: weak.timeZone, locale: self.locale)else {return}
                
                // Add one hour
                let endTime = (myDate + weak.longExperience.hours).format("yyyyMMdd HH:mm")
                
                let startTime = "\(date) \(hour)"
                
                let params:Parameters = ["experience_id":experienceID, "start_time":startTime, "end_time":endTime, "max_reservations": maxReservation]
                ExperiencesManager().setSchedules(header: weak.header, params: params, completionHandler: {
                    schedule in
                    guard let schedule = schedule else{return}
                    weak.stopAnimating()
                    weak.performSegue(withIdentifier: K.segues.ExperiencesHost.setPriceToMyTrips, sender: weak)
                    
                })
                
                
            }
            
            
        }

        
        
           // weak.performSegue(withIdentifier: K.segues.ExperiencesHost.setPriceToMyTrips, sender: weak)
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        if let presenter = presentingViewController as? FavouritesHostController {
            presenter.fromBack = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //Converting images
    func changeImage(image:UIImage?, newExperience: NewExperienceResponse?){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        let imageName = "\(UUID().uuidString.lowercased())"
        
        let storage = FIRStorage.storage().reference()
        
        let storedImage = storage.child("experiences").child(imageName)
        guard let image = image else{return}
        if let uploadData = UIImageJPEGRepresentation(image, 0.8)
        {
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            storedImage.put(uploadData, metadata: metaData, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    
                    return
                }
                
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        
                        return
                    }else{
                        
                        guard let photo = metadata?.downloadURL()?.absoluteString else {
                            Core.shared.alert(message: "Sucedio un error con esta imagen intente de nuevo", title: "Sucedio algo:", at: self)
                            weak.stopAnimating()
                            return
                        }
                        
                        guard let newExperience = newExperience, let experienceID = newExperience.id else{return}
                        let params:Parameters = ["experience_id":experienceID, "image_url":photo]
                        ExperiencesManager().setAssets(header: weak.header, params: params, completionHandler: {
                            asset in
                            guard let asset = asset else{return}
                            print(asset)
                        })
                        
                    }
                })
                
            })
        }
    }
    
    
    //Setting categories
    private func setCategories(experienceID: String ,categoryID: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let params: Parameters = ["experience_id":  experienceID, "category_id": categoryID]
        
        CategoriesManager().setCategorieByExperience(header: header , params: params) {
            categories in
            guard let categories = categories else{return}
        }
        
    }
    
    
    //--Formatting dates
    
    
    func formatDateFromCalendar(dates:Date) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: dates.description)
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date!)
        
    }
    
    
    //Formatting hours
    
    func formatHour(dates:String) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dates)
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date!)
    }
    
    func stringToDate(dates:String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: dates )!
    }
    
    
    
    // MARK: - Objective C
    

}
