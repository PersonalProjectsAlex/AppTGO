//
//  HostManager.swift
//  Tugo
//
//  Created by Alex on 3/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import Alamofire

class HostManager: APIManager {
    /// Oauth for Hosts.
    ///
    ///
    ///     - completionHandler: Callback with Oauth/Token value
    
    func getOauthToken(params: Parameters,completionHandler handler: @escaping (Oauth?) -> Void) {
        let oauthEndpoint = "\(Endpoints.Host.OAUTH)"
        
        request(endpoint: oauthEndpoint, completionHandler: handler, method: .post, params: params)
    }
    
    
    /// Sign Up for hosts.
    ///
    ///
    ///     - completionHandler: Callback to sign up hosts
    
    func registerHost(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (Host?) -> Void) {
        let hostEndpoint = "\(Endpoints.Host.HOST)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .post, params: params, headers: header)
    }
    
    /// Get info about a host
    ///
    ///
    ///     - completionHandler: Callback to get info about an host
    func getUserInfo(header: HTTPHeaders,completionHandler handler: @escaping (UserInfo?) -> Void) {
        let meEndpoint = "\(Endpoints.Host.ME)"
        request(endpoint: meEndpoint, completionHandler: handler, method: .get, headers: header)
    }
    
    
    // Update info about an host
    ///
    ///
    ///     - completionHandler: Callback to update info about an host
    func updateHost(header: HTTPHeaders, params: Parameters,completionHandler handler: @escaping (Host?) -> Void) {
        let meEndpoint = "\(Endpoints.Host.ME)"
        request(endpoint: meEndpoint, completionHandler: handler, method: .put, params: params, headers: header)
    }
    
    
    /// Validate a code
    ///
    ///
    ///     - completionHandler: Callback to validate codes
    
    func activateAccount(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (Host?) -> Void) {
        let hostEndpoint = "\(Endpoints.Host.ACTIVATE)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .put, params: params, headers: header)
    }
 
    
    // Get info about a schedule
    ///
    ///
    ///     - completionHandler: Callback to get info about a schedule
    func getSchedule(header: HTTPHeaders, params: Parameters,completionHandler handler: @escaping (MyShedules?) -> Void) {
        let meEndpoint = "\(Endpoints.ExperiencesHost.SCHEDULES)"
        request(endpoint: meEndpoint, completionHandler: handler, method: .get, params: params, headers: header)
    }
    
    
}
