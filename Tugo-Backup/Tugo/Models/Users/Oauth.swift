//
//  Oauth.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

struct Oauth: Codable {
    let message: String?
    let error: String?
    let code: Int?
    let accessToken, tokenType: String?
    let expiresIn: Int?
    let refreshToken, scope: String?
    let createdAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case message, error, code
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
    }
}

