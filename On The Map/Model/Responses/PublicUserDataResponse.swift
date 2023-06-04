//
//  PublicUserDataResponse.swift
//  On The Map
//
//  Created by Ademola Fadumo on 04/06/2023.
//

import Foundation

struct PublicUserDataResponse: Codable {
    let key, firstName, lastName: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
