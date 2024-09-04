//
//  Feed.swift
//  MobileAcebook
//
//  Created by Matt Wilkes on 02/09/2024.
//

import SwiftUI

struct Response: Codable {
    var posts: [Post]
}

struct Feed: View {
    
    @State private var posts = [Post]()
    var body: some View {
        VStack {
            
            NavigationStack {
                List { ForEach(posts, id: \.id) {item in
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text(item.userId.username)
                        Text(item.userId._id)
                        Text(item.content)
                            .font(.headline)
                        Text(item.createdAt)
                    }
                    }
                }
            }
            .listRowSpacing(10)
            .onAppear {
                fetchAllPosts { fetchedPosts, error in
                    if let error = error {
                        print("Error fetching posts: \(error.localizedDescription)")
                    } else if let fetchedPosts = fetchedPosts {
                        self.posts = fetchedPosts
                    }
                }
            }
            
        }
       
    }

}


#Preview {
    Feed()
}
