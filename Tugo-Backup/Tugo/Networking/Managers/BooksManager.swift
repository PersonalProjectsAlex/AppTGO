//
//  BooksManager.swift
//  Tugo
//
//  Created by Alex on 25/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import Alamofire

class BooksManager: APIManager {
    /// Booking an experience.
    ///
    ///
    ///     - completionHandler: Callback to book an experience
    
    func testNewBooking(header: HTTPHeaders, params: Params,completionHandler handler: @escaping (BookResponse?) -> Void) {
        let userEndpoint = "\(Endpoints.Books.BookingTest)"
        request(endpoint: userEndpoint, completionHandler: handler, method: .post, params: params, headers:header)
    }
    
    /// Getting my bookings.
    ///
    ///
    ///     - completionHandler: Callback to get bookings
    
    func getBookings(header: HTTPHeaders,completionHandler handler: @escaping (Bookings?) -> Void) {
        let userEndpoint = "\(Endpoints.Books.Booking)"
        request(endpoint: userEndpoint, completionHandler: handler, method: .get, headers:header)
    }
    
    /// Getting my bookings.
    ///
    ///
    ///     - completionHandler: Callback to get bookings
    
    func getGeocode(params: Params,completionHandler handler: @escaping (GeocodeResponse?) -> Void) {
        let userEndpoint = "\(Endpoints.Geocode)"
        request(endpoint: userEndpoint, completionHandler: handler, method: .get, params: params)
    }
    
    
}
