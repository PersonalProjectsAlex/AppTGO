//
//  SignInController.swift
//  Tugo
//
//  Created by Alex on 20/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//
import UIKit
import Alamofire
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import Google
import NVActivityIndicatorView
import SendBirdSDK
import FirebaseAuth

class SignInController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, NVActivityIndicatorViewable {
    
    
    // MARK: - Let-Var
    
        //--Facebook
        var facebookUser: FacebookUser?
        let loginManager = LoginManager()
        let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends,.userBirthday, .userGender]
    
    var singleUser = [SingleUser]()
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sessionButton: UIButton!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Singleton.shared.resetUser()

        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        try! FIRAuth.auth()!.signOut()
    }

    override func viewDidDisappear(_ animated: Bool) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.AuthStoryboard.signInToUserNameController {
            
            let detailController = segue.destination as! CompleteregistrationController
            detailController.selectedSingleUser = singleUser.first
            
        }
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        
    }
    
    private func gettingData(){}
    
    @IBAction func openSignUpControllerAction(_ sender: UIButton) {
        performSegue(withIdentifier: K.segues.AuthStoryboard.signInToSignUpCOntroller, sender: self)
    }
    
    
    @IBAction func signInOauthAction(_ sender: UIButton) {
        guard let email = usernameTextField.text else{
            return
        }
        guard let password = passwordTextField.text else{
            return
        }
        
        signInPassword(email, password)
    }
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        weak var weakSelf = self
        loginManager.logIn(readPermissions: readPermissions, viewController: self) {
            loginResult in
            
            guard case .success = loginResult else { print("Error")
                return }
            
            
            guard let accessToken = AccessToken.current else { return }
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            
            facebookAPIManager.requestFacebookUser {
                facebookUser in
                guard let weak = weakSelf else{return}
                weak.facebookUser = facebookUser
                if let userID = accessToken.userId{
                    guard let facebookFirstName = facebookUser.firstName else{return}
                    guard let facebookLastName = facebookUser.lastName else{return}
                    guard let facebookEmail = facebookUser.email else{return}
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                    
                    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error)  in
                        if let error = error{
                            print(error)
                        }
                      
                    })
                    
                    print("http://graph.facebook.com/\(userID)/picture?type=large")
                                        let photo = "http://graph.facebook.com/\(userID)/picture?type=large"
                    
                    weak.singleUser.append(SingleUser(userID: userID , fistName: facebookFirstName, lastName: facebookLastName, photo: photo, email: facebookEmail))
                    
                    weak.signInAccountID(userID,facebookEmail)
                }
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        weak var weakSelf = self
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let weak = weakSelf else{return}
        
        guard let userName = user.profile.name,
            let email = user.profile.email,
            let userID = user.userID
            else {return}
        
        let photo = user.profile.imageURL(withDimension: 400).absoluteString
        var items = userName.components(separatedBy: " ")
        //take one array for splitting the string
        let firstName = items[0]
        
        weak.singleUser.append(SingleUser(userID: userID , fistName: firstName, lastName: "", photo: photo, email: email))
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error)  in
            if let error = error{
                print(error)
            }
            
        })
        
        weak.signInAccountID(userID,email)
        
    }
    
    
    func signInPassword(_ email: String, _ password: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        customLoading()
        let params: Parameters = ["email":email, "password": password, "grant_type": "password", "scope": "users"]
       
        UserManager().getOauthToken(params: params) {
            response in
            
            guard let message = response?.message else{
                guard let accesToken = response?.accessToken, let refreshToken = response?.refreshToken, let expiresIn = response?.expiresIn, let scope = response?.scope else{
                    Core.shared.alert(message: "El usuario no pude ser creado o el username no puede ser utilizado", title: "Algo sucedio:", at: weak)
                    weak.stopAnimating()
                    return
                    
                }
                
                Singleton.shared.setOAuthToken(accesToken, refreshToken, expiresIn, scope)
                
                weak.gettingUserInfo(accesToken)
                weak.stopAnimating()
                
                return
            }
            
            Core.shared.alert(message: "El usuario no pude ser creado o el username no puede ser utilizado", title: "Algo sucedio:", at: weak)
            weak.stopAnimating()
        }
    }
    
    func signInAccountID(_ accountID: String, _ email: String){
        
        customLoading()
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let params: Parameters = ["account_id":accountID,
                                  "email": email,
                                  "grant_type": "password",
                                  "scope": "users"]
        
        UserManager().getOauthToken(params: params) {
            response in
            
            guard let message = response?.message else{
                guard let accesToken = response?.accessToken, let refreshToken = response?.refreshToken, let expiresIn = response?.expiresIn, let scope = response?.scope else{
                    
                    weak.performSegue(withIdentifier: K.segues.AuthStoryboard.signInToUserNameController, sender: self)
                    
                    return
                }
                
                Singleton.shared.setOAuthToken(accesToken, refreshToken, expiresIn, scope)
                Singleton.shared.socialSignIn(true)
                weak.gettingUserInfo(accesToken)
                self.stopAnimating()
                return
            }
            
            Core.shared.alert(message: "El usuario no pude ser creado o el username no puede ser utilizado", title: "Algo sucedio:", at: weak)
        }
    }
    
    func gettingUserInfo(_ token: String){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let header: HTTPHeaders = ["Authorization": Core.shared.setBearerToken(token)]
        UserManager().getUserInfo(header: header) {
        user in
            guard let userResponse = user else{ return}
           
            if  let host = userResponse.host {
                Singleton.shared.setCurrentUser(userResponse.username, userResponse.avatar, userResponse.firstname)
                weak.registerSendbird(nickname: userResponse.firstname, userID: userResponse.username, userPhoto: userResponse.avatar)
                Singleton.shared.saveSignInState()
                Singleton.shared.saveSignInStateForHost()
                
                weak.performSegue(withIdentifier: K.segues.AuthStoryboard.authToMenuHost, sender: nil)
                
            }else{
                Singleton.shared.setCurrentUser(userResponse.username, userResponse.avatar, userResponse.firstname)
                weak.registerSendbird(nickname: userResponse.firstname, userID: userResponse.username, userPhoto: userResponse.avatar)
                Singleton.shared.saveSignInState()
                weak.performSegue(withIdentifier: K.segues.AuthStoryboard.signInControllerToMenu, sender: nil)
            }
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





