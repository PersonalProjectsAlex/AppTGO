//
//  SearchPlaces.swift
//  Tugo
//
//  Created by Alex on 1/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlacesSearchController



class EditExperienceSearchPlaces: UIViewController,UISearchBarDelegate,MKMapViewDelegate {
    
    // MARK: - Let-Var
    var experienceHostInfo = [ExperienceHostInfo]()
    var experienceHostModel:  ExperienceHostModel?
    var lat: Double?
    var lon:Double?
    var country: String?
    let annotation = MKPointAnnotation()
    var myAnnotations = [CLLocation]()
    
    let GoogleMapsAPIServerKey = K.geocodeKey
    
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self,
                                                      apiKey: GoogleMapsAPIServerKey,
                                                      placeType: .all,
                                                      strictBounds: true,
                                                      searchBarPlaceholder: "¿A dónde comenzarémos?"
            
        )
        controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancelar"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "Circular Std", size: 15.0)!], for: .normal)
        if let textfield = controller.searchBar.value(forKey: "searchField") as? UITextField {
           
            textfield.backgroundColor = .white
            textfield.font = UIFont(name: "Circular Std", size: 15.0)
        }
        return controller
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var mapkitView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LifeCycles
    
    override func viewDidAppear(_ animated: Bool) {
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK: - Navigation
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Searchbar
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = .white
            textfield.font = UIFont(name: "Circular Std", size: 15.0)
        }
    }
    
    func setUpActions(){
        //SearchBar Delegate
        searchBar.delegate = self
        //Mapkit
        mapkitView.delegate = self
        mapkitView.isScrollEnabled = true
        mapkitView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        mapkitView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func gettingData(){}
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        weak var weakSelf = self
        if let weak = weakSelf{
            DispatchQueue.main.async {
                weak.present(weak.placesSearchController, animated: true, completion: {
                    
                })
            }
        }
        return false
    }
   
    //Getting city and country by checkmarks

    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        guard let lat = lat else{return}
        guard let lon = lon else{return}
        guard let country = country else{return}
        
        if let presenter = presentingViewController as? EditExperienceController {
            presenter.lat = lat
            presenter.lon = lon
            presenter.country = country
        }
        
        dismiss(animated: true, completion: nil)
    }
   
    
    // MARK: - Objective C
    
}

extension EditExperienceSearchPlaces: GooglePlacesAutocompleteViewControllerDelegate {
    func viewController(didAutocompleteWith place: PlaceDetails) {
        
        experienceHostInfo.removeAll()
        
        print(place.description)
        guard let coordinate = place.coordinate else{return}
        guard let lat = place.coordinate?.latitude.description.toDouble(), let lon = place.coordinate?.longitude.description.toDouble() else{return}
        let location = CLLocation(latitude: lat, longitude: lon)
        
        addPinMapkit(coordinate: coordinate, location: location, lat: lat, long: lon)
        placesSearchController.isActive = false
    }
   
    func addPinMapkit(coordinate: CLLocationCoordinate2D, location: CLLocation, lat: Double, long: Double){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let annotationsToRemove = mapkitView.annotations
       
        //Remove all annotations in the array from the mapView
        if let aRemove = annotationsToRemove as? [MKAnnotation] {
            mapkitView.removeAnnotations(aRemove)
        }
        
        fetchCityAndCountry(from: location) { (city, country, error) in
            guard let city = city, let country = country, error == nil else { return }
            
            weak.lat = lat
            weak.lon = long
            weak.country = country
            
            
        }
        
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        weak.annotation.coordinate = coordinate
        mapkitView.region = region
        mapkitView.addAnnotation(annotation)
        
    }
    
    // MARK: - Objective C
  
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let annotationsToRemove = mapkitView.annotations
        if let aRemove = annotationsToRemove as? [MKAnnotation] {
            mapkitView.removeAnnotations(aRemove)
        }
        
        let touchPoint = recognizer.location(in: mapkitView)
        let newCoordinates = mapkitView.convert(touchPoint, toCoordinateFrom: mapkitView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        print(newCoordinates)
        
        let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        fetchCityAndCountry(from: location) { (city, country, error) in
            guard let city = city, let country = country, error == nil else { return }
            
            weak.lat = newCoordinates.latitude
            weak.lon = newCoordinates.longitude
            weak.country = country
            print(country)
            
        }
        mapkitView.addAnnotation(annotation)
    }
    
}

