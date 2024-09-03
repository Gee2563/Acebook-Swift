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

struct Post: Codable {
    let _id: String
    let message: String
    let createdAt: String
    let imgUrl: String
//    let createdBy: User
//    var likes: [String]
    
}

struct Feed: View {
    
    @State private var posts = [Post]()
    var body: some View {
        
        List(posts, id: \._id) { item in
            VStack(alignment: .leading) {
                
                Text(item.message)
                    .font(.headline)
            }
        }
        .onAppear {
            fetchAllPosts { fetchedPosts, error in
                if let error = error {
                    // Handle the error appropriately, such as displaying an alert
                    print("Error fetching posts: \(error.localizedDescription)")
                } else if let fetchedPosts = fetchedPosts {
                    // Update the state with the fetched posts
                    self.posts = fetchedPosts
                }
            }
        }
    }

    func fetchAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
      // Create your URL
      guard let url = URL(string: "http://localhost:3000/posts") else {
        completion(
          nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
      }

      // Create your request
      var request = URLRequest(url: url)
      request.httpMethod = "GET"

      // Retrieve the JWT from a secure place usually (look into UserDefaults), but we'll hardcode it for Playgrounds purposes
      let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiTWF0dGlzY2F0IiwiaWF0IjoxNzI1MzA5ODMyfQ.Vr0UBkbvm55LUsHT6JvIWHECM0luGYEaWfuMXb9preQ"
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

      // Let's make the request
      URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
          completion(nil, error)
          return
        }

        // First we'll check that we've received a valid response, then we'll try to decode it
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
          do {
            // We reference the Struct that we'll prepare next to map the data response from JSON to Swift. The Structs we write should match the JSON response
            let postsResponse = try JSONDecoder().decode(Response.self, from: data)
            completion(postsResponse.posts, nil)
          } catch {
            print("Decoding error: \(error)")
            completion(nil, error)
          }
        } else {
          completion(
            nil,
            NSError(
              domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500,
              userInfo: [NSLocalizedDescriptionKey: "Failed to fetch posts"]))
        }
      }.resume()
    }
}

#Preview {
    Feed()
}
