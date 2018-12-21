//
//  Host.swift
//  Tugo
//
//  Created by Alex on 4/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

struct Host: Codable {
    let username, firstname, lastname, aboutMe: String
    let avatar, lat, long, birthdate: String
    let gender, email, accessToken, tokenType: String
    let expiresIn: Int
    let refreshToken, scope: String
    let createdAt: Int
    let country: String
    let host: HostClass
    
    enum CodingKeys: String, CodingKey {
        case username, firstname, lastname
        case aboutMe = "about_me"
        case avatar, lat, long, birthdate, gender, email
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
        case country, host
    }
}

struct HostClass: Codable {
    let id, email, encryptedPassword, username: String
    let firstname, lastname, aboutMe, accountID: String
    let avatar, lat, long, birthdate: String
    let gender, onesignalToken, resetPasswordToken, resetPasswordSentAt: String
    let rememberCreatedAt: String
    let signInCount: Int
    let currentSignInAt, lastSignInAt, currentSignInIP, lastSignInIP: String
    let createdAt, updatedAt, proofOfID, activationCode: String
    let status, country, approved, identificationNumber: String
    let bankAccount, approvedAt, passportURL, servicesDescription: String
    let note, bankName, userID: String
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case encryptedPassword = "encrypted_password"
        case username, firstname, lastname
        case aboutMe = "about_me"
        case accountID = "account_id"
        case avatar, lat, long, birthdate, gender
        case onesignalToken = "onesignal_token"
        case resetPasswordToken = "reset_password_token"
        case resetPasswordSentAt = "reset_password_sent_at"
        case rememberCreatedAt = "remember_created_at"
        case signInCount = "sign_in_count"
        case currentSignInAt = "current_sign_in_at"
        case lastSignInAt = "last_sign_in_at"
        case currentSignInIP = "current_sign_in_ip"
        case lastSignInIP = "last_sign_in_ip"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case proofOfID = "proof_of_id"
        case activationCode = "activation_code"
        case status, country, approved
        case identificationNumber = "identification_number"
        case bankAccount = "bank_account"
        case approvedAt = "approved_at"
        case passportURL = "passport_url"
        case servicesDescription = "services_description"
        case note
        case bankName = "bank_name"
        case userID = "user_id"
    }
}
