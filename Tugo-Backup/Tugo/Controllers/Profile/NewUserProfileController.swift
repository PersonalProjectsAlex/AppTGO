//
//  NewUserProfileController.swift
//  Tugo
//
//  Created by Alex on 5/11/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

class NewUserProfileController: UIViewController {
    
    
    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    
    // MARK: - Outlets
    
        //--Steps outlets
    @IBOutlet weak var stepsPresenterView: UIView!
    @IBOutlet weak var firstStepImageView: UIImageView!
    @IBOutlet weak var secondStepView: UIImageView!
    @IBOutlet weak var stepsChangeNameTextfield: UITextField!
    @IBOutlet weak var setNameStepButton: UIButton!
    @IBOutlet weak var setAboutMeStepTextView: UITextView!

    @IBOutlet weak var usernameStepLabel: UITextField!
    @IBOutlet weak var incompleteinfoView: UIView!
    @IBOutlet weak var incompleteCardsView: UIView!
    @IBOutlet weak var aboutMeView: UIView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gettingData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
 
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        
        let tapGestureInompleteinfoView = UITapGestureRecognizer(target: weak, action: #selector(weak.handleTapInfo(recognizer:)))
        incompleteinfoView.addGestureRecognizer(tapGestureInompleteinfoView)
        
        let tapGestureIncompleteCardsView = UITapGestureRecognizer(target: weak, action: #selector(weak.handleTapCards(recognizer:)))
        incompleteCardsView.addGestureRecognizer(tapGestureIncompleteCardsView)
        
        let tapGestureAboutme = UITapGestureRecognizer(target: weak, action: #selector(weak.handleTapAboutme(recognizer:)))
        aboutMeView.addGestureRecognizer(tapGestureAboutme)
        
    }
    
    func gettingData(){
    
    weak var weakSelf = self
    guard let weak = weakSelf else{return}
    
    UserManager().getUserInfo(header: header) {
    userinfo in
    
        guard let userinfo = userinfo else{return}
        print(userinfo.gender)
        print(userinfo.aboutMe)
        print(userinfo.birthdate)
        
        
        if let aboutMe = userinfo.aboutMe{
            weak.setAboutMeStepTextView.text = aboutMe
        }
        
        if  let gender = userinfo.gender, let aboutMe = userinfo.aboutMe, let birthdate = userinfo.birthdate,
            !gender.isEmpty,  !aboutMe.isEmpty,  !birthdate.isEmpty{
            weak.firstStepImageView.image = #imageLiteral(resourceName: "checkorange")
            
        }else{
            weak.firstStepImageView.image = #imageLiteral(resourceName: "checkgray")
        }
        
        let refresh_token = userinfo.refreshToken
        let access_token = userinfo.accessToken
        Singleton.shared.setrefreshToken(access_token, refresh_token)
        
        UserManager().getCards(header: weak.header) { (cards) in
            if let cards = cards, !cards.isEmpty,cards.count > 0{
                weak.secondStepView.image = #imageLiteral(resourceName: "checkorange")
            }
        }
    
    }
    
    
    }

    
    //Popup with TimePicker
    func showPopup(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let popup = AlertSetAboutMe(nibName: K.NIB.alertSetAboutMe, bundle: nil)
        DispatchQueue.main.async {
            // Create the dialog
            let popup = PopupDialog(viewController: popup, buttonAlignment: .horizontal, transitionStyle: .fadeIn, tapGestureDismissal: true)
            
            let buttonOne = CancelButton(title: "Cancelar", height: 60) {}
            
            let buttonTwo = DefaultButton(title: "Aceptar", height: 60) {
                let aboutMe = Singleton.shared.checkValueSet(key: K.defaultKeys.others.aboutMe)
                print(aboutMe)
                if !aboutMe.isEmpty{
                    let params: Parameters = ["about_me":aboutMe]
                    weak.updateInfo(params: params)
                }
            }
            
            popup.addButtons([buttonOne,buttonTwo])
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func showAboutMe(_ sender: UIButton) {
        showPopup()
    }
    
    
    //Update param
    func updateInfo(params: Parameters){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().updateUserInfo(header: header, params: params) {
            response in
            guard let updated = response else{return}
            if let aboutMe = updated.aboutMe, !aboutMe.isEmpty{
                weak.setAboutMeStepTextView.text = aboutMe
            }
            
            Core.shared.alert(message: "Los datos fuerón actualizados correctamente", title: "", at: weak)
            weak.gettingData()
            
        }
    }
    
    
    // MARK: - Objective C
    
    @objc func handleTapInfo(recognizer : UITapGestureRecognizer){
        performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToBasicInformation, sender: self)
    }
    
    @objc func handleTapCards(recognizer : UITapGestureRecognizer){
        performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToPaymentMethods, sender: self)
    }
    
    @objc func handleTapAboutme(recognizer : UITapGestureRecognizer){
        showPopup()
    }

}
