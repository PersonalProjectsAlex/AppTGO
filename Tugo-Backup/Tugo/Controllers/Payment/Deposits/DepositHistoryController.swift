//
//  DepositHistoryController.swift
//  Tugo
//
//  Created by Alex on 24/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import HexColors
import Alamofire

class DepositHistoryController: UIViewController {
    
    // MARK: - Let-Var
    private var accesstokenStore = String()
    //Setting and converting time to refresh a token
    open var time: Double{
        let time = 604800
        return time.msToSeconds.rounded()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var historicalTableView: UITableView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print(time.description)
        Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(callOauth), userInfo: nil, repeats: true)
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
        historicalTableView.delegate = self
        historicalTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: historicalTableView, named: K.cells.table.depositTableCell)
        
        
        //Float Button
//        let floaty = Floaty()
//        floaty.plusColor = .white
//        guard let orange = HexColor(K.colors.floatbuttonOrange) else { return}
//        floaty.buttonColor = orange
//        
//        floaty.addItem("Hello, World!", icon: #imageLiteral(resourceName: "BackIcon"))
//        self.view.addSubview(floaty)
    }
    
    
     // MARK: - Objective C
    
    @objc func callOauth(){
        weak var weakSelf = self
//        guard let weak = weakSelf else{return}
//        let params: Parameters =
//            ["email":"alex@prueba4.com",
//             "account_id":"us_866e1e642f1d9f30",
//             "grant_type": "password",
//             "scope":"users"]
//        UserManager().getOauthToken(params: params) { (response) in
//            print(response?.access_token)
//            guard let access_token = response?.access_token else {return}
//            weak.accesstokenStore = access_token
//        }
        
    }
    
    
   
    

}
