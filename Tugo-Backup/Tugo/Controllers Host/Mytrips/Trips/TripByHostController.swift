//
//  TripByHostController.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class TripByHostController: UIViewController {

    // MARK: - Let-Var
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    var fromState = false
    var experiences = [NewExperienceResponse]()
    var selectedExperience: NewExperienceResponse?
    
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var tripTableView: UITableView!
    
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
 
        if segue.identifier ==  "TripControllerToDetail"{
            let detailController = segue.destination as! TripsHostDetailController
            
            detailController.selectedExperience = selectedExperience
            
        }
        
        if segue.identifier == K.segues.Trips.myTripsToEdit{
            let detailController = segue.destination as! EditExperienceController
            
            detailController.selectedExperience = selectedExperience
        }
        
    }
 
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}

    func setUpActions(){
        
        //Tableview Delegate
        tripTableView.delegate = self
        tripTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: tripTableView, named: K.cells.table.Host.myTripsTableCell)
        
    }

    func gettingData(){
        experiences.removeAll()
        tripTableView.reloadData()
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let params:Parameters = ["page": 1, "per_page": 25]
        ExperiencesManager().getExperienceHost(header: header, params: params) {
            experience in
            guard let experience = experience else{return}
            weak.experiences = experience
            print(experience)
            if weak.experiences.count > 0{
                weak.tripTableView.reloadData()
            }
        }
        
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        
        
        if fromState{
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "MenuHost", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "MainTabBarHostController") as! MainTabBarHostController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //show window
                appDelegate.window?.rootViewController = view
                
            }

        }else{
            
            dismiss(animated: true) {
                if let tabBarController = self.presentingViewController as? MainTabBarHostController {
                    tabBarController.selectedIndex = 0
                }
            }
        
        }
        
        }
        
    
    
    
    // MARK: - Objective C
   

    
}
