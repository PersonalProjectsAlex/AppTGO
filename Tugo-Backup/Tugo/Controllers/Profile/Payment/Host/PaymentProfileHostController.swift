//
//  PaymentProfileController.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class PaymentProfileHostController: UIViewController {
    
    // MARK: - Let-Var
    var cards = Card()
    var bankAccount = [BankAccount]()
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var depositTableView: UITableView!
    @IBOutlet weak var hideViewBankAccount: UIView!
    @IBOutlet weak var addbankAccountButton: UIButton!
    
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
        //Getting cards
        gettingData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Separator color
        //paymentTableView.separatorColor = .clear
        
        depositTableView.separatorColor = .clear
        
    }
    
    func setUpActions(){
        //Tableview Delegate
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        depositTableView.delegate = self
        depositTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: paymentTableView, named: K.cells.table.methodTableCell)
        Core.shared.registerCell(at: depositTableView, named: K.cells.table.methodTableCell)
    }
    
    private func gettingData(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        cards.removeAll()
        paymentTableView.reloadData()
        bankAccount.removeAll()
        
        UserManager().getCards(header: header) { (cards) in
            guard let cards = cards else{return}
            self.cards = cards
           
            if self.cards.count > 0{
                self.paymentTableView.reloadData()
            }
            
        }
        
        
        UserManager().getUserInfo(header: header) {
            userinfo in
            guard let userinfo = userinfo else{return}
            if let bankAccount = userinfo.host?.bankAccount, !bankAccount.isEmpty{
                weak.hideViewBankAccount.isHidden = true
                weak.addbankAccountButton.isHidden = true
                weak.addbankAccountButton.isUserInteractionEnabled = false
                print(bankAccount)
                weak.bankAccount.append(BankAccount(accountNumber: bankAccount))
                weak.depositTableView.reloadData()
            }
        }
        
       Core.shared.callOauth()
        
       
    }
    
   
    func deleteCard(_ cardID: String){
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        
        
        UserManager().deleteCard(header: header , card: cardID) { (card) in
            guard let card = card else{return}
            Core.shared.alert(message: "Su tarjeta fue eliminada", title: "Exito", at: self)
            self.gettingData()
        }
        
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    

    // MARK: - Objective C
    
    
}
