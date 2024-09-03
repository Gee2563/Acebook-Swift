//
//  Comment.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//


import Foundation

public struct Comment: Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
