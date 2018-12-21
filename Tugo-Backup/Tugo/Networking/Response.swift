import Foundation

/// Response
struct Response<T: Codable>: Codable {
    let result: T?
    
}

struct Empty: Codable {}

