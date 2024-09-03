import SwiftUI

struct LoginPageView: View {
    @State private var email = ""
    @State private var password = ""
    
    func handleLogin() {
//        login(email, password)
    }

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)

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
                action: {handleLogin()},
                label: {
                    Text("Login")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
            .padding(.top)

            HStack {
                Text("Don't have an account?")
                NavigationLink(destination: SignupPageView()) {
                        Text("Signup")
                        .bold()
                    }
            }
            .padding(.top)
        }
        .padding()
    }
}
