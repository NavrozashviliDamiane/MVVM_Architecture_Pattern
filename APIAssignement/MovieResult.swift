// MovieResult.swift

import Foundation

struct MovieResult: Codable {
    var search: [Movie]
    var totalResults: String
    var response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

