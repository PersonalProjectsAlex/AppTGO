//
//  FavouritesHostController.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class FavouritesHostController: UIViewController {

    // MARK: - Let-Var
    
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    var _selectedCells : NSMutableArray = []
    var favourites = [FavouritesModel]()
    var categories = Categories()
    let defaults = UserDefaults.standard
    var array = [String]()
    var fromBack = false
    var experienceResponse: NewExperienceResponse?
    
    //From segue
    var tempExperienceData = [TempNewExperience]()
    var imagesArray = [UIImage]()
    var scheduleHours = [String]()
    var selectedDates = [Date]()
    var maxReservation: Int?
    var longExperience = Int()
    

    // MARK: - Outlets
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        gettingData()
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.segues.ExperiencesHost.categoriesToSetPrice{
            let detailController = segue.destination as! PriceExperienceController
            detailController.experienceResponse = experienceResponse
            detailController.selectedDates = selectedDates
            detailController.scheduleHours = scheduleHours
            detailController.imagesArray = imagesArray
            detailController.tempExperienceData = tempExperienceData
            detailController.favourites = favourites
            detailController.maxReservation = maxReservation
            detailController.longExperience = longExperience
        }
        
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
      
    }
    
    func setUpActions(){
        //Delegating collectionview
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.allowsMultipleSelection = true
        favouritesCollectionView.allowsSelection = true
        
            //Set Cell Identifier
        Core.shared.registerCellCollection(at: favouritesCollectionView, named: K.cells.collection.favouritesHostCollectionCell)
        
        
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        if favourites.count > 0{
            weak.performSegue(withIdentifier: K.segues.ExperiencesHost.categoriesToSetPrice, sender: weak)
        }
    }
    
    //Getting categories
    private func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        categories.removeAll()
        
        CategoriesManager().getCategories(header: header) { (categories) in
            guard let categories = categories else{return}
            weak.categories = categories
            
            if weak.categories.count > 0{
                weak.favouritesCollectionView.reloadData()
            }
        }
    }
    
    
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        if let presenter = presentingViewController as? SetExperienceDateController {
            presenter.fromBack = true
            presenter.favourites = favourites
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C

}
