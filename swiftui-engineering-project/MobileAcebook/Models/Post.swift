//
//  Post.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//

import Foundation
public struct  Post : Codable{
    let id: Int
    let userId: Int
    let username: String
    let content: String
    let comments: [Comment]
    // userId == int, so just populate with a list of numbers
    let likes: [Int]
    
    init(postId: Int, userID: Int, username: String, content: String, comments: [Comment], likes: [Int]) {
        self.id = postId
        self.userId = userID
        self.username = username
        self.content = content
        self.comments = comments
        self.likes = likes
    }
}


