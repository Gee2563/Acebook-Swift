import SwiftUI
import PhotosUI

struct ProfilePageView: View {
    @State private var user: User? = nil
    @State var loggedOut: Bool = false
    @State private var selectedImageData: Data? = nil  // State to store the image data
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil  // State for the selected photo picker item
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
            
            // Display either the user image or the selected image
            if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(25)
            } else {
                AsyncImage(url: URL(string: "\(user?.imgUrl ?? "")")) { image in
                    image
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
            }
            
            // Add "Add Image" button to trigger image selection
            PhotosPicker(selection: $selectedPhotoPickerItem, matching: .images) {
                Text("Add Image")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
            .onChange(of: selectedPhotoPickerItem) { newItem in
                // When a new photo is picked, load the image data
                Task {
                    if let newItem = newItem {
                        do {
                            if let data = try await newItem.loadTransferable(type: Data.self) {
                                self.selectedImageData = data
                            }
                        } catch {
                            print("Error loading image data: \(error.localizedDescription)")
                        }
                    }
                }
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
                NavigationLink(destination: FeedView()) {
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
                }
            }
        }
    }
}

#Preview {
    ProfilePageView()
}
