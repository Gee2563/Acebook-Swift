//
//  CreatePost.swift
//  MobileAcebook
//
//  Created by Karla A Rangel Hernandez on 03/09/2024.
//
//import Foundation
//import SwiftUI
//
//struct PostView: View {
//    var postText: String
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(postText)
//                .padding()
//                .background(Color.white)
//                .cornerRadius(10)
//        }
//        .padding(.horizontal)
//        .cornerRadius(12)
//        .padding(.bottom, 8)
//    }
//}
//
//struct CreatePost: View {
//    @State private var post = ""
//    @State private var posts = [String]() // array to store posts
//    
//    var body: some View {
//        VStack (alignment: .leading, spacing: 16) {
//           
////            Form {
//                HStack {
//                    TextField("What's on your mind?", text: $post)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    
//                    Button("Post") {
//                        guard !post.isEmpty else { return }
//                        posts.append(post)
//                        post = ""
//                    }
//                }
////            }
//            .padding(.horizontal)
//            .padding(.top, 80)
//            
//            ScrollView {
//                VStack(spacing: 16) {
//                    ForEach(posts, id: \.self) { post in
//                        PostView(postText: post) // Use the new PostView here
//                    }
//                }
//                .padding(.horizontal)
////                .padding(.top, 8)
//            }
//        }
//        .padding(.bottom, 16)
//        .background(Color.gray.opacity(0.1))
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//#Preview {
//    CreatePost()
//}

import SwiftUI

struct PostView: View{
    var postText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(postText)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .cornerRadius(12)
        .padding(.bottom, 8)
    }
}

struct CreatePost:View {
    @State private var postContent = ""
    @State private var posts = [Post]() //store posts here
    @State private var errorMessage = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            //input place for new post
            HStack {
                TextField("What's on your mind?", text: $postContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    guard !postContent.isEmpty else { return }
                    
                    // call the backend to create a post
                    createPost(content: postContent, imgUrl: nil) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                            print("Error creating post: \(errorMessage)")
                        } else {
                            // refresh posts after successful creation
                            fetchAllPosts { fetchedPosts, error in
                                if let error = error {
                                    print("Error fetching posts: \(error.localizedDescription)")
                                } else if let fetchedPosts = fetchedPosts {
                                    self.posts = fetchedPosts
                                }
                            }
                        }
                    }
                    postContent = "" // Clear input after post is created
                }) {
                    Text("Post")
                }
            }
            .padding(.horizontal)
            .padding(.top, 80)
            
            //Display all posts including the newly created ones
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(posts, id: \.id) { post in
                        PostView(postText: post.content)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 16)
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
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

#Preview {
    CreatePost()
}
