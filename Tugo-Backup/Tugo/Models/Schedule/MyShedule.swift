//
//  MyShedule.swift
//  Tugo
//
//  Created by Alex on 19/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation


typealias MyShedules = [MyShedule]

struct MyShedule: Codable {
    let id, startTime, endTime: String?
    let maxReservations, confirmedReservations: Int?
    let experience: Experience?
    
    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case maxReservations = "max_reservations"
        case confirmedReservations = "confirmed_reservations"
        case experience
    }
}

struct Experience: Codable {
    let id, name, description, lat: String
    let long, country: String
    let priceInCents: Int
    let hostID: String
    let assets: [Asset]
    let reviews: [Review]
    let avgStars: Int
    let distanceTime, hostUsername: String
    let hostAvatar: String
    let incluye, duration, timeAgo, hostAboutMe: String
    let totalAvailableReservations: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, lat, long, country
        case priceInCents = "price_in_cents"
        case hostID = "host_id"
        case assets, reviews
        case avgStars = "avg_stars"
        case distanceTime = "distance_time"
        case hostUsername = "host_username"
        case hostAvatar = "host_avatar"
        case incluye, duration
        case timeAgo = "time_ago"
        case hostAboutMe = "host_about_me"
        case totalAvailableReservations = "total_available_reservations"
    }
}
