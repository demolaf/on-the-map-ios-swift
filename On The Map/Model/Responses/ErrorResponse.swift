//
//  ErrorResponse.swift
//  On The Map
//
//  Created by Ademola Fadumo on 01/06/2023.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
