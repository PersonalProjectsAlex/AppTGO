//
//  ExperiencesIncomeController.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class ExperiencesIncomeController: UIViewController {

    // MARK: - Let-Var
    
    // MARK: - Outlets
    @IBOutlet weak var experiencesTableView: UITableView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){
        //Tableview Delegate
        experiencesTableView.delegate = self
        experiencesTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: experiencesTableView, named: K.cells.table.Host.experienceIncomeTableCell)
    }
    
    private func gettingData(){}
    
    // MARK: - Objective C
    

}
