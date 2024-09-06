import Foundation

func getUserDetails(completion: @escaping (User?, Error?) -> Void) {
    // Ensure that a token is available in UserDefaults
    guard let token = UserDefaults.standard.string(forKey: "token"), !token.isEmpty else {
        completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authenticated. No token found."]))
        return
    }
    
    //implement API logic - uploads local image and generates url to parse to BE cloudinator
    //https://cloudinary.com/documentation/ios_quickstart
    
    // URL to the user details endpoint
    guard let url = URL(string: "http://localhost:3000/users") else {
        completion(nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        return
    }
    
    // Create a URL request and set authorization header
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    // Start the data task to fetch user details
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }
        
        // Define the expected response structure
        struct Response: Codable {
            let userData: [User]
            let token: String
        }
        
        // Decode the JSON response into the `Response` struct
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            
            // Ensure there is at least one user in the response
            if let firstUser = response.userData.first {
                completion(firstUser, nil)
            } else {
                completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user data found"]))
            }
        } catch {
            completion(nil, error)
        }
    }.resume()
}
