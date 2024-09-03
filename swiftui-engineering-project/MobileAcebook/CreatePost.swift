//
//  CreatePost.swift
//  MobileAcebook
//
//  Created by Karla A Rangel Hernandez on 03/09/2024.
//

import Foundation
import SwiftUI

struct CreatePost: View {
    @State private var post = ""
    @State private var posts = [String]() //array to store posts
//    @State var isPickerShowing = false
    
    var body: some View {
        //        Form {
        Form {
//            List {
                HStack {
                    TextField("What's on your mind?", text: $post)
//                    Button {
//                        isPickerShowing = true
//                    } label: {
//                        Text(" + Image")
//                    }
                    Button("Post") {
                        guard !post.isEmpty else { return }
                        posts.append(post)
                        post = ""
                    }
                }
//            }
            Section {
                ForEach(posts, id: \.self) { post in
                    Text(post)
                }
            }
        }
    }
    
}
    #Preview {
        CreatePost()
    }

