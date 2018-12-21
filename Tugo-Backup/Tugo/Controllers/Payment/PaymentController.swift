//
//  PaymentController.swift
//  Tugo
//
//  Created by Alex on 20/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class PaymentController: UIViewController{
    
    // MARK: - Let-Var
    
    // MARK: - Outlets
    @IBOutlet weak var depositTableView: UITableView!

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        depositTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        
        //Tableview Delegate
        depositTableView.delegate = self
        depositTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: depositTableView, named: K.cells.table.depositTableCell)
        
        
        
    }
    
    private func gettingData(){}
    
    // MARK: - Objective C
 

}
