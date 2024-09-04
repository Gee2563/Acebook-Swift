//
//  Post.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//

import Foundation

//public struct Post: Codable {
//    let _id: String
//    let content: String
//    let createdAt: String
//    let imgUrl: String
//    let createdBy: User
//    var likes: [String]?
//}
public struct Post: Codable{
    let id: String
    let userId: PublicUser
    let content: String
//    let comments: [Comment]
//    let likes: [PublicUser]
    let createdAt: String
    let imgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" // we receive _id from mongo
        case userId
        case content
//        case likes
        case createdAt
        case imgUrl
           
       }

//
//    init(postId: Int, userID: Int, username: String, content: String, comments: [Comment], likes: [Int], createdAt: String, imgUrl: String) {
//        self._id = postId
//        self.userId = userID
//        self.username = username
//        self.content = content
//        self.comments = comments
//        self.likes = likes
//    }
}
