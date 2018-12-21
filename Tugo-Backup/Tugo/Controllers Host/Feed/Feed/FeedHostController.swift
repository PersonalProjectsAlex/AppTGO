//
//  FeedHostController.swift
//  Tugo
//
//  Created by Alex on 18/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

import UIKit
import SwiftMessages
import HexColors
import Alamofire
import  Lottie

class  FeedHostController: UIViewController,UISearchBarDelegate{
    
    // MARK: - Let-Var
    var experiences = Search()
    var selectedExperience:SearchElement?
    var categories = Categories()
    var selectedCategory:Category?
    var animationView = LOTAnimationView()
    
    open var header: HTTPHeaders{
        
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var badgeButton: SSBadgeButton!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        
        // setting up UI elements to be used through the code
        setUpUI()
        badgeButton.badge = "2"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gettingData()
        gettingCategories()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftMessages.hide()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.FeedStoryBoard.feedControllerToDetailsController {
            let detailController = segue.destination as! DetailsController
            detailController.selectedExperience = selectedExperience
        }
        
        if segue.identifier == K.segues.FeedStoryBoard.storiesToCategoryPerStorie {
            let detailController = segue.destination as! StoriesDetailController
            detailController.selectedCategory = selectedCategory
        }
        
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        
        
        //Searchbar
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = HexColor(K.colors.searchBarBackground)
        }
        
        //Separator on tableview
        feedTableView.separatorColor = .clear
        
    }
    
    func setUpActions(){
        //Tableview Delegate
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        //CollectionView Delegate
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        
        
        //SearchBar Delegate
        searchBar.delegate = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: feedTableView, named: K.cells.table.feedTableCell)
        Core.shared.registerCellCollection(at: storiesCollectionView, named: K.cells.collection.storiesCollectionCell)
        
        //Showing message
        
        //Setting lottie
        animationView = LOTAnimationView(name: "prueba")
    }
    
    func gettingData(){
        //Core.shared.playLottie(lottie: .prueba, action: .play, animationView: animationView, at: self)
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        experiences.removeAll()
        feedTableView.reloadData()
        
        let params:Parameters = ["page": 1, "per_page": 30, "country":"El Salvador"]
        
        ExperiencesManager().getExperiences(header: weak.header, params: params) {
            response in
            
            guard let experiences = response else{
                Core.shared.playLottie(lottie: .prueba, action: .stop, animationView:  weak.animationView, at: weak)
                return
            }
            
            weak.experiences = experiences
            if weak.experiences.count > 0{
                Core.shared.playLottie(lottie: .prueba, action: .stop, animationView:  weak.animationView, at: weak)
                weak.feedTableView.reloadData()
            }
        }
    }
    
    
    
    //Getting categories
    private func gettingCategories(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        categories.removeAll()
        
        CategoriesManager().getCategories(header: header) { (categories) in
            guard let categories = categories else{return}
            weak.categories = categories
            
            if weak.categories.count > 0{
                weak.storiesCollectionView.reloadData()
            }
        }
    }
    
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        weak var weakSelf = self
        if let weak = weakSelf{
            weak.performSegue(withIdentifier: K.segues.FeedStoryBoard.feedControllerToSearchController, sender: nil)
        }
        return false
    }
    
    
    
    
    
    // MARK: - Objective C
//    @objc func didTap() {
//        self.performSegue(withIdentifier: K.segues.FeedStoryBoard.feedControllerToProfileController, sender: self)
//    }
    
}
