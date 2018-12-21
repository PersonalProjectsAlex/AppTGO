//
//  ImboxHostController.swift
//  Tugo
//
//  Created by Alex on 18/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class ImboxHostController: UIViewController {

    // MARK: - Let-Var
    // MARK: - Outlets
    @IBOutlet weak var imboxTableView: UITableView!
    
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
        imboxTableView.delegate = self
        imboxTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: imboxTableView, named: K.cells.table.Host.imboxHostTableCell)
    }
    
    
    private func gettingData(){}
    
    @IBAction func closeModal(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C
    

}
