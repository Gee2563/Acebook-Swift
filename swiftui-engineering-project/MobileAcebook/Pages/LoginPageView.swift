import SwiftUI

struct LoginPageView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State var success : Bool = false

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
            
            Button (
                action: {
                    login(email, password)
                    let storedToken = UserDefaults.standard.object(forKey: "token") ?? ""
                    if storedToken as! String != "" {
                        success = true
                    }
                    else if storedToken as! String == "" {
                        success = false
                    }
//                    print(storedToken)
//                    print(success)
                },
                label: {
                    Text("Login")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
            .padding(.top)
            .navigationDestination(isPresented: $success) {
                if success {
                    FeedPageView()
                }
                else if !success {
                    LoginPageView()
                }
            }

            HStack {
                Text("Don't have an account?")
                NavigationLink(destination: SignupPageView()) {
                    Text("Signup")
                    .bold()
                }
                Text("or")
                NavigationLink(destination: WelcomePageView()) {
                    Text("Zuck")
                    .bold()
                }
            }
            .padding(.top)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
