//
//  ChangePasswordController.swift
//  Tugo
//
//  Created by Alex on 26/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ChangePasswordController: UIViewController, NVActivityIndicatorViewable{

    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var currentPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordtextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()

    }
    
    // MARK: - Navigation
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){}
    
    private func gettingData(){}
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let lastPassword = currentPasswordTextfield.text, !lastPassword.isEmpty else{return}
        guard let newPassword = newPasswordtextfield.text, !newPassword.isEmpty else{return}
        guard let confirmPassword  = confirmPasswordTextfield.text, !confirmPassword.isEmpty else{return}
        let confirmState = Core.shared.confirmPassword(password: newPassword, confirm: confirmPassword)
        if !confirmState{
            Core.shared.alert(message: "La contraseña no coincide", title: "Error:", at: weak)
        }else{
            let params: Parameters = ["password":lastPassword, "new_password":newPassword, "new_password_confirmation":confirmPassword]
            weak.changePassword(params: params)
        }
        
    }
    
    private func changePassword(params:Parameters){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        customLoading()
        
        UserManager().changePassword(header: header, params: params) {
            password in
            guard let password = password else{
                weak.stopAnimating()
                return
            }
            weak.stopAnimating()
            weak.confirmPasswordTextfield.text = ""
            weak.confirmPasswordTextfield.text = ""
            weak.currentPasswordTextfield.text = ""
            Core.shared.alert(message: "Contraseña actualizada con éxito", title: "Correcto", at: weak)
        }
    }
    
    //Custom loading
    func customLoading(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let size = CGSize(width: 32, height: 32)
        weak.startAnimating(size, message: "", type: NVActivityIndicatorType.circleStrokeSpin)
    }
    
    // MARK: - Objective C
    

}
