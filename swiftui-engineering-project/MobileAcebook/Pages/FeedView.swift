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
    @State var loggedOut: Bool = false
    @State private var posts = [Post]()

    var body: some View {
        
        
        NavigationView {
            VStack {
//                Section{
                    CreatePost(posts: $posts)
//                }
                // Add CreatePost at the top of the feed
              // Pass posts binding to CreatePost
                
                List(posts) { item in
                    VStack(alignment: .leading) {
                        Text(item.userId.username)
                        Text(item.userId._id)
                        Text(item.content)
                            .font(.headline)
                        
                        // Convert date string to Date object for better display
                        if let createdAtDate = item.createdAt.toDate() {
                            Text(createdAtDate, style: .date)
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
            
        }
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
