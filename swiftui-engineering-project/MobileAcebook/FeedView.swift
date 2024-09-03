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

struct Feed: View {
    
    @State private var posts = [Post]()
    var body: some View {
        VStack {
            
            NavigationView {
                List(posts, id: \._id) { item in
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text(item.content)
                            .font(.headline)
                    }
                    
                }
            }
            .listRowSpacing(10)
            .onAppear {
                fetchAllPosts { fetchedPosts, error in
                    if let error = error {
                        print("Error fetching posts: \(error.localizedDescription)")
                    } else if let fetchedPosts = fetchedPosts {
                        self.posts = fetchedPosts
                    }
                }
            }
            
        }
       
    }

    func fetchAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
      guard let url = URL(string: "http://localhost:3000/posts") else {
        completion(
          nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
      }

      var request = URLRequest(url: url)
      request.httpMethod = "GET"

      // !!!!This needs to be taken into user defaults!!!
      let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiTWF0dGlzY2F0IiwiaWF0IjoxNzI1MzA5ODMyfQ.Vr0UBkbvm55LUsHT6JvIWHECM0luGYEaWfuMXb9preQ"
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

      URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
          completion(nil, error)
          return
        }

        // Check response and decode
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
          do {
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
