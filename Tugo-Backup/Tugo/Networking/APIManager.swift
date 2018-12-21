//
//  APIManager.swift
//  travi
//
//  Created by Administrador on 29/03/18.
//


import Foundation
import Alamofire
import CodableAlamofire

typealias Params = [String: Any]?

class APIManager {
    
    func request<T: Codable>(endpoint: String, completionHandler: @escaping (T?) -> Void, method: HTTPMethod = .post, params: Parameters? = nil , headers: HTTPHeaders? = nil, keyPath: String? = nil, encoding: JSONEncoding? = nil) {
        
        let url = URL(string: endpoint)!
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        print("Endpoint: \(endpoint), \(method)")
        print("Params: \(params as? NSDictionary)")
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 15
        
        
        Alamofire.request(url, method: method, parameters: params, headers: headers)
            .responseDecodableObject(queue: utilityQueue, keyPath: keyPath, decoder: decoder) { (response: DataResponse<T>) in
                
                //print(response)
                response.result.ifFailure { print("ERROR: \(response.result.error.debugDescription)") }
                DispatchQueue.main.sync {
                    if let object = response.value { completionHandler(object) }
                    else { completionHandler(nil) }
                }
        }
        
    }
    
}


struct JSONStringArrayEncoding: ParameterEncoding {
    private let myString: String
    
    init(string: String) {
        self.myString = string
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let data = myString.data(using: .utf8)!
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
        
        return urlRequest!
    }}
