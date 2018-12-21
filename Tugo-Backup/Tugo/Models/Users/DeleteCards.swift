//
//  DeleteCards.swift
//  Tugo
//
//  Created by Alex on 12/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

struct DeleteCard: Codable {
    let id, userID, stripeSource: String
    let isDefault: Bool?
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case stripeSource = "stripe_source"
        case isDefault = "is_default"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
