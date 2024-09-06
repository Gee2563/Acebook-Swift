//
//  ViewPost.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//

import Foundation
import SwiftUI

struct ViewPost: View {
    @Binding var post: Post
//    var post: Post
    let currentUserID = UserDefaults.standard.string(forKey: "userId") ?? ""

    @Environment(\.dismiss) var dismiss // Go to previous view
    @State private var isEditing = false
    @State private var editedContent: String = ""
    @State private var showAlert = false
    @State private var showEditAlert = false
    @State private var deleteError: Error? = nil
    @State private var allComments: [Comment] = [] // Fetch and update comments
    @State private var newComment: String = "" // New comment input
//    @State private var liked: Bool = false
//    @State private var likes: [String] = []
    @State private var errorMessage: String? = nil
    
    

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if currentUserID == post.userId._id {
                HStack {
                    Button(action: {
                        isEditing.toggle()
                        editedContent = post.content // Set the initial value of the edited content to the current post content
                    }) {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Button(action: {
                        deletePostByID(post.id) { error in
                            if let error = error {
                                deleteError = error
                                showEditAlert = true
                            } 
//                            else {
//                                print("Post updated successfully")
//                                isEditing = false // Exit edit mode
//                                dismiss()
//                            }
                            dismiss()
                        }
                    }) {
                        Label("", systemImage: "trash")
                            .foregroundColor(.red)
                            .labelsHidden()
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(deleteError?.localizedDescription ?? "An error occurred"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }

            if isEditing {
                TextField("Edit post content", text: $editedContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    updatePostByID(id: post.id, newContent: editedContent) { error in
                        if let error = error {
                            deleteError = error
                            showEditAlert = true
                        }
                        // else {
                        //     print("Post updated successfully")
                        //     isEditing = false // Exit edit mode
                        // }
                        dismiss()
                    }
                }) {
                    Text("Save Changes")
                        .foregroundColor(.green)
                }
                .alert(isPresented: $showEditAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(deleteError?.localizedDescription ?? "Failed to edit the post"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                    
            } else {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(post.userId.username):")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(post.content)
                        .font(.body)
                        .foregroundColor(.primary)

                    // Likes section
//                    HStack {
//                        if !(post.likes ?? []).isEmpty {
//                            Text(" \(post.likes?.count ?? 0) likes")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            Spacer()
//                            if (post.likes ?? []).contains(currentUserID) {
//                                Button(action: {
//                                    print("already liked, likes: \(likes)")
//                                    updateLikesByID(id: post.id, userId: currentUserID) { updatedLikes, error in
//                                        DispatchQueue.main.async {
//                                            if let updatedLikes = updatedLikes {
//                                                self.likes = updatedLikes
//                                            } else if let error = error {
//                                                self.errorMessage = error.localizedDescription
//                                            }
//                                        }
//                                    }
//                                }) {
//                                    Text("Unlike")
//                                        .foregroundColor(.red)
//                                }
//                            } else {
//                                Button(action: {
//                                    print("not liked, likes: \(likes)")
//                                    updateLikesByID(id: post.id, userId: currentUserID) { updatedLikes, error in
//                                        DispatchQueue.main.async {
//                                            if let updatedLikes = updatedLikes {
//                                                self.likes = updatedLikes
//                                            } else if let error = error {
//                                                self.errorMessage = error.localizedDescription
//                                            }
//                                        }
//                                    }
//                                }) {
//                                    Text("Like")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        } else {
//                            Text(" \(post.likes?.count ?? 0) likes")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Button(action: {
//                                updateLikesByID(id: post.id, userId: currentUserID) { updatedLikes, error in
//                                    DispatchQueue.main.async {
//                                        if let updatedLikes = updatedLikes {
//                                            self.likes = updatedLikes
//                                        } else if let error = error {
//                                            self.errorMessage = error.localizedDescription
//                                        }
//                                    }
//                                }
//                            }) {
//                                Text("Like")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    }
                    HStack {
                                           Text(" \(post.likes?.count ?? 0) likes")
                                               .font(.subheadline)
                                               .foregroundColor(.gray)
                                           Spacer()
                                           Button(action: toggleLike) {
                                               Text(post.likes?.contains(currentUserID) == true ? "Unlike" : "Like")
                                                   .foregroundColor(post.likes?.contains(currentUserID) == true ? .red : .blue)
                                           }
                                       }
                }
            }

            // Comment Section
            Section {
                VStack(alignment: .leading) {
                    Text("Comments")
                        .font(.headline)
                        .padding(.bottom, 5)

                    // Display existing comments
                    ForEach(allComments) { comment in
                        VStack(alignment: .leading, spacing: 5) {
                            Section{
                                Text("\(comment.createdBy.username):")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text(comment.message)
                                    .font(.body)
                            }
                            .padding(.bottom, 5)
                        }
                    }
                    // New comment input field
                    HStack {
                        Section {
                            TextField("Add a comment...", text: $newComment)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                addComment()
                                
                            }) {
                                Text("Comment")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding()
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
        .padding([.leading, .trailing, .top], 10)
        .onAppear {
            fetchComments() // Fetch comments when the view appears
        }
    }

    // Helper function to add comment
    func addComment() {
        guard !newComment.isEmpty else { return }
        createCommentByPost(postId: post.id, message: newComment) { error in
            if let error = error {
                print("Failed to add comment: \(error)")
            } else {
                print("Comment added successfully")
                fetchComments() // Refresh comments after adding a new one
            }
        }
        newComment = "" // Clear the input field after posting
    }

    // Fetch comments when the view appears
    func fetchComments() {
        fetchAllPostComments(postId: post.id) { comments, error in
            if let error = error {
                print("Failed to fetch comments: \(error)")
            } else {
                allComments = comments ?? []
            }
        }
    }
    // Toggle like or unlike
        func toggleLike() {
            updateLikesByID(id: post.id, userId: currentUserID) { updatedLikes, error in
                DispatchQueue.main.async {
                    if var updatedLikes = updatedLikes {
                        post.likes = updatedLikes  // Directly update post.likes
                    } else if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
//    func fetchPostLikes() {
//            isLoading = true
//            fetchAllPosts { posts, error in
//                DispatchQueue.main.async {
//                    isLoading = false
//                    if let posts = posts {
//                        if let post = posts.first(where: { $0.id == postId }) {
//                            self.likes = post.likes
//                        }
//                    } else if let error = error {
//                        self.errorMessage = error.localizedDescription
//                    }
//                }
//            }
//        }
}

