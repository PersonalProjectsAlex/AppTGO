//
//  Endpoints.swift
//  Tugo
//
//  Created by Alex on 16/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

struct Endpoints {
    
    static let BASE_URL_ENV = "https://tugo-v2-stg.herokuapp.com/"
    
    
    //Base path for user's endpoint
    static let BASE_USER = "\(BASE_URL_ENV)user/v1/"
    static let BASE_HOST = "\(BASE_URL_ENV)user_host/v1/"
    
    static let Geocode = "https://maps.googleapis.com/maps/api/geocode/json"
    struct Users {
    
        //User's enpoint
        static let OAUTH = "\(BASE_USER)oauth/token"
        static let USER = "\(BASE_USER)users"
        static let ME = "\(BASE_USER)users/me"
        static let CHANGEPASSWORD = "\(BASE_USER)users/change_password"
        
        //Payments
        static let CARDS = "\(BASE_USER)users/cards"
        
    }
    
    struct Experiences {
        //Experiences
        static let EXPERIENCES = "\(BASE_USER)experiences"
        static let EXPERIENCESFILTER = "\(BASE_USER)experiences/filter"
        static let COUNT = "\(BASE_USER)experiences/count"
        static let SEARCH = "\(BASE_USER)experiences/search"
    }
    
    struct Categories {
        //Categories
        static let SETCATEGORIES = "\(BASE_USER)categories"
        static let CATEGORIES = "\(BASE_USER)categories/last_experience"
        static let CATEGORIESME = "\(BASE_USER)categories/my_categories"
        
        
    }
    
    struct Books{
        static let BookingTest = "\(BASE_USER)reservations/reservations_test"
        static let Booking = "\(BASE_USER)reservations"
    }
    
    
    
    //--Host
    
    struct Host {
        static let OAUTH = "\(BASE_HOST)oauth/token"
        static let HOST = "\(BASE_HOST)hosts"
        static let ME = "\(BASE_HOST)hosts/me"
        static let ACTIVATE = "\(BASE_HOST)hosts/activate"
        
        
    }
    
    struct ExperiencesHost {
        //Experiences
        static let EXPERIENCES = "\(BASE_HOST)experiences"
        static let EXPERIENCEEDIT = "\(BASE_HOST)experiences/edit"
        static let SCHEDULES =  "\(BASE_HOST)schedules"
        static let SCHEDULESBYEXPERIENCE =  "\(BASE_HOST)experiences/schedules"
        
        static let DELETESCHEDULES =  "\(BASE_HOST)/schedules"
        static let CATEGORIESBYEXPERIENCE =  "\(BASE_HOST)experiences/categories"
        static let ASSETS = "\(BASE_HOST)assets"
        
    }
    
    
}
