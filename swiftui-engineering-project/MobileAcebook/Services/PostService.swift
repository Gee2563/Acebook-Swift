//
//  PostServiceProtocol.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//
import Foundation

// Need to wait for logic for storing authtoken.
let authToken = UserDefaults.standard.object(forKey: "token") ?? ""

func deletePostByID(_ id: String, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "https://localhost:5000/posts/delete") else {
        completion(URLError(.badURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            completion(nil)
        } else {
            // Return a generic error if the status code is not in the 2xx range
            completion(URLError(.badServerResponse))
        }
    }
    task.resume()
}

func updatePostByID(id: String, newContent: String, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "https://localhost:5000/posts/update") else {
        completion(URLError(.badURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

    let body: [String: Any] = ["body": newContent]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        completion(error)
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(URLError(.badServerResponse))
            return
        }

        if let data = data {
            do {
                let updatedPost = try JSONDecoder().decode(Post.self, from: data)
                print("Updated post: \(updatedPost)")
                completion(nil)
            } catch {
                completion(error)
            }
        } else {
            completion(nil)
        }
    }

    task.resume()
}


func updateLikesByID( id: String, userId: String, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "https://localhost:5000/posts/like") else {
        completion(URLError(.badURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

    let body: [String: Any] = ["userId": userId]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        completion(error)
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(URLError(.badServerResponse))
            return
        }

        if let data = data {
            do {
                let updatedPost = try JSONDecoder().decode(Post.self, from: data)
                print("Updated post: \(updatedPost)")
                completion(nil)
            } catch {
                completion(error)
            }
        } else {
            completion(nil)
        }
    }

    task.resume()
}

func fetchAllPosts(completion: @escaping ([Post]?, Error?) -> Void) {
  guard let url = URL(string: "http://localhost:3000/posts") else {
    completion(
      nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
    return
  }

  var request = URLRequest(url: url)
  request.httpMethod = "GET"

  request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

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
