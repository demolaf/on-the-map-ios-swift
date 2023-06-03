//
//  LoginRequest.swift
//  On The Map
//
//  Created by Ademola Fadumo on 30/05/2023.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: UdacityLogin
}

struct UdacityLogin: Codable {
    let username: String
    let password: String
}
