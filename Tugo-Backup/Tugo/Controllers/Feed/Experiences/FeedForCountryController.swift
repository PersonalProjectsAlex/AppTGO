//
//  FeedForCountryController.swift
//  Tugo
//
//  Created by Alex on 28/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import Lottie

class FeedForCountryController: UIViewController {
    // MARK: - Let-Var
    var experiences = Search()
    var selectedExperience:SearchElement?
    var animationView = LOTAnimationView()
    var selectedCount: CountElement?
    
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    // MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var countryLabel: UILabel!
    
    
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
        if segue.identifier == K.segues.FeedStoryBoard.feedControllerToDetailsController {
            let detailController = segue.destination as! DetailsController
            detailController.selectedExperience = selectedExperience
        }
        
        if segue.identifier == K.segues.FeedStoryBoard.feedControllerToDetailsControllerBigger {
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
        
        guard let country = selectedCount?.country else{return}
        countryLabel.text = country
    }
    
    private func gettingData(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        guard let country = selectedCount?.country else{return}
        let params:Parameters = ["page": 1, "per_page": 30, "country": country]
        
        ExperiencesManager().getExperiences(header: weak.header, params: params) {
            response in
            
            guard let experiences = response else{
                
                return
            }
            print(experiences)
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
