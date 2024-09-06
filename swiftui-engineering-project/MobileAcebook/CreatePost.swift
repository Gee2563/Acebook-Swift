import SwiftUI
import PhotosUI

struct CreatePost: View {
    @State private var postContent = ""
    @State private var posts = [Post]() // Store posts here
    @State private var errorMessage = ""
    @State private var selectedImageData: Data? = nil  // State to store the image data
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil  // State for the selected photo picker item

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                PhotosPicker(selection: $selectedPhotoPickerItem, matching: .images) {
                    
                    Label("", systemImage: "photo")
                        
                    

                }
                .onChange(of: selectedPhotoPickerItem) { newItem in
                    // When a new photo is picked, load the image data
                    Task {
                        if let newItem = newItem {
                            do {
                                if let data = try await newItem.loadTransferable(type: Data.self) {
                                    self.selectedImageData = data
                                }
                            } catch {
                                print("Error loading image data: \(error.localizedDescription)")
                            }
                        }
                    }
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                TextField("What's on your mind?", text: $postContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    guard !postContent.isEmpty else { return }

                    // Call the backend to create a post
                    createPost(content: postContent, imgUrl: selectedImageData) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                            print("Error creating post: \(errorMessage)")
                        } else {
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
                    selectedImageData = nil // Clear selected image data after posting
                }) {
                    Text("Post")
                }
            }
            .padding(.horizontal)

            // Display the selected image if available
            if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Rectangle())
                    .padding()
            }

            
            // Optionally, display existing posts (for debugging or testing)
            // Uncomment the code below if you want to display posts
            /*
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(posts) { post in
                        PostView(postText: post.content)
                    }
                }
                .padding(.horizontal)
            }
            */
        }
        .background(Color.blue.opacity(0.1))
        .padding()
    }
}

// Mocked `createPost` function for demonstration purposes
func createPost(content: String, imgUrl: Data?, completion: @escaping (Error?) -> Void) {
    // Add your API call here
    completion(nil)
}




// Uncomment the preview if you want to test the view in SwiftUI preview
///*
#Preview {
    CreatePost()
}
