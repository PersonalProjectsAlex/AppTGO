//
//  CompleteregistrationController.swift
//  Tugo
//
//  Created by Alex on 13/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import LTMorphingLabel
import NVActivityIndicatorView

class CompleteregistrationController: UIViewController,LTMorphingLabelDelegate, NVActivityIndicatorViewable {
    // MARK: - Let-Var
     var selectedSingleUser: SingleUser?
    // MARK: - Outlets
    @IBOutlet weak var photoImageview: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        //Calling data with object
        gettingData()
        
    }

    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){
        //Delegating morping
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    private func gettingData(){
        //Setting data which comes from the last one controller
        guard let singleUser = selectedSingleUser, let userID = singleUser.userID, let photo = singleUser.photo else {return}
        photoImageview.sd_setImage(with: URL(string: photo), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        
    }
    
    @IBAction func completeRegistrationAction(_ sender: UIButton) {
        guard let userName = usernameTextfield.text, !userName.isEmpty else{return}
        singUp(userName)
    }
    
    
    func singUp(_ userName: String){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        customLoading()
        
        guard let singleUser = selectedSingleUser,
            let userID = singleUser.userID,
            let photo = singleUser.photo,
            let email = singleUser.email,
            let firstName = singleUser.fistName,
            let lastName = singleUser.lastName else {return}
        
        let params: Params =
            ["email": email ,
             "username": userName,
             "account_id": userID ,
             "lastname": lastName ,
             "firstname": firstName ,
             "avatar": photo]
        
        UserManager().registerUser(params: params) { (register) in
            
            guard let message = register?.message else{
                guard let accesToken = register?.accessToken, let refreshToken = register?.refreshToken, let expiresIn = register?.expiresIn, let scope = register?.scope else{ return}
                
                Singleton.shared.socialSignIn(true)
                Singleton.shared.setOAuthToken(accesToken, refreshToken, expiresIn, scope)
                Singleton.shared.setCurrentUser(userName, photo, firstName)
                weak.stopAnimating()
                Singleton.shared.setStepProfile(isNew:true)
                Singleton.shared.saveSignInState()
                weak.performSegue(withIdentifier: K.segues.AuthStoryboard.completeToMenu, sender: self)
                return
            }
            self.stopAnimating()
            Core.shared.alert(message: "El usuario no pude ser creado o el username no puede ser utilizado", title: "Algo sucedio:", at: weak)
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
