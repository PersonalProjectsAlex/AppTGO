//
//  Counts.swift
//  Tugo
//
//  Created by Alex on 6/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

typealias Count = [CountElement]

struct CountElement: Codable {
    let country: String
    let countryCount: Int
    
    enum CodingKeys: String, CodingKey {
        case country
        case countryCount = "country_count"
    }
}
