//
//  Singleton.swift
//  Tugo
//
//  Created by Alex on 16/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

struct Global{
    let defaults = UserDefaults.standard
    let loginManager = LoginManager()
}

class Singleton {
    
    // MARK: - Let-Var
    static let shared = Singleton()
    private init() {}
    
    //------               Callers                     ----/
    
    // MARK: - Single singleton callers
    
    //Setting a way to keep the user logged
    func saveSignInState(){
        Global().defaults.set(K.defaultKeys.Auth.signIn, forKey:K.defaultKeys.Auth.signIn)
    }
    
    func saveSignInStateForHost(){
        Global().defaults.set(K.defaultKeys.Auth.Host.signInhost, forKey:K.defaultKeys.Auth.Host.signInhost)
    }
    
    func saveHostIncompleteStatus(_ isPendient: Bool) {
        Global().defaults.set(isPendient, forKey: K.defaultKeys.Auth.Host.incompleteState)
    }
    
    func savePedingCodeState(_ isIncomplete: Bool) {
        Global().defaults.set(isIncomplete, forKey: K.defaultKeys.Auth.Host.pendingState)
    }
    
    //Setting oonly avatar
    func updateAvatar(userPhoto: String?){
        Global().defaults.set(userPhoto, forKey: K.defaultKeys.User.userPhoto)
    }
    
    //Setting if sign by social network
    func socialSignIn(_ isSocial: Bool) {
        Global().defaults.set(isSocial, forKey: K.defaultKeys.others.isSocial)
    }
    
    func setTime(_ time:String){
        Global().defaults.set(time, forKey:K.defaultKeys.others.setTime)
    }
    
    func setDate(_ time:String){
        Global().defaults.set(time, forKey:K.defaultKeys.others.setDate)
    }
    
    func setStepProfile(isNew:Bool){
         Global().defaults.set(isNew, forKey:K.defaultKeys.others.isNew)
    }
    
    func setAboutMe(aboutMe:String){
        Global().defaults.set(aboutMe, forKey:K.defaultKeys.others.aboutMe)
    }
    
     // MARK: - Multiple singleton callers
    
    //Setting oauth refresh token
    func setrefreshToken(_ accessToken: String?, _ refreshToken: String?) {
        Global().defaults.set(accessToken, forKey:K.defaultKeys.Auth.Host.accessToken)
        Global().defaults.set(refreshToken, forKey:K.defaultKeys.Auth.Host.refreshToken)
    }
    
    //Setting oauth refresh token for hosts
    func setrefreshTokenHost(_ accessToken: String?, _ refreshToken: String?) {
        Global().defaults.set(accessToken, forKey:K.defaultKeys.Auth.accessToken)
        Global().defaults.set(refreshToken, forKey:K.defaultKeys.Auth.refreshToken)
    }
    
    //Setting info user keys
    func setCurrentUser(_ userName: String?, _ userPhoto: String?, _ userID: String?) {
        Global().defaults.set(userName, forKey: K.defaultKeys.User.userName)
        Global().defaults.set(userPhoto, forKey: K.defaultKeys.User.userPhoto)
        Global().defaults.set(userID, forKey: K.defaultKeys.User.userID)
    }
    
    //Setting tokens after auth
    func setOAuthToken(_ accessToken: String?, _ refreshToken: String?, _ expiresIn: Int?, _ scope: String?){
        Global().defaults.set(accessToken, forKey:K.defaultKeys.Auth.accessToken)
        Global().defaults.set(refreshToken, forKey:K.defaultKeys.Auth.refreshToken)
        Global().defaults.set(expiresIn, forKey:K.defaultKeys.Auth.expiresIn)
        Global().defaults.set(scope, forKey:K.defaultKeys.Auth.scope)
    }
    
    
    //Setting tokens for hosts
    func setOauthTokenHost(_ accessToken: String?, _ refreshToken: String?,  _ scope: String?){
    Global().defaults.set(accessToken, forKey:K.defaultKeys.Auth.Host.accessToken)
    Global().defaults.set(refreshToken, forKey:K.defaultKeys.Auth.Host.refreshToken)
    Global().defaults.set(scope, forKey:K.defaultKeys.Auth.scope)
    }
    
    
    //------               Functions                     ----/
    
    // MARK: - Multiple functions for Singleton
    
    //Get if isSocial
    func checkisBool(key: String) -> Bool {
        let isSocial = Global().defaults.object(forKey: key) as? Bool
        return isSocial == nil ? false : isSocial!
    }
    
    //Calling a key for a user
    func checkValueSet(key: String) -> String {
        let str = Global().defaults.object(forKey: key) as? String
        return str == nil ? "" : str!
    }
    
    func removeDefault(toRemove: String){
        Global().defaults.removeObject(forKey:toRemove)
    }
    
    //Deleting user settings
    func resetUser(){
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.accessToken)
        Global().defaults.removeObject( forKey:K.defaultKeys.Auth.refreshToken)
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.expiresIn)
        Global().defaults.removeObject( forKey:K.defaultKeys.Auth.scope)
        Global().defaults.removeObject(forKey: K.defaultKeys.User.userName)
        Global().defaults.removeObject(forKey: K.defaultKeys.User.userPhoto)
        Global().defaults.removeObject(forKey: K.defaultKeys.User.userID)
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.signIn)
        Global().defaults.removeObject(forKey:K.defaultKeys.others.isSocial)
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.Host.accessToken)
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.Host.signInhost)
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.Host.incompleteState)
        Global().defaults.removeObject(forKey:K.defaultKeys.Auth.Host.pendingState)
        Global().defaults.removeObject(forKey:K.defaultKeys.others.isNew)
        Global().defaults.removeObject(forKey:K.defaultKeys.others.isNew)
        
    }
    
    func facebookSignOut(){
        Global().loginManager.logOut()
    }
    
}
