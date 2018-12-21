//
//  ScondeStepProfileHostController.swift
//  Tugo
//
//  Created by Alex on 5/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire

class ScondeStepProfileHostController: UIViewController {

    // MARK: - Let-Var
    
    var imageURL:String?
    var image:UIImage?
    var email:String?
    var firstName: String?
    var avatar: String?
    var userName: String?
    
    
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
    @IBOutlet weak var documentNumberTextfield: UITextField!
    @IBOutlet weak var offerTextfield: UITextField!
    @IBOutlet weak var accountButton: UIButton!
    
    
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
        
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Setting background gradient
        Core.shared.settinGradientHost(at: accountButton)
        
    }
    
    func setUpActions(){}
    
    func settingData(){}
    
    func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().getUserInfo(header: header) {
            userinfo in
            guard let userinfo = userinfo else{
                return
            }
            
            weak.avatar = userinfo.avatar
            weak.userName = userinfo.username
            weak.email = userinfo.email
            weak.firstName = userinfo.firstname
            print(userinfo.accessToken)
            
        }
        
        
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
       showInputDialog()
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let document = documentNumberTextfield.text, !document.isEmpty else {
            Core.shared.alert(message: "Debes ingresar un numero de documento", title: "Error:", at: weak)
            return
        }
        
        guard let descriptiion = offerTextfield.text, !descriptiion.isEmpty else{
            Core.shared.alert(message: "Debes ingresar una descripción de los servicios turísticos", title: "Error:", at: weak)
            return
        }
       
        guard let image = imageURL, !image.isEmpty else{
            Core.shared.alert(message: "Antes de continuar necesitamos verificar tu identidad con una fotografía de tu pasaporte", title: "Error:", at: weak)
            return
        }
        
        updateHost(description: descriptiion, document: document, documentImage: image)
    }
    
    func updateHost(description: String, document: String, documentImage: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let email = email else{return}
        guard let userName = userName else{return}
        guard let avatar = avatar else{return}
        guard let firstname = firstName else{return}
        
        let params:Parameters = ["email": email, "firstname": firstname, "avatar": avatar, "username": userName, "identification_number":document, "passport_url": documentImage, "services_description": description]
        
        HostManager().registerHost(header: header, params: params) {
            host in
            guard let host = host else{return}
            print(host)
            Singleton.shared.savePedingCodeState(true)
            Core.shared.buildNotification(body: "Debes revisar tu correo en donde recibirás un código", title: "Tugo te informa:", id: "mail")
        
            weak.performSegue(withIdentifier: K.segues.AuthHost.hostFirstStepToValidateMail, sender: weak)
        }
        
        
    }
    
    
    // MARK: - Objective C

}
