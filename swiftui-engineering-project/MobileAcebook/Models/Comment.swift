//
//  Comment.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//


import Foundation

public struct Comment: Codable, Identifiable {
    public let id: String
    let message: String
    let createdBy: PublicUser
    let createdAt: String
    
    // Add a custom decoding initializer
    private enum CodingKeys: String, CodingKey {
        case id = "_id"  // Maps the `_id` field from the API to `id`
        case message
        case createdBy
        case createdAt
    }
}

public struct CommentResponse: Codable {
    var comments: [Comment]
}
