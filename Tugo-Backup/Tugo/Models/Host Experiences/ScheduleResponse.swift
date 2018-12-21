//
//  SchduleResponse.swift
//  Tugo
//
//  Created by Alex on 8/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
struct ScheduleResponse: Codable {
    let id, startTime, endTime: String?
    let maxReservations, confirmedReservations: Int?
    let experience: NewExperienceResponse?
    let name: String?
    let founded: Int?
    let members: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case maxReservations = "max_reservations"
        case confirmedReservations = "confirmed_reservations"
        case experience, name, founded, members
    }
}

struct AsssetAdded: Codable {
    let url: String
}
