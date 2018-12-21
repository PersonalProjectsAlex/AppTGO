//
//  UserManager.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import Alamofire


class UserManager: APIManager {
    
    
    /// Oauth for users.
    ///
    ///
    ///     - completionHandler: Callback with Oauth/Token value
    
    func getOauthToken(params: Parameters,completionHandler handler: @escaping (Oauth?) -> Void) {
        let oauthEndpoint = "\(Endpoints.Users.OAUTH)"
        
        request(endpoint: oauthEndpoint, completionHandler: handler, method: .post, params: params)
    }
    
    /// Sign Up for users.
    ///
    ///
    ///     - completionHandler: Callback to sign up users
    
    func registerUser(params: Params,completionHandler handler: @escaping (Oauth?) -> Void) {
        let userEndpoint = "\(Endpoints.Users.USER)"
        request(endpoint: userEndpoint, completionHandler: handler, method: .post, params: params)
    }
    
    /// Get info about an user
    ///
    ///
    ///     - completionHandler: Callback to get info about an user
    func getUserInfo(header: HTTPHeaders,completionHandler handler: @escaping (UserInfo?) -> Void) {
        let meEndpoint = "\(Endpoints.Users.ME)"
        request(endpoint: meEndpoint, completionHandler: handler, method: .get, headers: header)
    }
    
    /// Update info about an user
    ///
    ///
    ///     - completionHandler: Callback to update info about an user
    func updateUserInfo(header: HTTPHeaders, params: Parameters,completionHandler handler: @escaping (UserUpdate?) -> Void) {
        let meEndpoint = "\(Endpoints.Users.ME)"
        request(endpoint: meEndpoint, completionHandler: handler, method: .put, params: params, headers: header)
    }
    
    /// Update password about an user
    ///
    ///
    ///     - completionHandler: Callback to update password about an user
    func changePassword(header: HTTPHeaders, params: Parameters,completionHandler handler: @escaping (UserUpdate?) -> Void) {
        let meEndpoint = "\(Endpoints.Users.CHANGEPASSWORD)"
        request(endpoint: meEndpoint, completionHandler: handler, method: .put, params: params, headers: header)
    }
    
    
    
    /*Actions for Cards*/
    
    /// Get cards for an user
    ///
    ///
    ///     - completionHandler: Callback to get user's card
    
    func getCards(header: HTTPHeaders,completionHandler handler: @escaping (Card?) -> Void) {
        let userEndpoint = "\(Endpoints.Users.CARDS)"
        
        request(endpoint: userEndpoint, completionHandler: handler, method: .get, headers: header)
    }
    
    /// Register a new card for an user.
    ///
    ///
    ///     - completionHandler: Callback to register a car
    
    func registerNewCard(header: HTTPHeaders,params: Parameters,completionHandler handler: @escaping (CardElement?) -> Void) {
        let userEndpoint = "\(Endpoints.Users.CARDS)"
        request(endpoint: userEndpoint, completionHandler: handler, method: .post, params: params, headers:header)
    }
    
    /// Register a new card for an user.
    ///
    ///
    ///     - completionHandler: Callback to register a car
    
    func deleteCard(header: HTTPHeaders,card: String,completionHandler handler: @escaping (DeleteCard?) -> Void) {
        let userEndpoint = "\(Endpoints.Users.CARDS)\("/"+card)"
        
        request(endpoint: userEndpoint, completionHandler: handler, method: .delete, headers:header)
    }
    
    
    
    
}
