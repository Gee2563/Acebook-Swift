import SwiftUI

struct ProfilePageView: View {
    @State private var user: User? = nil
    @State var loggedOut : Bool = false
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                            
            AsyncImage(url: URL(string: "\(user?.imgUrl ?? "")")) { 
                image in image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(25)
                } placeholder: {
                    Image("default")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(25)
                }

            Text("email: \(user?.email ?? "")")
                .font(.title2)
            Text("username: \(user?.username ?? "")")
                .font(.title2)
        }
        .onAppear {
            getUserDetails { data, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else if let data = data {
                    self.user = data
                    print(user ?? "")
                }
            }
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

