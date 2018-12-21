//
//  ExperienceResponse.swift
//  Tugo
//
//  Created by Alex on 6/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
typealias NewExperiencearray = [NewExperienceResponse]

struct NewExperienceResponse: Codable {
    let id, name, description, lat: String?
    let long, country: String?
    let priceInCents: Int?
    let hostID: String?
    let assets: [Asset]?
    let reviews: [Review]?
    let schedules: [ScheduleUpdated]?
    let avgStars: Int?
    let distanceTime, hostUsername: String?
    let hostAvatar: String?
    let incluye, duration, timeAgo, hostAboutMe: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, lat, long, country
        case priceInCents = "price_in_cents"
        case hostID = "host_id"
        case assets, reviews, schedules
        case avgStars = "avg_stars"
        case distanceTime = "distance_time"
        case hostUsername = "host_username"
        case hostAvatar = "host_avatar"
        case incluye, duration
        case timeAgo = "time_ago"
        case hostAboutMe = "host_about_me"
    }
}



struct ExperienceUpdated: Codable {
    let id, name, description, lat: String?
    let long, country: String?
    let priceInCents: Int?
    let hostID: String?
    let assets: [Asset]
    let reviews: [Review]?
    let schedules: [ScheduleUpdated]
    let avgStars: Int?
    let distanceTime, hostUsername: String?
    let hostAvatar: String?
    let incluye, duration, timeAgo, hostAboutMe: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, lat, long, country
        case priceInCents = "price_in_cents"
        case hostID = "host_id"
        case assets, reviews
        case schedules = "schedules"
        case avgStars = "avg_stars"
        case distanceTime = "distance_time"
        case hostUsername = "host_username"
        case hostAvatar = "host_avatar"
        case incluye, duration
        case timeAgo = "time_ago"
        case hostAboutMe = "host_about_me"
    }
}


struct ScheduleUpdated: Codable {
    let id, experienceID, startTime, endTime: String?
    let availableReservations, maxReservations: Int?
    let createdAt, updatedAt: String?
    let paid: Bool?
    let paidOn, totalHost, totalTugo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case experienceID = "experience_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case availableReservations = "available_reservations"
        case maxReservations = "max_reservations"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case paid
        case paidOn = "paid_on"
        case totalHost = "total_host"
        case totalTugo = "total_tugo"
    }
}
