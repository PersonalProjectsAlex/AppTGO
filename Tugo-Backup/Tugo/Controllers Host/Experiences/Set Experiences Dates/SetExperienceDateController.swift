//
//  SetExperienceDateController.swift
//  Tugo
//
//  Created by Alex on 19/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import PopupDialog
import JTAppleCalendar
import Alamofire
import SwiftMoment
import Firebase


class SetExperienceDateController: UIViewController {

    // MARK: - Let-Var
    let df = DateFormatter()
    var scheduleHours = [String]()
    var longExperience = 1
    var maxReservation: Int?
    var imagesArray = [UIImage]()
    var dates = [Date]()
    var experienceModel = [ExperienceHostModel]()
    var experienceHostInfo = [ExperienceHostInfo]()
    var lat: Double?
    var lon:Double?
    var country: String?
    var experienceResponse: NewExperienceResponse?
    var tempExperienceData = [TempNewExperience]()
    var fromBack = false
    var favourites = [FavouritesModel]()
    
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var hoursTableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var emptyHourImageView: UIImageView!
    @IBOutlet weak var addSchedulesButton: UIButton!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingData()
        
        guard let experienceHostModel = experienceModel.first else{return}
       experienceHostInfo.append(ExperienceHostInfo(experience: experienceHostModel , lat: lat, long: lon, country: country))
       
        if let lat = lat, let lon = lon, let country = country {
            locationButton.setImage(#imageLiteral(resourceName: "locateonmapbuttonselected"), for: .normal)
            locationButton.layer.borderWidth = 0.0
            locationButton.layer.borderColor = UIColor.clear.cgColor
            
        }

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //uard let experienceModel = experienceModel.first else{return}
       
        if segue.identifier == K.segues.ExperiencesHost.experienceSchedulesToCategories{
            let detailController = segue.destination as! FavouritesHostController
            //detailController.experienceResponse = experienceResponse
            detailController.tempExperienceData = tempExperienceData
            detailController.imagesArray = imagesArray
            detailController.selectedDates = calendarView.selectedDates
            detailController.scheduleHours = scheduleHours
            detailController.maxReservation = maxReservation
            detailController.longExperience = longExperience
            detailController.fromBack = fromBack
            if favourites.count > 0{
                detailController.favourites = self.favourites
            }
        }
        
        
        
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        //Tableview seprator color
        hoursTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        //Calendar
        definesPresentationContext = true
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarView.isRangeSelectionUsed = true
        calendarView.allowsMultipleSelection = true
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.minimumInteritemSpacing = 4
        
        //Tableview Delegate
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: hoursTableView, named: K.cells.table.Host.addScheduleTableCell)
        
        //Setting tap on imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        emptyHourImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    private func settingData(){}
    
    
    @IBAction func nextMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func showTimePickerPopup(_ sender: UIButton) {
        if calendarView.selectedDates.count > 0{
            
            showPopup()
        }
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        if longExperience > 1{
            self.longExperience -= 1
            self.countLabel.text = self.longExperience.description
        }
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
             longExperience += 1
             countLabel.text = longExperience.description
    }
    
    @IBAction func openMapAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: K.segues.ExperiencesHost.setnewExperienceToSelecteLocation, sender: self)
    }
    
    
    @IBAction func nextControllerAction(_ sender: UIButton) {
       
        tempExperienceData.removeAll()
        weak var weakSelf = self
        guard let weak = weakSelf else{return}

        guard  let experienceHostInfo = experienceHostInfo.first else{return}

        guard  let experienceHost = experienceHostInfo.experience, let experienceName = experienceHost.name, let  experienceDescription = experienceHost.description, let include = experienceHost.include   else{return}

        guard  let lat = lat, let lon = lon, let country = country else{return}
        weak.tempExperienceData.append(TempNewExperience.init(experienceName: experienceName, experienceDescription: experienceDescription, country: country, include: include, lat: lat, lon: lon))
        
        print(weak.tempExperienceData.first)
        weak.performSegue(withIdentifier: K.segues.ExperiencesHost.experienceSchedulesToCategories, sender: self)
        if calendarView.selectedDates.count > 0 && scheduleHours.count > 0{
            

        }else{
            Core.shared.alert(message: "Debes agregar una fecha y horario antes de agregar un nuevo horario de inicio", title: "Error:", at: weak)
        }

    }
    
    
    //Popup with TimePicker
    func showPopup(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
            let popup = LocationPopup(nibName: K.NIB.hourPopup, bundle: nil)
            DispatchQueue.main.async {
                // Create the dialog
                let popup = PopupDialog(viewController: popup, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
                
                let buttonOne = CancelButton(title: "Cancelar", height: 60) {}
                
                let buttonTwo = DefaultButton(title: "Aceptar", height: 60) {
                    let time = Singleton.shared.checkValueSet(key:K.defaultKeys.others.setTime)
                    
                    
                    if weak.calendarView.selectedDates.count > weak.scheduleHours.count{
                        
                        weak.callElementsAtAddingSchedule()
                        weak.scheduleHours.append(time)
                        weak.hoursTableView.reloadData()
                    }else{
                        Core.shared.alert(message: "Debes agregar una fecha antes de agregar un nuevo horario de inicio", title: "Error:", at: weak)
                    }
                    
                }
                
                popup.addButtons([buttonOne, buttonTwo])
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            }
        
    }
    
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
    
    
    //Converting images
    func changeImage(image:UIImage?, newExperience: NewExperienceResponse?){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        let imageName = "\(UUID().uuidString.lowercased())"
        
        let storage = FIRStorage.storage().reference()
        
        print(imageName)
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
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Call  some elements when adding schedule
    func callElementsAtAddingSchedule(){
        emptyHourImageView.isHidden = true
        emptyHourImageView.isUserInteractionEnabled = false
        addSchedulesButton.isHidden = false
        addSchedulesButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Objective C
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer){
        if calendarView.selectedDates.count > 0{
            showPopup()
        }
    }
    
}
