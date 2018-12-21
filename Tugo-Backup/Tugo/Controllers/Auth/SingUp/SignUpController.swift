//
//  SignUpController.swift
//  Tugo
//
//  Created by Alex on 3/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class SignUpController: UIViewController {
    // MARK: - Let-Var
    var imageURL:String?
    // MARK: - Outlets
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectImageview: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    
    
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
        //Iamgeview on tap
        selectImageview.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        selectImageview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func settingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let image = imageURL, !image.isEmpty else {
            print("imageURL vacia")
            return
        }
        
        guard let firstname = nameTextfield.text, !firstname.isEmpty else {
            Core.shared.alert(message: "Error", title: "El campo nombre es requerido", at: weak)
            return
        }
        
        guard let username = usernameTextfield.text, !username.isEmpty else {
            print("Vacio")
            return
        }
        
        guard let email = mailTextfield.text, !email.isEmpty else {
            print("Vacio")
            return
        }
        
        
        guard let password = passwordTextfield.text, let confirm = confirmTextfield.text,
            !password.isEmpty, !confirm.isEmpty else{
            print("Vacio password")
            return
        }
        
        
        let confirmState = Core.shared.confirmPassword(password: password, confirm: confirm)
        let emailState = Core.shared.isValidEmail(testStr: email)
    
        if !confirmState || !emailState{
         print("Error en validar")
        }else{
            let params: Params =
            ["email": email ,
             "password": password ,
             "password_confirmation": confirm ,
             "username": username ,
             "firstname": firstname ,
             "avatar": image]
            
            UserManager().registerUser(params: params) { (register) in
                
                guard let message = register?.message else{
                    guard let accesToken = register?.accessToken, let refreshToken = register?.refreshToken, let expiresIn = register?.expiresIn, let scope = register?.scope else{ return}
                    Singleton.shared.setOAuthToken(accesToken, refreshToken, expiresIn, scope)
                    Singleton.shared.setCurrentUser(username, image, firstname)
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else if let user = user {
                            print(user)
                        }
                    }
                    
                    
                    weak.registerSendbird(nickname: firstname, userID: username, userPhoto: image)
                    Singleton.shared.setStepProfile(isNew:true)
                    self.performSegue(withIdentifier: K.segues.AuthStoryboard.signUpToMenu, sender: weak)
                    return
                }
                
                Core.shared.alert(message: "El usuario no pude ser creado o el username no puede ser utilizado", title: "Algo sucedio:", at: weak)
            }
        }
    
        
    }
    
    
    @IBAction func signupAction(_ sender: UIButton) {
        settingData()
    }
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Objective C
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer){
        // if the tapped view is a UIImageView then set it to imageview
        showInputDialog()
    }
}
