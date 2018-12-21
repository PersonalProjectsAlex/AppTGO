//
//  ProfileController.swift
//  Tugo
//
//  Created by Alex on 29/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SwiftMessages
import SDWebImage
import Alamofire
import NVActivityIndicatorView
import Firebase
import HexColors
import PopupDialog


class ProfileController: UIViewController,NVActivityIndicatorViewable{

    // MARK: - Let-Var
    public var titles = String()
    let picker = UIImagePickerController()
    var isContrained = false
    let codePendient = Singleton.shared.checkisBool(key: K.defaultKeys.Auth.Host.pendingState)
    
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    var avatar:String?
    var isIncomplete = true
    let isNew = Singleton.shared.checkisBool(key: K.defaultKeys.others.isNew)
    let instanceHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.signInhost)
    
    // MARK: - Outlets
    
        //--Complete profile outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var messagepresenterView: UIView!
    @IBOutlet weak var changeNameTextfield: UITextField!
    @IBOutlet weak var setNameButton: UIButton!
    @IBOutlet weak var setAboutMeButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var newProfileView: UIView!
    @IBOutlet weak var myProfileTitleLabel: UILabel!
    @IBOutlet weak var aboutLabelTitle: UILabel!
    @IBOutlet weak var aboutMeView: UIView!
    
     
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.allowsEditing = true
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
  
        selectImageView.backgroundColor = !instanceHost.isEmpty ? #colorLiteral(red: 0.565512538, green: 0.3330982924, blue: 0.98246032, alpha: 1) : .orange
        changeNameTextfield.textColor = !instanceHost.isEmpty ? #colorLiteral(red: 0.565512538, green: 0.3330982924, blue: 0.98246032, alpha: 1) : .orange
        myProfileTitleLabel.textColor = !instanceHost.isEmpty ? .gray : .orange
        aboutLabelTitle.text = !instanceHost.isEmpty ? "Sobre mi como anfitrión" : "Sobre mi"
       
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.instanceHost.isEmpty {
                self.settingMessageAtbottom()
            }
            
            if !weak.isNew{
               //weak.newProfileView.isHidden = true
            }
        }
        
        gettingData()
        settingUser()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftMessages.hide()
    }
   
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        //Delegating tap on imageview
        selectImageView.isUserInteractionEnabled = true
        
        let tapGestureSelectImage = UITapGestureRecognizer(target: weak, action: #selector(weak.handleTapFrom(recognizer:)))
        selectImageView.addGestureRecognizer(tapGestureSelectImage)
        
        let tapGestureAboutme = UITapGestureRecognizer(target: weak, action: #selector(weak.handleTapAboutme(recognizer:)))
        aboutMeView.addGestureRecognizer(tapGestureAboutme)
        
        
        
    }
    
    func settingUser(){
        //Setting profile info
       
    }
    
    
    func gettingData(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        DispatchQueue.main.async {
            weak.newProfileView.isHidden = true
        }
        
        customLoading()
        
        UserManager().getUserInfo(header: header) {
            userinfo in
            guard let userinfo = userinfo else{
                weak.stopAnimating()
                return
            }
            weak.stopAnimating()
            weak.changeNameTextfield.text  = userinfo.firstname
            if let aboutMe = userinfo.aboutMe{
                weak.aboutMeTextView.text = aboutMe
            }
            
            if  let gender = userinfo.gender, let aboutMe = userinfo.aboutMe, let birthdate = userinfo.birthdate,
                !gender.isEmpty,  !aboutMe.isEmpty,  !birthdate.isEmpty{
                DispatchQueue.main.async {
                    weak.newProfileView.isHidden = true
                }
                
            }else{
                weak.newProfileView.isHidden = false
            }
            
            weak.usernameTextfield.text = ("@\(userinfo.username)")
            weak.profileImageView.sd_setImage(with: URL(string: userinfo.avatar), placeholderImage: #imageLiteral(resourceName: "tugologo"))
            
            let refresh_token = userinfo.refreshToken
            let access_token = userinfo.accessToken
            Singleton.shared.setrefreshToken(access_token, refresh_token)
            
            
        }
        
        
    }
    
   
    //Update avatar
    
    func updateInfo(params: Parameters){
        
        customLoading()
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
       
        UserManager().updateUserInfo(header: header, params: params) {
            response in
            guard let updated = response else{return}
            Core.shared.alert(message: "Los datos fuerón actualizados correctamente", title: "", at: weak)
            guard let photo = updated.avatar else{return}
            Singleton.shared.updateAvatar(userPhoto: photo)
            
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = MainTabBarHostController()
            }
            
            
            weak.gettingData()
            self.stopAnimating()
        }
    }
    
    func updateData(params: Parameters){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().updateUserInfo(header: header, params: params) {
            response in
            guard let updated = response else{return}
            if let aboutMe = updated.aboutMe, !aboutMe.isEmpty{
                weak.aboutMeTextView.text = aboutMe
            }
            
            Core.shared.alert(message: "Los datos fuerón actualizados correctamente", title: "", at: weak)
            weak.gettingData()
            
        }
    }
    
    
    
    @IBAction func showOptionsAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            SwiftMessages.hide()
            
            weak var weakSelf = self
            guard let weak = weakSelf else{return}
            let isSocial = Singleton.shared.checkisBool(key: K.defaultKeys.others.isSocial)
            let title = !weak.instanceHost.isEmpty ? "Opciones viajero" : "Opciones"
            let actionSheetController = Core.shared.createActionsheet(title: title, message: "")
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in}
            cancelAction.setValue( #colorLiteral(red: 0.3529411765, green: 0.3529411765, blue: 0.3529411765, alpha: 1), forKey: "titleTextColor")
            actionSheetController.addAction(cancelAction)
            
            //Create and add first option action
            let firstItem: UIAlertAction = UIAlertAction(title: K.titles.ProfileActionSheet.firstItem, style: .default) { action -> Void in
                weak.performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToBasicInformation, sender: self)
            }
