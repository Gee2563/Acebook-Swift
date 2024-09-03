//
//  ViewPost.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//

import Foundation
import SwiftUI

struct ViewPost: View {
    var post: Post
    @AppStorage("currentUserId") private var currentUserID: Int = -1 // Retrieve the current user ID from local storage
    @Environment(\.dismiss) var dismiss // Go to previous view
    @State private var isEditing = false 
    @State private var editedContent: String = "" 
    @State private var showAlert = false
    @State private var showEditAlert = false
    @State private var deleteError: Error? = nil

    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 10) {
                if currentUserID == post.userId {
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
                                    showAlert = true
                                } else {
                                    print("Post deleted successfully")
                                    dismiss() // Navigate back to ContentView
                                }
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
                            } else {
                                print("Post updated successfully")
                                isEditing = false // Exit edit mode
                            }
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
                        Text("\(post.username):")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(post.content)
                            .font(.body)
                            .foregroundColor(.primary)
                        Section{
                            HStack{
                            
                            // This is the likes section
                            
                            if !post.likes.isEmpty {
                                Text(" \(post.likes.count) likes")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                if post.likes.contains(currentUserID) {
                                    Button(action: {
                                        updateLikesByID(id: post.id, userId: currentUserID) { error in
                                            if let error = error {
                                                deleteError = error
                                                showAlert = true
                                            } else {
                                                print("Post unliked successfully")
                                            }
                                        }
                                    }) {
                                        Text("Unlike")
                                            .foregroundColor(.red)
                                    }
                                } else {
                                    Button(action: {
                                        updateLikesByID(id: post.id, userId: currentUserID) { error in
                                            if let error = error {
                                                deleteError = error
                                                showAlert = true
                                            } else {
                                                print("Post liked successfully")
                                            }
                                        }
                                    }) {
                                        Text("Like")
                                            .foregroundColor(.blue)
                                    }
                                }
                            } else {
                                Button(action: {
                                    updateLikesByID(id: post.id, userId: currentUserID) { error in
                                        if let error = error {
                                            deleteError = error
                                            showAlert = true
                                        } else {
                                            print("Post liked successfully")
                                        }
                                    }
                                }) {
                                    Text("Like")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            
                        }
                    }
                    }
                }
            }
            Section{
                VStack{
                    Text("Comments")
                }
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
        .padding([.leading, .trailing, .top], 10)
    }
    
}

#Preview {
    UserDefaults.standard.set(1, forKey: "currentUserId")
    
    return ViewPost(
        post: Post(postId: 1, userID: 1, username: "George Smith", content: "This is a raveaowihdfaowdhaowdiawd awhdoawhdaowdihwaod ", comments: [],likes: [1,2,3,4])
    )
}


