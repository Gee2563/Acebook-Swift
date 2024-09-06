//
//  NavBar.swift
//  MobileAcebook
//
//  Created by Karla A Rangel Hernandez on 06/09/2024.
//
//
import Foundation
import SwiftUI

struct NavBar: View {
    /*  @AppStorage("userId") var currentUserID: String = ""*/ // Check if user is logged in
    
    var body: some View {
        // Check if user is logged in before showing the NavBar
        //        if !currentUserID.isEmpty {
        TabView {
            FeedView()
                .tabItem{
                    Label("Feed", systemImage: "house")
                }
            ProfilePageView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
//            WelcomePageView()
//                .tabItem {
//                    Label("Logout", systemImage: "star")
//                }
        }
    }
}
            
//        } else {
//            // If user is not logged in, show WelcomePageView
//            WelcomePageView()
//        }
    

#Preview {
    NavBar()
}
