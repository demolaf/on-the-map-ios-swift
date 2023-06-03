//
//  AddStudentLocationResponse.swift
//  On The Map
//
//  Created by Ademola Fadumo on 01/06/2023.
//

import Foundation

// MARK: - AddStudentLocationResponse
struct AddStudentLocationResponse: Codable {
    let objectID, createdAt: String

    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case createdAt
    }
}