//             firstItem.setValue(messageAttrString, forKey: "attributedTitle")
            firstItem.setValue( #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1), forKey: "titleTextColor")
            actionSheetController.addAction(firstItem)
            
            //Create and add a second option action
            
            let titlePayment = !weak.instanceHost.isEmpty ? "Preferencia de cobro / pago" : K.titles.ProfileActionSheet.secondItem
            let secondItem: UIAlertAction = UIAlertAction(title: titlePayment, style: .default) { action -> Void in
                if !weak.instanceHost.isEmpty{
                    weak.performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToPaymentsHost, sender: self)
                    
                }else{
                     weak.performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToPaymentMethods, sender: self)
                }
               
            }
            secondItem.setValue( #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1), forKey: "titleTextColor")
            actionSheetController.addAction(secondItem)
            
            //Create and add a third option action
            
            
            let thirdItem: UIAlertAction = UIAlertAction(title: K.titles.ProfileActionSheet.thirdItem, style: .default) { action -> Void in
                
                weak.performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToFavourites, sender: self)
            }
            thirdItem.setValue( #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1), forKey: "titleTextColor")
            actionSheetController.addAction(thirdItem)
            
            //Create and add a forth option action
            if !isSocial{
                let forthItem: UIAlertAction = UIAlertAction(title: K.titles.ProfileActionSheet.forthItem, style: .default) { action -> Void in
                    weak.performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToChangepassword, sender: self)
                }
                actionSheetController.addAction(forthItem)
            }
            //Create and add a third option action
            let fifthItem: UIAlertAction = UIAlertAction(title: K.titles.ProfileActionSheet.fifthItem, style: .destructive) { action -> Void in
                Singleton.shared.resetUser()
                self.performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToSignInController, sender: nil)
            }
            fifthItem.setValue( #colorLiteral(red: 0.7450980392, green: 0.7333333333, blue: 0.7725490196, alpha: 1), forKey: "titleTextColor")
            actionSheetController.addAction(fifthItem)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    

    
    @IBAction func changeAboutMeProfile(_ sender: UIButton) {
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        showPopup()
    }

    
    //Showing a message at the bottom
    func settingMessageAtbottom(){
        //Setting message at bottom
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        if !codePendient{
            Core.shared.customAlertNavbarProfile(image: #imageLiteral(resourceName: "becomehostalert"), at: messagepresenterView).addGestureRecognizer(recognizer)
        }else{
            Core.shared.customAlertNavbarProfile(image: #imageLiteral(resourceName: "codependientalert"), at: messagepresenterView).addGestureRecognizer(recognizer)
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
                    weak.updateData(params: params)
                }
            }
            
            popup.addButtons([buttonOne,buttonTwo])
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    //Custom loading
    func customLoading(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let size = CGSize(width: 30, height: 30)
        weak.startAnimating(size, message: "", type: NVActivityIndicatorType.ballScaleMultiple)
    }
    
    
    
    // MARK: - Objective C
    @objc func didTap() {
        if !codePendient{
            performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileControllerToAuthHost, sender: self)
        }else{
            performSegue(withIdentifier: K.segues.ProfileStoryBoard.profileToCodePendient, sender: self)
        }
    }

    @objc func handleTapFrom(recognizer : UITapGestureRecognizer){
        // if the tapped view is a UIImageView then set it to imageview
       
        showInputDialog()
    }
    
    
    @objc func handleTapAboutme(recognizer : UITapGestureRecognizer){
        // if the tapped view is a UIImageView then set it to imageview
        showPopup()
    }
   
    
}
