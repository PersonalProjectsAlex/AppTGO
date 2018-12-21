//
//  CategoriesAdded.swift
//  Tugo
//
//  Created by Alex on 14/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

typealias CategoriesAdded = [CategoriesAddedElement]

struct CategoriesAddedElement: Codable {
    let name, displayName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "display_name"
    }
}


