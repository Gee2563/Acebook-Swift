//
//  PostServiceProtocol.swift
//  MobileAcebook
//
//  Created by George Smith on 03/09/2024.
//
import Foundation

// Need to wait for logic for storing authtoken.
let authToken = UserDefaults.standard.object(forKey: "token") ?? ""
let currentUserID = UserDefaults.standard.string(forKey: "userId") ?? ""

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
    guard let url = URL(string: "http://localhost:3000/posts/update") else {
        completion(URLError(.badURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PATCH" 
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

    let body: [String: Any] = ["postId": id, "content": newContent]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        completion(error)
        return
    }

    // Print the request body for debugging
    if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
        print("Request body: \(bodyString)")
    }

    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(error)
            return
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")

            // If not successful, print the server error message
            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Error message from server: \(errorMessage)")
                }
                completion(URLError(.badServerResponse))
                return
            }
        }
    }

    task.resume()
}


func updateLikesByID(id: String, userId: String, completion: @escaping ([String]?, Error?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/posts/like") else {
        completion(nil, URLError(.badURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

    let body: [String: Any] = ["postId": id]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        completion(nil, error)
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        // Check if there was an error
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }

        // Check if the HTTP status code is valid
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            do {
                // Decode the JSON response to extract the likes array
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let post = jsonResponse["post"] as? [String: Any],
                   let likes = post["likes"] as? [String] {
                    completion(likes, nil)
                } else {
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(nil, error)
                }
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        } else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to update likes"])
            completion(nil, error)
        }
    }.resume()
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
        let postsResponse = try JSONDecoder().decode(PostResponse.self, from: data)
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

// KR-SENDING POST TO THE DB:

//func createPost(id: String, newContent: String, completion: @escaping (Error?) -> Void) {
func createPost(content: String, imgUrl: String?, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/posts") else {
        completion(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    let body: [String: Any] = ["content": content, "imgUrl": imgUrl ?? ""]
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
        
        completion(nil)
    }
    task.resume()
}
