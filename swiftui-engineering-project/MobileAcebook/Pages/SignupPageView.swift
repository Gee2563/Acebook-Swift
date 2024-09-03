import SwiftUI

struct SignupPageView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var imgUrl = ""

    func handleSignup() {
        signup(User(email: email, password: password, username: username, imgUrl: imgUrl))
    }

    var body: some View {
        VStack {
            Text("Signup")
                .font(.largeTitle)

            TextField("Username", text: self.$username)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            Color.black.opacity(0.4),
                            style: StrokeStyle()
                        )
            )
            .autocapitalization(.none)
            .foregroundColor(Color.black)

            TextField("Email", text: self.$email)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            Color.black.opacity(0.4),
                            style: StrokeStyle()
                        )
            )
            .autocapitalization(.none)
            .foregroundColor(Color.black)
            .padding(.top)

            SecureField("Password", text: self.$password)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            Color.black.opacity(0.4),
                            style: StrokeStyle()
                        )
            )
            .autocapitalization(.none)
            .foregroundColor(Color.black)
            .padding(.top)

            Button(
                action: {handleSignup()},
                label: {
                    Text("Signup")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
            .padding(.top)
            
            HStack {
                Text("Already have an account?")
                NavigationLink(destination: LoginPageView()) {
                        Text("Login")
                        .bold()
                    }
            }
            .padding(.top)
        }
        .padding()
    }
}
