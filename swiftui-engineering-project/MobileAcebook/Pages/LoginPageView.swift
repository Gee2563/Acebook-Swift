import SwiftUI

struct LoginPageView: View {
    @State private var email = ""
    @State private var password = ""

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
                .foregroundColor(Color.black)
                .padding(.top)

            Button(
                action: {},
                label: {
                    Text("Login")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                    }
            )
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(Color.white)
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
