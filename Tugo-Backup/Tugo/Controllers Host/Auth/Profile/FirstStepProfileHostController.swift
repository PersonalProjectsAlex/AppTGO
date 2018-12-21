//
//  FirstStepProfileHostController.swift
//  Tugo
//
//  Created by Alex on 4/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import UserNotifications

class FirstStepProfileHostController: UIViewController {

    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var accountButton: UIButton!
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()

        print(header)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       gettingData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.AuthHost.hostFirstStepToValidateMail {
            
            let detailController = segue.destination as! ValidateCodeHostController
            //detailController.selectedSingleUser = singleUser.first

        }
    }
    
    // MARK: - SetUps / Funcs

    func setUpUI(){
        //Setting background gradient
        Core.shared.settinGradientHost(at: accountButton)
        
    }
    
    func setUpActions(){
        
    }
    
    func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().getUserInfo(header: header) {
            userinfo in
            guard let userinfo = userinfo else{
                return
            }
            weak.avatarImageView.sd_setImage(with: URL(string: userinfo.avatar), placeholderImage: #imageLiteral(resourceName: "tugologo"))
            
            
        }
        
        
    }
    
    func settingData(){
    
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        guard let firstName = weak.profileNameTextField.text, !firstName.isEmpty else{
            Core.shared.alert(message: "Debes ingresar un nombre a tu perfil", title: "Error:", at: weak)
            return
        }
        
        guard let aboutMe = weak.aboutMeTextView.text, !aboutMe.isEmpty else{
            Core.shared.alert(message: "Debes hablarnos acerca de ti!", title: "Error:", at: weak)
            return
        }
        
        
        
            let params:Parameters = ["about_me": aboutMe, "firstname": firstName]
        

            HostManager().updateHost(header: weak.header, params: params, completionHandler: {
                host in
                guard let host = host else{return}
                let accessToken = host.accessToken
                let refresToken = host.refreshToken
                let scope = host.scope
                
                Singleton.shared.setOauthTokenHost(accessToken, refresToken, scope)
                Singleton.shared.saveSignInStateForHost()
                
                weak.performSegue(withIdentifier: K.segues.AuthHost.lastStepToMenuHost, sender: weak)
                
            })
        
    
    }
    
    @IBAction func AskForAccountAction(_ sender: UIButton) {
        settingData()
    }
    
   
    // MARK: - Objective C
    

}
