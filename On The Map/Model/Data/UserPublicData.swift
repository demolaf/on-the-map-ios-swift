//
//  UserPublicData.swift
//  On The Map
//
//  Created by Ademola Fadumo on 04/06/2023.
//

import Foundation

class UserPublicData {
    static var userPublicData: PublicUserDataResponse!
    
    class func getUserFullName() -> String {
        return UserPublicData.userPublicData.firstName + " " + UserPublicData.userPublicData.lastName
    }
}
