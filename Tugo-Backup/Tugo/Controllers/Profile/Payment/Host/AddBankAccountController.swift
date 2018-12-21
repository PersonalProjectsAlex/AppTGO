//
//  AddBankAccountController.swift
//  Tugo
//
//  Created by Alex on 24/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class AddBankAccountController: UIViewController {

    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var addAccountButton: UIButton!
    @IBOutlet weak var numberAccountTextfield: UITextField!
    @IBOutlet weak var bankNametextfield: UITextField!
    
    
    
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
    
    func setUpUI(){
        
    }

    func setUpActions(){
        
    }

    private func gettingData(){
        
    }
    
    @IBAction func addAccountAction(_ sender: UIButton) {
        
        guard let number = numberAccountTextfield.text else{return}
        guard let name = bankNametextfield.text else {return}
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let params: Parameters = ["bank_name":name,"bank_account":number]
        HostManager().updateHost(header: header, params: params) { user in
            guard let user = user else {return}
            print(user)
            Core.shared.alert(message: "La cuenta fue agregada exitosamente", title: "Hecho", at: weak)
        }
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C
    

}
