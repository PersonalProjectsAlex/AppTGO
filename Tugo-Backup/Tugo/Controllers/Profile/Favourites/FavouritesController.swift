//
//  FavouritesController.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class FavouritesController: UIViewController {

    // MARK: - Let-Var
    var _selectedCells : NSMutableArray = []
    var favourites = [FavouritesModel]()
    var categoriesMe = MyFavourites()
    var categories = Categories()
    
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }

    // MARK: - Outlets
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    let defaults = UserDefaults.standard
    var array = [String]()
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        //Delegating collectionview
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.allowsMultipleSelection = true
        favouritesCollectionView.allowsSelection = true
        
            //Set Cell Identifier
        Core.shared.registerCellCollection(at: favouritesCollectionView, named: K.cells.collection.favouritesCollectionCell)
        
        
    }
    
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        if favourites.count > 0{
            for i in favourites{
                guard let categoryID = i.index else{return}
                weak.setCategories(categoryID: categoryID)
            }
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
        
        
        CategoriesManager().getCategoriesMe(header: header) { (categories) in
            guard let categories = categories else{return}
            weak.categoriesMe = categories
            print(categories)
            if weak.categoriesMe.count > 0{
                
                weak.favouritesCollectionView.reloadData()
            }
        }
        
        
        
    }
    
    //Setting categories
    private func setCategories(categoryID: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let params: Parameters = ["category_id": categoryID]
       
        CategoriesManager().setNewCategories(header: header , params: params) {
            categories in
            guard let categories = categories else{return}
            weak.gettingData()
            
            
        }

    }
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C

}
