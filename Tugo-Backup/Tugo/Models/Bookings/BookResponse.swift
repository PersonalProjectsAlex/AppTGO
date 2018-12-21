//
//  BookResponse.swift
//  Tugo
//
//  Created by Alex on 26/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
typealias Bookings = [Reservation]

struct BookResponse: Codable {
    let id: String
    let tickets: Int
    let startTime, endTime, experienceName, bookResponseIn: String
    let lat, long, host, user: String
    let experienceCountry: String
    let experienceAssets: [ExperienceAsset]
    
    enum CodingKeys: String, CodingKey {
        case id, tickets
        case startTime = "start_time"
        case endTime = "end_time"
        case experienceName = "experience_name"
        case bookResponseIn = "in"
        case lat, long, host, user
        case experienceCountry = "experience_country"
        case experienceAssets = "experience_assets"
        
    }
}

struct Reservation: Codable {
    let id: String
    let tickets: Int
    let startTime, endTime, experienceName, reservationIn: String
    let total_paid: String?
    let lat, long, host, hostname, user: String
    let experienceCountry: String
    let experienceAssets: [ExperienceAsset]
    
    enum CodingKeys: String, CodingKey {
        case id, tickets
        case startTime = "start_time"
        case endTime = "end_time"
        case experienceName = "experience_name"
        case total_paid = "total_paid"
        case reservationIn = "in"
        case lat, long, host, hostname, user
        case experienceCountry = "experience_country"
        case experienceAssets = "experience_assets"
    }
}




struct ExperienceAsset: Codable {
    let id: String
    let url: String
    let experienceID, createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case experienceID = "experience_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



