//
//  CreatePost.swift
//  MobileAcebook
//
//  Created by Karla A Rangel Hernandez on 03/09/2024.
//

//import Foundation
//import SwiftUI
//
//struct CreatePost: View {
//    @State private var post = ""
//    @State private var posts = [String]() //array to store posts
//    //    @State var isPickerShowing = false
//    
//    var body: some View {
//        Form {
////            List {
//                HStack {
//                    TextField("What's on your mind?", text: $post)
////                    Button {
////                        isPickerShowing = true
////                    } label: {
////                        Text(" + Image")
////                    }
//                    Button("Post") {
//                        guard !post.isEmpty else { return }
//                        posts.append(post)
//                        post = ""
//                    }
//                }
////            }
//            Section {
//                ForEach(posts, id: \.self) { post in
//                    Text(post)
//                        .padding()
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(8)
//                        .shadow(radius: 1)
//                        .padding(.vertical, 4)
//                }
//            }
//        }
//    }
//    
//}
//    #Preview {
//        CreatePost()
//    }

import Foundation
import SwiftUI

struct PostView: View {
    var postText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(postText)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
//                .shadow(radius: 5)
        }
        .padding(.horizontal)
//        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .padding(.bottom, 8)
    }
}

struct CreatePost: View {
    @State private var post = ""
    @State private var posts = [String]() // array to store posts
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
           
//            Form {
                HStack {
                    TextField("What's on your mind?", text: $post)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Post") {
                        guard !post.isEmpty else { return }
                        posts.append(post)
                        post = ""
                    }
                }
//            }
            .padding(.horizontal)
            .padding(.top, 80)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(posts, id: \.self) { post in
                        PostView(postText: post) // Use the new PostView here
                    }
                }
                .padding(.horizontal)
//                .padding(.top, 8)
            }
        }
        .padding(.bottom, 16)
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CreatePost()
}

// test!
