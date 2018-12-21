//
//  PaymentProfileController.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class PaymentProfileController: UIViewController {
    
    // MARK: - Let-Var
    var cards = Card()
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }

    
    // MARK: - Outlets
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var addLabel: UILabel!
    
    
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
        
    }
    
    func setUpActions(){
        //Tableview Delegate
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: paymentTableView, named: K.cells.table.methodTableCell)
    }
    
    private func gettingData(){
        cards.removeAll()
        paymentTableView.reloadData()
        emptyImageView.isHidden = true
        indicatorView.startAnimating()
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().getCards(header: header) { (cards) in
            guard let cards = cards else{
                weak.emptyImageView.isHidden = false
                weak.addLabel.isHidden = true
                weak.indicatorView.stopAnimating()
                weak.indicatorView.isHidden = true
                return
                
            }
            self.cards = cards
           
            if weak.cards.count > 0{
                DispatchQueue.main.async {
                    weak.emptyImageView.isHidden = true
                    weak.addLabel.isHidden = false
                    weak.indicatorView.stopAnimating()
                    weak.indicatorView.isHidden = true
                }
                
                weak.paymentTableView.reloadData()
            }else{
                weak.emptyImageView.isHidden = false
                weak.addLabel.isHidden = true
                weak.indicatorView.stopAnimating()
                weak.indicatorView.isHidden = true
            }
            
        }
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
