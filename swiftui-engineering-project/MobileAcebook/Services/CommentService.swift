import Foundation

// Fetch all comments for a post
func fetchAllPostComments(postId: String, completion: @escaping([Comment]?, Error?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/comments/\(postId)") else {
        completion(nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }

        // Check HTTP response status code
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            do {
                let commentsResponse = try JSONDecoder().decode(CommentResponse.self, from: data)
                completion(commentsResponse.comments, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        } else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            completion(
                nil,
                NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch comments"])
            )
        }
    }.resume()
}

// Create a new comment for a post
func createCommentByPost(postId: String, message: String, completion: @escaping(Error?) -> Void) {
    guard let url = URL(string: "http://localhost:3000/comments/\(postId)") else {
        completion(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = ["message": message]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        completion(error)
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(error)
            return
        }

        // Check HTTP response status code
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            completion(nil)
        } else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            completion(
                NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to create comment"])
            )
        }
    }.resume()
}
