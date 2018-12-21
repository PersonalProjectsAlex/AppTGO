//
//  FeedController.swift
//  Tugo
//
//  Created by Alex on 17/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SwiftMessages
import HexColors
import Alamofire
import  Lottie
import UserNotifications
import UserNotificationsUI
import SimpleImageViewer
import TableFlip



class FeedController: UIViewController,UISearchBarDelegate{
    
    // MARK: - Let-Var
    var experiences = Search()
    var selectedExperience:SearchElement?
    var categories = Categories()
    var selectedCategory:Category?
    var animationView = LOTAnimationView()
    let isNew = Singleton.shared.checkisBool(key: K.defaultKeys.others.isNew)
    let instanceHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.signInhost)
    private let refreshControl = UIRefreshControl()
   
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var imboxButton: UIButton!
    @IBOutlet weak var badgeButton: MIBadgeButton!
    @IBOutlet weak var widthBadgeButton: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIView!
    
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        //creating the notification content
        Core.shared.askForNotifications()

        //setting badge
        badgeButton.badgeString = "4"
        badgeButton.badgeEdgeInsets = UIEdgeInsetsMake(10, 3, 0, 15)
       
        //!instanceHost.isEmpty ?
        badgeButton.isHidden = !instanceHost.isEmpty ? false : true
        widthBadgeButton.constant = !instanceHost.isEmpty ? 81 : 0
        
        print(header)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gettingData()
        gettingCategories()
       
        if isNew{
             DispatchQueue.main.async {
               self.newUserAlert()
            }
            
        }
        
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
        
        if segue.identifier == K.segues.FeedStoryBoard.feedControllerToDetailsControllerBigger{
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
        
        //Hidding-Showinf imbox
        
        imboxButton.isHidden = !instanceHost.isEmpty ? false : true
        
        //Tableview animator
        
        
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
        
       
        //Setting lottie
        animationView = LOTAnimationView(name: "loading")
        
        //Refresh control
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
    }
    
    func gettingData(){
        Core.shared.playLottie(lottie: .loading, action: .play, animationView: animationView, at: self)
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        experiences.removeAll()
        feedTableView.reloadData()
        let params:Parameters = ["page": 1, "per_page": 35]
        
        ExperiencesManager().getExperiences(header: weak.header, params: params) {
            response in
            
            guard let experiences = response else{
                Core.shared.playLottie(lottie: .loading, action: .stop, animationView:  weak.animationView, at: weak)
                weak.refreshControl.endRefreshing()
                return
            }
            
            weak.experiences = experiences
           
            if weak.experiences.count > 0{
                Core.shared.playLottie(lottie: .loading, action: .stop, animationView:  weak.animationView, at: weak)
                weak.refreshControl.endRefreshing()
                weak.feedTableView.reloadData()
        
                let leftAnimation = TableViewAnimation.Cell.left(duration: 0.8)
                weak.feedTableView.animate(animation: leftAnimation)
                
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

    
    func newUserAlert() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        Core.shared.customAlertNavbar(at: self.view).addGestureRecognizer(recognizer)
    }
    
    // MARK: - Objective C
    @objc func didTap() {
      self.tabBarController?.selectedIndex = 3
    }

    
    @objc private func refreshData(_ sender: Any) {
        gettingData()
        
    }
    
}
