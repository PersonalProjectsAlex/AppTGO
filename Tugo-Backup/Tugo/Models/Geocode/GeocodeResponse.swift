//
//  GeocodeResponse.swift
//  Tugo
//
//  Created by Alex on 27/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//


import Foundation

struct GeocodeResponse: Codable {
    let plusCode: PlusCode
    let results: [Result]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

struct PlusCode: Codable {
    let compoundCode, globalCode: String
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

struct Result: Codable {
    let addressComponents: [AddressComponent]
    let formattedAddress: String
    let geometry: Geometry
    let placeID: String
    let plusCode: PlusCode?
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case plusCode = "plus_code"
        case types
    }
}

struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [TypeElement]?
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

enum TypeElement: String, Codable {
    case administrativeAreaLevel1 = "administrative_area_level_1"
    case administrativeAreaLevel2 = "administrative_area_level_2"
    case country = "country"
    case locality = "locality"
    case neighborhood = "neighborhood"
    case political = "political"
    case route = "route"
}

struct Geometry: Codable {
    let location: Location
    let locationType: String
    let viewport: Bounds
    let bounds: Bounds?
    
    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport, bounds
    }
}

struct Bounds: Codable {
    let northeast, southwest: Location
}

struct Location: Codable {
    let lat, lng: Double
}
