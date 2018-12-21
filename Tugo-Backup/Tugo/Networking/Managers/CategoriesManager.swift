//
//  CategoriesManager.swift
//  Tugo
//
//  Created by Alex on 14/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import Alamofire
class CategoriesManager: APIManager {
    /// Get categories.
    ///
    ///
    ///     - completionHandler: Callback to get the categories
    
    func getCategories(header:HTTPHeaders,completionHandler handler: @escaping (Categories?) -> Void) {
        let categoriesEndpoint = "\(Endpoints.Categories.CATEGORIES)"
        request(endpoint: categoriesEndpoint, completionHandler: handler, method: .get, headers: header)
    }
    
    /// Get categories.
    ///
    ///
    ///     - completionHandler: Callback to get the categories
    
    func getCategoriesMe(header:HTTPHeaders,completionHandler handler: @escaping (MyFavourites?) -> Void) {
        let categoriesEndpoint = "\(Endpoints.Categories.CATEGORIESME)"
        request(endpoint: categoriesEndpoint, completionHandler: handler, method: .get, headers: header)
    }
    
    /// Set a new like for users.
    ///
    ///
    ///     - completionHandler: Callback to set new experience liked by user
    
    func setNewCategories(header:HTTPHeaders, params: Parameters,completionHandler handler: @escaping (CategoriesAdded?) -> Void) {
        let categoriesEndpoint = "\(Endpoints.Categories.SETCATEGORIES)"
        request(endpoint: categoriesEndpoint, completionHandler: handler, method: .post,  params: params, headers: header)
    }
    
    /// Set a category  for experiences.
    ///
    ///
    ///     - completionHandler: Callback to set a category  for experiences
    
    func setCategorieByExperience(header:HTTPHeaders, params: Parameters,completionHandler handler: @escaping (CategoriesAdded?) -> Void) {
        let categoriesEndpoint = "\(Endpoints.ExperiencesHost.CATEGORIESBYEXPERIENCE)"
        request(endpoint: categoriesEndpoint, completionHandler: handler, method: .post,  params: params, headers: header)
    }
    
}
