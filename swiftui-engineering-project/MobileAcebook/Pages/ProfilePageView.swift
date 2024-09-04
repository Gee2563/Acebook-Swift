import SwiftUI

//            Text("My userId: \(UserDefaults.standard.object(forKey: "userId") ?? "ELSE")").padding()
//            Text("My token: \(UserDefaults.standard.object(forKey: "token") ?? "ELSE")").padding()

struct ProfilePageView: View {
    @State var loggedOut : Bool = false
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: FeedPageView()) {
                    Text("Feed")
                    .bold()
                }
                
                Button (
                    action: {
                        UserDefaults.standard.set("", forKey: "userId")
                        UserDefaults.standard.set("", forKey: "token")
                        loggedOut = true
                        print("You were logged out.")
                    },
                    label: {
                        Text("Logout")
                    }
                )
                .buttonStyle(.borderedProminent)
                .navigationDestination(isPresented: $loggedOut) {
                    if loggedOut {
                        WelcomePageView()
                    }
                    else if !loggedOut {
                        ProfilePageView()
                    }
                }
            }
        }
    }
}
