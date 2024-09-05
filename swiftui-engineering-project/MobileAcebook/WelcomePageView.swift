import SwiftUI

struct WelcomePageView: View {
    let storedToken = UserDefaults.standard.object(forKey: "token") ?? ""

    var body: some View {
        NavigationStack {
            if storedToken as! String != "" {
                FeedView()
            }
            else {
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
        .navigationBarBackButtonHidden(true)
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
