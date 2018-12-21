//
//  Cards.swift
//  Tugo
//
//  Created by Alex on 7/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

typealias Card = [CardElement]

struct CardElement: Codable {
    let id, stripeSource: String
    let isDefault: Bool?
    let friendlyCard: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case stripeSource = "stripe_source"
        case isDefault = "is_default"
        case friendlyCard = "friendly_card"
    }
}
