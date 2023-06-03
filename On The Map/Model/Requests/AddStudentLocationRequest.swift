//
//  AddStudentLocationRequest.swift
//  On The Map
//
//  Created by Ademola Fadumo on 01/06/2023.
//

import Foundation

// MARK: - AddStudentLocationRequest
struct AddStudentLocationRequest: Codable {
    let uniqueKey, firstName, lastName, mapString: String
    let mediaURL: String
    let latitude, longitude: Double
}
