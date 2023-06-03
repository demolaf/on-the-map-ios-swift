//
//  StudentLocationResultResponse.swift
//  On The Map
//
//  Created by Ademola Fadumo on 01/06/2023.
//

import Foundation

struct StudentLocationResultResponse: Codable {
    let results: [StudentLocation]
}

// MARK: - StudentLocation
struct StudentLocation: Codable {
    let firstName, lastName: String
    let longitude, latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey, objectID, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, longitude, latitude, mapString, mediaURL, uniqueKey
        case objectID = "objectId"
        case createdAt, updatedAt
    }
}
