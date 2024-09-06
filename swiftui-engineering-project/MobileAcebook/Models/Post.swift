//
//  Post.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//

import Foundation

public struct Post: Identifiable, Codable{
    public let id: String
    let userId: PublicUser
    let content: String
    let comments: [Comment]?
    let likes: [String]?
    let createdAt: String
    let imgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" // we receive _id from mongo
        case userId
        case content
        case likes
        case createdAt
        case imgUrl
        case comments
           
       }

    init(postId: String, userID: PublicUser, content: String, comments: [Comment]?, likes: [String]?, createdAt: String, imgUrl: String?) {
        self.id = postId
        self.userId = userID
        self.content = content
        self.comments = comments
        self.likes = likes
        self.createdAt = createdAt
        self.imgUrl = imgUrl
    }
}
