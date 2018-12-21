//
//  Categories.swift
//  Tugo
//
//  Created by Alex on 14/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

typealias Categories = [Category]

struct Category: Codable {
    let name, id: String
    let assetLastExperience: String
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case assetLastExperience = "asset_last_experience"
    }
}


typealias MyFavourites = [MyFavourite]

struct MyFavourite: Codable {
    let id, name, displayName: String
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case isLiked = "is_liked"
    }
}
