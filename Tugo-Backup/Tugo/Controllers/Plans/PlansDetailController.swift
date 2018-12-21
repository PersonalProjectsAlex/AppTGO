//
//  PlansDetailController.swift
//  Tugo
//
//  Created by Alex on 7/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import TagListView
import HexColors
import Cosmos
import SDWebImage
import CoreLocation

class PlansDetailController: UIViewController {
    // MARK: - Let-Var
     var selectedBook: Reservation?
    let locale = Locale(identifier: "es_GT")
    
    // MARK: - Outlets
    @IBOutlet weak var maskViewBlack: UIView!
    @IBOutlet weak var maskViewWhite: UIView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var hostUserNameLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostuserLabel: UILabel!
    @IBOutlet weak var experiencePlaceName: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var startHourLabel: UILabel!
    @IBOutlet weak var numberPeopleLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
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
        
    }
    
    func setUpActions(){
        //Taglist datasource sample
        guard let orange = HexColor(K.colors.orange) else {return}
        tagListView.tagBackgroundColor = orange
        tagListView.cornerRadius = 2
        tagListView.clipsToBounds = true
        
    }
    
    private func settingData(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let book = selectedBook else{return}
        experienceNameLabel.text = book.experienceName
        hostUserNameLabel.text = "@\(book.host)"
        numberPeopleLabel.text = book.tickets.description
        hostNameLabel.text = book.hostname.capitalizingFirstLetter()
        hostuserLabel.text = book.host
        if let price = book.total_paid, !price.isEmpty{
            let outputString = "" + String(price.dropFirst())
            amountLabel.text = outputString
        }
        
        
        if let image = book.experienceAssets.first?.url, !image.isEmpty{
            weak.experienceImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        }
        
        
        
        if let hour = transformStringDate(book.startTime, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "hh:mm")  {
             startHourLabel.text = hour
        }
       
        
        if let month = transformStringDate(book.startTime, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "MMMM")  {
            monthLabel.text = month
        }
        
        
        if let day = transformStringDate(book.startTime, fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "dd")
        {
            tagListView.addTags([day])
        }
       
        
        experiencePlaceName.text = book.experienceName
        
        
        guard let image = book.experienceAssets.first?.url else{return}
        experienceImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        
        
        guard let lat = book.lat.toDouble(), let lon = book.long.toDouble() else{return}
        let location = CLLocation(latitude: lat, longitude: lon)
        
        fetchCityAndCountry(from: location) { (city, country, error) in
            if let city = city, let country = country, error == nil {
                weak.placeLabel.text =  "\(city), \(country )"
                print(city)
            }else{
                weak.placeLabel.text = ""
            }
        }
        
        
        
    }
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    
    // MARK: - Objective C

}
