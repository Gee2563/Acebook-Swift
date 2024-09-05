import Foundation

func getUserDetails(completion: @escaping (User?, Error?) -> Void) {
    
    let url = URL(string: "http://localhost:3000/users")!
    var request = URLRequest(url: url)
    
    request.httpMethod = "GET"
    request.setValue("Bearer \(UserDefaults.standard.object(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }
                
        struct Response: Codable {
            let userData: [User]
            let token: String
        }
        
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            completion(response.userData[0], nil)
        } catch let jsonError{
            completion(nil, jsonError)
        }
    }
    .resume()
}
