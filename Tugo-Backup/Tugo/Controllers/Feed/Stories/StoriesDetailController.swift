//
//  StoriesDetailController.swift
//  Tugo
//
//  Created by Alex on 28/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class StoriesDetailController: UIViewController {

    // MARK: - Let-Var
    var  experiences = Search()
    var selectedExperience:SearchElement?
    var selectedCategory:Category?
    
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    // MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
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
        if segue.identifier == K.segues.FeedStoryBoard.storiesdetailToDetailController {
            let detailController = segue.destination as! DetailsController
            detailController.selectedExperience = selectedExperience
        }
        
        if segue.identifier == K.segues.FeedStoryBoard.storiesdetailToDetailControllerBigger {
            let detailController = segue.destination as! DetailsController
            detailController.selectedExperience = selectedExperience
        }
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Separator color on tableview
        feedTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        //Tableview Delegate
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: feedTableView, named: K.cells.table.feedTableCell)
        
        
        //Set categiry name
        guard let category = selectedCategory else {return}
        let replaced = category.name.replacingOccurrences(of: "ig_", with: "")
        categoryNameLabel.text =  replaced.capitalizingFirstLetter()
    }
    
    private func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let category = selectedCategory else {return}
        let params: Parameters = ["category_id":category.id, "page": 1, "per_page": 35]
        ExperiencesManager().getExperiencesPercategories(header: header, params: params) {
            response in
            guard let experiences = response else {return}
            weak.experiences = experiences
            if weak.experiences.count > 0{
                weak.feedTableView.reloadData()
            }
        }
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C
    

}
