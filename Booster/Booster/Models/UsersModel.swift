//
//  Users.swift
//  Booster
//
//  Created by Fy Spoti on 30/10/2023.
//

import Foundation

struct UserModel {
    var email: String?
    var name: String?
    var password: String?
}

struct UserSession {
    let email: String
    let name: String

    init( email: String, name: String) {
        self.email = email
        self.name = name
    }
}
