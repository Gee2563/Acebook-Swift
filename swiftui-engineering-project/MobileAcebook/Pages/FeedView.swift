//
//  Feed.swift
//  MobileAcebook
//
//  Created by Matt Wilkes on 02/09/2024.
//

import SwiftUI


struct FeedView: View {
    @AppStorage("userId") var currentUserID: String = ""
    @State var loggedOut : Bool = false
    @State private var posts = [Post]()
    @State private var showAlert = false
    @State private var deleteError: Error? = nil
    var body: some View {
                  // Add CreatePost at the top of the feed
            CreatePost() // Reuse the CreatePost view
        VStack {
            CreatePost()

            NavigationStack {
                List {
                    ForEach(posts, id: \.id) { item in
                        @State var liked: Bool = false
                        VStack {
                            NavigationLink(destination: ViewPost(post: item)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.userId.username)
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text(item.content)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                            .contentShape(Rectangle()) //This is intended to seperate navigation from the likes
                            Spacer()
                            HStack{
                                if !(item.likes ?? []).isEmpty {
                                    Text(" \(item.likes?.count ?? 0) likes")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    if (item.likes ?? []).contains(currentUserID) {
                                        Button(action: {
                                            updateLikesByID(id: item.id, userId: currentUserID) { error in
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
                                            updateLikesByID(id: item.id, userId: currentUserID) { error in
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
                                        updateLikesByID(id: item.id, userId: currentUserID) { error in
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
            
            .onAppear {
                fetchAllPosts { fetchedPosts, error in
                    if let error = error {
                        print("Error fetching posts: \(error.localizedDescription)")
                    } else if let fetchedPosts = fetchedPosts {
                        self.posts = fetchedPosts
//                        print(authToken)
                        

                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Profile") {
                        print("You were taken to Profile view.")
                    }
                    Button(action: {
                        UserDefaults.standard.set("", forKey: "userId")
                        UserDefaults.standard.set("", forKey: "token")
                        loggedOut = true
                        print("You were logged out.")
                        print(UserDefaults.standard.object(forKey: "token") ?? "ELSE")
                    }) {
                        Text("Logout")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationDestination(isPresented: $loggedOut) {
                if loggedOut {
                    WelcomePageView()
                }
            }
            
        } .background(Color.blue.opacity(0.10))
        
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Adjust this format to match your server's date format
        return dateFormatter.date(from: self)
    }
}


#Preview {
    FeedView()
}


