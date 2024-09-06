import SwiftUI

struct FeedView: View {
    @AppStorage("userId") var currentUserID: String = ""
    @State var loggedOut: Bool = false
    @State private var posts = [Post]()
    @State private var showAlert = false
    @State private var deleteError: Error? = nil
    @State private var navigateToProfile = false  // State to control navigation to ProfilePageView
    
    var body: some View {
                  // Add CreatePost at the top of the feed
           
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
                            .contentShape(Rectangle()) //This is intended to separate navigation from the likes
                            Spacer()
                            HStack {
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
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Profile button with navigation
                    Button(action: {
                        navigateToProfile = true  // Set state to navigate to profile
                    }) {
                        Text("Profile")
                    }

                    // Logout button
                    Button(action: {
                        UserDefaults.standard.set("", forKey: "userId")
                        UserDefaults.standard.set("", forKey: "token")
                        loggedOut = true
                        print("You were logged out.")
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
            // Navigate to ProfilePageView when navigateToProfile is true
            .navigationDestination(isPresented: $navigateToProfile) {
                ProfilePageView()
            }
        }
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
