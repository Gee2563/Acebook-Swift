import SwiftUI

struct WelcomePageView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()

                    Text("Welcome to Acebook!")
                        .font(.largeTitle)

                    Text("All your data belongs to us...🔎")
                        .font(.caption)

                    Spacer()

                    Image("zuck")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .accessibilityIdentifier("zuck")
                        .cornerRadius(25)

                    Spacer()

                    HStack {
                        NavigationLink(destination: LoginPageView()) {
                            Text("Login ")
                                .bold()
                            }

                        NavigationLink(destination: SignupPageView()) {
                                Text(" Signup")
                                .bold()
                            }
                    }

                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
