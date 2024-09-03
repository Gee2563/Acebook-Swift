import Foundation

func signup(_ email: String, _ password: String, _ username: String, _ imgUrl: String) {
    let payload: [String: Any] = [
        "email": email,
        "password": password,
        "username": username,
        "imgUrl": imgUrl,
    ]
    
    let url = URL(string: "http://localhost:3000/users")!
    var request = URLRequest(url: url)

    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }

        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
        }
    }
    .resume()
}

