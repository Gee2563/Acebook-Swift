import SwiftUI

struct FeedPageView: View {
    @State var loggedOut : Bool = false
    
    var body: some View {
        VStack {
            Text("Feed")
                .font(.largeTitle)
            
            Text("My userId: \(UserDefaults.standard.object(forKey: "userId") ?? "")").padding()
            Text("My token: \(UserDefaults.standard.object(forKey: "token") ?? "")").padding()

        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfilePageView()) {
                    Text("Profile")
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
                        FeedPageView()
                    }
                }
            }
        }
    }
}

