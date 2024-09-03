func signup(_ user: User) {
    print(user)
}

func login(_ user: User) {
    print(user)
}


//funct login (_)

    // func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
    //     guard let url = URL(string: "http://localhost:3000/posts")
    //     else {
    //         completion(
    //         nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
    //         return
    //     }

    //     // Create your request
    //     var request = URLRequest(url: url)
    //     request.httpMethod = "GET"

    //     // Retrieve the JWT from a secure place usually (look into UserDefaults), but we'll hardcode it for Playgrounds purposes
    //     let token = "JWT Token here"
    //     request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    //     // Let's make the request
    //     URLSession.shared.dataTask(with: request) { data, response, error in
    //         guard let data = data, error == nil else {
    //         completion(nil, error)
    //         return
    //         }

    //         // First we'll check that we've received a valid response, then we'll try to decode it
    //         if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
    //         do {
    //             // We reference the Struct that we'll prepare next to map the data response from JSON to Swift. The Structs we write should match the JSON response
    //             let postsResponse = try JSONDecoder().decode(PostsResponse.self, from: data)
    //             completion(postsResponse.posts, nil)
    //         } catch {
    //             print("Decoding error: \(error)")
    //             completion(nil, error)
    //         }
    //         } else {
    //         completion(
    //             nil,
    //             NSError(
    //             domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500,
    //             userInfo: [NSLocalizedDescriptionKey: "Failed to fetch posts"]))
    //         }
    //     }.resume()
    // }

