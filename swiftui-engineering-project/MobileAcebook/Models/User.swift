//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

public struct User {
    let username: String
    let password: String
}

public struct PublicUser: Codable {
    let _id: String
    let username: String
    let profilePicture: String?
}
