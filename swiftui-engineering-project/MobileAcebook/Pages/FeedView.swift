//
//  Feed.swift
//  MobileAcebook
//
//  Created by Matt Wilkes on 02/09/2024.
//

import Foundation
import SwiftUI


struct FeedView: View {
    @AppStorage("userId") var currentUserID: String = ""
    @State var loggedOut : Bool = false
    @State private var posts = [Post]()
    @State private var showAlert = false
    @State private var deleteError: Error? = nil
    var body: some View {
                  // Add CreatePost at the top of the feed
           
        VStack {
            CreatePost()

            NavigationStack {
                List {
                    ForEach($posts, id: \.id) { $item in
                        @State var liked: Bool = false
                        VStack {
                            NavigationLink(destination: ViewPost(post: $item)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.userId.username)
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text(item.content)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                Divider()
                                }
                                .padding() 
                                .background(Color.white) 
                                .cornerRadius(10) 
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            }
                            .contentShape(Rectangle()) //This is intended to seperate navigation from the likes
                            Spacer()

                        }
                    }
                }

                
            }
            .background(Color.blue.opacity(0.05))
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
            
        } 
        .padding()
        .background(Color.blue.opacity(0.10))
        
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
