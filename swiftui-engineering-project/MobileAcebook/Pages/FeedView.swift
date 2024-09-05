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

struct FeedView: View {
    @State var loggedOut : Bool = false
    @State private var posts = [Post]()
    var body: some View {
        VStack {
            
            // Add CreatePost at the top of the feed
            CreatePost() // Reuse the CreatePost view
          
            NavigationView {
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
                        print(authToken)
                        
                    } else if let fetchedPosts = fetchedPosts {
                        self.posts = fetchedPosts
                        print(authToken)
                        
                    }
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Profile") {
                    print("You were taken to Profile view.")
                }
                Button (
                    action: {
                        UserDefaults.standard.set("", forKey: "userId")
                        UserDefaults.standard.set("", forKey: "token")
                        loggedOut = true
                        print("You were logged out.")
                        print(UserDefaults.standard.object(forKey: "token") ?? "ELSE")
                    },
                    label: {
                        Text("Logout")
                    }
                )
                .buttonStyle(.borderedProminent)
                .navigationDestination(isPresented: $loggedOut) {
                    if loggedOut {
                        WelcomePageView()
                    }
                    else if !loggedOut {
                        FeedView()
                    }
                }
            }
        }
       
    }

}


#Preview {
    FeedView()
}
