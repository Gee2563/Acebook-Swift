public struct User: Codable {
    let _id: String
    let email: String
    let password: String
    let username: String
    let imgUrl: String
    
    init(_id: String, email: String, password: String, username: String, imgUrl: String) {
        self._id = _id
        self.email = email
        self.password = password
        self.username = username
        self.imgUrl = imgUrl
    }
}

public struct PublicUser: Codable {
    let _id: String
    let username: String
    let profilePicture: String?
}
