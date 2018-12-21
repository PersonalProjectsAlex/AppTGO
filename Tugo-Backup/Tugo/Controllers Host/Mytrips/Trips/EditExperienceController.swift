//
//  EditExperienceController.swift
//  Tugo
//
//  Created by Alex on 9/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import MapKit
import PopupDialog
import TLPhotoPicker
import Alamofire
import Firebase
import SwiftMoment

class EditExperienceController: UIViewController, MKMapViewDelegate{

    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    var images = [UIImage]()
    var showState = true
    var selectedAssets = [TLPHAsset]()
    var selectedExperience: NewExperienceResponse?
    let annotation = MKPointAnnotation()
    var scheduleTemp = [ScheduleTemp]()
    var assets = [Asset]()
    var setAssetTemp = [assetTemp]()
    var scheduleDates = [String]()
    var flagCounter = 5
    var date:String?
    let locale = Locale(identifier: "es_GT")
    let timeZone = TimeZone(secondsFromGMT: -10800)!
    
    //-- Variables to set the function which will contain our values to edit
        var lat: Double?
        var lon: Double?
        var country: String?
        var maxReservation = 100
        var longExperience = 1
        var experienceName = String()
        var experienceDescription = String()
    
    
    // MARK: - Outlets
    @IBOutlet weak var heightForButtons: NSLayoutConstraint!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var hourButton: UIButton!
    @IBOutlet weak var secondOptionUIView: UIView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    //--Outleets for second index
    @IBOutlet weak var countAssetsLabel: UILabel!
    @IBOutlet weak var assetsCollectionView: UICollectionView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var `switch`: UISwitch!
    //Outleets to hide
    @IBOutlet weak var maximunLabel: UILabel!
    @IBOutlet weak var minuButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    
        settingDataFromExperience()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        //Switch off
        `switch`.layer.cornerRadius = 16.0
        
    }
    
    func setUpActions(){
        
        heightForButtons.constant = 10
        
        ///Mapkit
        mapKit.delegate = self
        Core.shared.mapkitFeatures(mapKit: mapKit)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        mapKit.addGestureRecognizer(tapGestureRecognizer)
        
        //Tableview- collectionview Delegate
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        assetsCollectionView.dataSource = self
        assetsCollectionView.delegate = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: scheduleTableView, named: K.cells.table.Host.editScheduleTableCell)
        Core.shared.registerCellCollection(at: assetsCollectionView, named: K.cells.collection.Host.photosEditCollectionCell)
        Core.shared.registerCellCollection(at: assetsCollectionView, named: K.cells.complementaries.selectPhotoCollectionCell)
        
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        if longExperience > 1{
            
            self.longExperience -= 1
            self.countLabel.text = self.longExperience.description
        }
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        longExperience += 1
        countLabel.text = self.longExperience.description
    }
    
    
    @IBAction func addScheduleAdction(_ sender: UIButton) {
       
            dateButton.isHidden = false
            hourButton.isHidden = false
            heightForButtons.constant = 45
        
    }
    
    
    @IBAction func openDateModal(_ sender: UIButton) {
       showPopupDate()
    }
    
    @IBAction func openHourModal(_ sender: UIButton) {
        showPopupHour()
    }
    
    
    
    @IBAction func switchState(_ sender: UISwitch) {
        if sender.isOn{
            outleetsToHide(false)
            guard let experience = selectedExperience else{return}
            if let maxReservations = experience.schedules?.first?.maxReservations, let reservations = experience.schedules?.first?.availableReservations{
                
                maximunLabel.text = reservations.description
                self.maxReservation = reservations
            }
        }else{
            maxReservation = 100
            outleetsToHide(true)
        }
    }
    
    @IBAction func changeInterface(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
            
        case 0:
            secondOptionUIView.isHidden = true
            secondOptionUIView.isUserInteractionEnabled = false
        case 1:
            secondOptionUIView.isHidden = false
            secondOptionUIView.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    
    func settingDataFromExperience(){
        
        //IUnwrapping our experience safetely
        guard let experience = selectedExperience else{return}
        
        //Setting name
        if let name = experience.name, let description = experience.description{
            nameTextfield.text = name
            descriptionTextView.isUserInteractionEnabled = true
            descriptionTextView.text = description
            experienceName = name
            experienceDescription = description
            
        }
       
        setScheduleTemp(experience: experience)
        
        if let dates = experience.schedules{
            for i in dates{
                self.scheduleTemp.append(ScheduleTemp(id: i.id, hour:i.startTime, date: i.endTime))
                self.scheduleTableView.reloadData()
            }
        }
        
        if let maxReservations = experience.schedules?.first?.maxReservations, let reservations = experience.schedules?.first?.availableReservations{
            `switch`.isOn = true
            outleetsToHide(false)
            maximunLabel.text = reservations.description
            self.maxReservation = reservations
        }
        
        
        //Setting current location on map
        addPinMapkit(experiences: experience)
        
    }
    
    
    
    
    func addPinMapkit(experiences: NewExperienceResponse){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        if let lat = weak.lat , let long = weak.lon{
            
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            weak.annotation.coordinate = center
            weak.mapKit.region = region
            weak.mapKit.addAnnotation(weak.annotation)
        }else{
            
            guard let lat = experiences.lat?.toDouble() else{return}
            guard let long = experiences.long?.toDouble() else{return}
            guard let country = experiences.country else{return}
            weak.lat = lat
            weak.lon = long
            weak.country = country
            
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            weak.annotation.coordinate = center
            weak.mapKit.region = region
            weak.mapKit.addAnnotation(annotation)
        }
    }
    
    
    func showPopupHour(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        guard let experience = selectedExperience, let experienceID = experience.id else{return}
        
        let popup = LocationPopup(nibName: K.NIB.hourPopup, bundle: nil)
        DispatchQueue.main.async {
            // Create the dialog
            let popup = PopupDialog(viewController: popup, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            
            let buttonOne = CancelButton(title: "Cancelar", height: 60) {}
            
            let buttonTwo = DefaultButton(title: "Aceptar", height: 60) {
                
            let time = Singleton.shared.checkValueSet(key:K.defaultKeys.others.setTime)
                
            guard let hour = weak.formatHour(dates: time) else{return}
                guard let date = weak.date else{return}
                print(weak.date)
                print(hour)
                
            guard let myDate = moment("\(date) \(hour)", dateFormat: "yyyyMMdd HH:mm", timeZone: weak.timeZone, locale: weak.locale)else {return}
                
                let refreshAlert = UIAlertController(title: "¿Deseas agregar este horario: \(myDate)?", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { (action: UIAlertAction!) in
                    if !date.isEmpty{
                        
                        
                        //guard let maxReservation = weak.maxReservation else{return}
                        
                        // Add one hour
                        let endTime = (myDate + weak.longExperience.hours).format("yyyyMMdd HH:mm")
                        
                        let startTime = "\(date) \(hour)"
                        
                        let params:Parameters = ["experience_id":experienceID, "start_time":startTime, "end_time":endTime, "max_reservations": weak.maxReservation]
                        ExperiencesManager().setSchedules(header: weak.header, params: params, completionHandler: {
                            schedule in
                            guard let schedule = schedule else{return}
                            print(schedule)
                            
                        })
                        
                        
                        
                        Singleton.shared.removeDefault(toRemove: K.defaultKeys.others.setDate)
                        Singleton.shared.removeDefault(toRemove: K.defaultKeys.others.setTime)
                    }
                    
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in}))
                
                self.present(refreshAlert, animated: true, completion: nil)
            
                
                
                
            }
            
            popup.addButtons([buttonOne, buttonTwo])
            // Present dialog
            weak.present(popup, animated: true, completion: nil)
        }
    }
    
    
    func showPopupDate(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let popup = DatePopup(nibName: K.NIB.datePopup, bundle: nil)
        DispatchQueue.main.async {
            // Create the dialog
            let popup = PopupDialog(viewController: popup, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            
            let buttonOne = CancelButton(title: "Cancelar", height: 60) {}
            let buttonTwo = DefaultButton(title: "Aceptar", height: 60) {
                 let date = Singleton.shared.checkValueSet(key:K.defaultKeys.others.setDate)
                weak.date = date
                weak.dateButton.setTitle(date, for: .normal)
                
            }
            
            popup.addButtons([buttonOne, buttonTwo])
            // Present dialog
            weak.present(popup, animated: true, completion: nil)
            
        }
    }
    
    
    //--Process to update
    @IBAction func updateAction(_ sender: UIButton) {
        dateUpdated()
        
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func dateUpdated(){
        let name = nameTextfield.text
        let description = descriptionTextView.text
        
        setValuesToUpdate(Name: name, Description: description)
    }
        
    func setValuesToUpdate(Name name: String?, Description description: String?) {
        guard let experience = selectedExperience, let experienceID = experience.id, let price = experience.priceInCents else{return}
        
        //-- Temps
        var nameTemp = String()
        var descriptionTemp = String()
        
        //Setting data
        if let name = name{
            nameTemp = !name.isEmpty ? name : "Here goes the name"
        }
        
        if let description = description{
            descriptionTemp = !description.isEmpty ? description :"Here goes a description"
        }
        
        guard let lat = lat else{return}
        guard let lon = lon else{return}
        guard let country = country else{return}
        
        let param:Parameters =
            ["experience_id":experienceID,
             "name":nameTemp,
             "description" : descriptionTemp,
             "lat":lat,
             "long":lon,
             "country":country,
             "price":price]
        updateExperience(param: param)

    }
        
    
    
    func outleetsToHide(_ hidden: Bool){
        maximunLabel.isHidden = hidden
        minuButton.isHidden = hidden
        maxButton.isHidden = hidden
        countLabel.isHidden = hidden
        amountLabel.isHidden = hidden
    }
    
    func showImagePicker(){
       
            let viewController = TLPhotosPickerViewController()
            viewController.delegate = self
            viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
                self?.showExceededMaximumAlert(vc: picker)
            }
            var configure = TLPhotosPickerConfigure()
            configure.numberOfColumn = 3
            configure.maxSelectedAssets = 1
            configure.allowedVideo = false
            viewController.configure = configure
            viewController.selectedAssets = selectedAssets
           
            self.present(viewController, animated: true, completion: nil)
        
    }
    
    
    
    func setScheduleTemp(experience: NewExperienceResponse){
        
        setAssetTemp.removeAll()
        flagCounter = 5
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        if let assets = experience.assets{
            countAssetsLabel.text = Core.shared.countAssets(count: assets)
            weak.assets = assets
            if weak.assets.count > 0{
                
                for i in weak.assets{
                    weak.flagCounter -= 1
                    
                    weak.setAssetTemp.append(assetTemp(id: i.id, url: i.url))
                    
                    
                }
    
                print(weak.setAssetTemp.count + self.flagCounter)
                
                if weak.setAssetTemp.count > 0 && weak.setAssetTemp.count <= 5{
                    
                    for i in weak.setAssetTemp.count ... 5{
                        print(weak.setAssetTemp.count)
                        
                        if weak.setAssetTemp.count <= 5{
                            weak.setAssetTemp.append(assetTemp(id: "", url: ""))
                            weak.assetsCollectionView.reloadData()
                        }
                        
                    }
                    
                }
                
            }
        }
        
    
        
    }
    
    
    //Converting and uploading images
    func changeImage(image:UIImage?){
        
        guard let experience = selectedExperience else{return}
        
        
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
                        
                        guard let experienceID = experience.id else{return}
                        let params:Parameters = ["experience_id":experienceID, "image_url":photo]
                        ExperiencesManager().setAssets(header: weak.header, params: params, completionHandler: {
                            asset in
                            guard let asset = asset else{return}
                            print(asset)
                            guard let experience = weak.selectedExperience, let experienceID = experience.id else{return}
                            ExperiencesManager().getExperienceById(id: experienceID, header: weak.header, completionHandler: {
                                response in
                                guard let response = response else{return}
                                weak.setScheduleTemp(experience: response)
                            })
                        })
                        
                    }
                })
                
            })
        }
    }
    
    
    
    func updateExperience(param:Parameters){
        ExperiencesManager().editExperience(header: header, params: param) {
            experience in
            guard let experience = experience else{return}
            print(experience)
        }
    }
    
    
    
    //--Formating
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
    
    
    // MARK: - Objective C
    
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer){
        
        performSegue(withIdentifier: K.segues.Trips.editExperienceToSearchPlaces, sender: self)
    }

}


class DataController {
    static let shared = DataController()  // singleton object
    
    init() {}
    
    func getData() ->  String{
        // do some operations
        return "dss"
    }
    
    
}
