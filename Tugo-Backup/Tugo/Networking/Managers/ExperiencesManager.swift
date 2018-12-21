//
//  ExperiencesManager.swift
//  Tugo
//
//  Created by Alex on 6/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import Alamofire
class ExperiencesManager: APIManager {
    /// Get count experiences.
    ///
    ///
    ///     - completionHandler: Callback to get the count of experiences per country
    
    func getCountExperiences(header:HTTPHeaders,completionHandler handler: @escaping (Count?) -> Void) {
        let countEndpoint = "\(Endpoints.Experiences.COUNT)"
        request(endpoint: countEndpoint, completionHandler: handler, method: .get, headers: header)
    }

    /// Get experiences per favouritea.
    ///
    ///
    ///     - completionHandler: Callback to get experiences per favourites
    func getExperiences(header:HTTPHeaders,params: Parameters,completionHandler handler: @escaping (Search?) -> Void) {
        let countEndpoint = "\(Endpoints.Experiences.EXPERIENCES)"
        request(endpoint: countEndpoint, completionHandler: handler, method: .get, params: params, headers: header)
    }
    
    
    /// Search experiences per term.
    ///
    ///
    ///     - completionHandler: Callback to get experiences by searching
    func getExperienceSearch(header:HTTPHeaders,params: Parameters,completionHandler handler: @escaping (Search?) -> Void) {
        let countEndpoint = "\(Endpoints.Experiences.SEARCH)"
        request(endpoint: countEndpoint, completionHandler: handler, method: .get, params: params, headers: header)
    }
    
    /// Get experiences per categories.
    ///
    ///
    ///     - completionHandler: Callback to get experiences per categories
    func getExperiencesPercategories(header:HTTPHeaders,params: Parameters,completionHandler handler: @escaping (Search?) -> Void) {
        let experienceEndpoint = "\(Endpoints.Experiences.EXPERIENCESFILTER)"
        request(endpoint: experienceEndpoint, completionHandler: handler, method: .get, params: params, headers: header)
    }
    
    //--
    //--Hosts Experiences
    
    /// Sign Up for hosts.
    ///
    ///
    ///     - completionHandler: Callback to sign up hosts
    
    func newExperience(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (NewExperienceResponse?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.EXPERIENCES)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .post, params: params, headers: header)
    }
    
    func getExperienceHost(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (NewExperiencearray?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.EXPERIENCES)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .get, params: params, headers: header, encoding: JSONEncoding.default)
    }
    
    func setSchedules(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (ScheduleResponse?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.SCHEDULESBYEXPERIENCE)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .post, params: params, headers: header)
    }
    
    func deleteSchedule(header: HTTPHeaders,id: String,completionHandler handler: @escaping (ScheduleResponse?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.DELETESCHEDULES)/\(id)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .delete, headers: header)
    }
    
    func setAssets(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (AsssetAdded?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.ASSETS)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .post, params: params, headers: header)
    }
    
   
    
    func deleteAsset(header: HTTPHeaders,assetId:String,completionHandler handler: @escaping (AsssetAdded?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.ASSETS)/\(assetId)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .delete, headers: header)
    }
    
    func editExperience(header: HTTPHeaders,params: Params,completionHandler handler: @escaping (NewExperienceResponse?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.EXPERIENCEEDIT)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .put, params: params, headers: header)
    }
    
    func deleteExperience(id: String, header: HTTPHeaders,completionHandler handler: @escaping (NewExperienceResponse?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.EXPERIENCES)/\(id)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .delete, headers: header)
    }
    
    func getExperienceById(id: String, header: HTTPHeaders,completionHandler handler: @escaping (NewExperienceResponse?) -> Void) {
        let hostEndpoint = "\(Endpoints.ExperiencesHost.EXPERIENCES)/\(id)"
        request(endpoint: hostEndpoint, completionHandler: handler, method: .get, headers: header)
    }
    
}
