//
//  ExperienceModel.swift
//  Tugo
//
//  Created by Alex on 8/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

struct ExperienceHostModel {
    var name: String?
    var description: String?
    var include: String?
    
}

struct ExperienceHostInfo {
    let experience: ExperienceHostModel?
    var lat: Double?
    var long: Double?
    var country: String?
    
}

struct ExperienceHostcompleted{
    var price: String?
}

struct schedule {
    var scheduleHours = [String]()
    var endTime: String?
    var MaxReservations: Int?
    
}



