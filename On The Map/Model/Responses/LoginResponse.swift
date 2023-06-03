//
//  LoginResponse.swift
//  On The Map
//
//  Created by Ademola Fadumo on 30/05/2023.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}
