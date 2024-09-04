public struct User {
    let email: String
    let password: String
    let username: String
    let imgUrl: String
}

public struct PublicUser: Codable {
    let _id: String
    let username: String
    let profilePicture: String?
}
