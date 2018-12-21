//
//  CountriesExperiencesController.swift
//  Tugo
//
//  Created by Alex on 24/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class CountriesExperiencesController: UIViewController {

    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    var count = Count()
    var selectedCount:CountElement?
    // MARK: - Outlets
    @IBOutlet weak var countriesTableView: UITableView!
    
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
        if segue.identifier == K.segues.FeedStoryBoard.countriesToFeedForCountry {
            let detailController = segue.destination as! FeedForCountryController
            detailController.selectedCount = selectedCount
        }
    }
    
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Setting color on separator
        countriesTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        //Tableview Delegate
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: countriesTableView, named: K.cells.table.boxExperiencesTableCell)
    }
    
    private func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
       
        ExperiencesManager().getCountExperiences(header: header) {
            result in
            guard let count = result else{return}
            
            weak.count = count
            
            if let index = weak.count.index(where: {$0.countryCount < 1}) {
                weak.count.remove(at: index)
            }
            
            
            if weak.count.count > 0 {
                weak.countriesTableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    // MARK: - Objective C
 

}
