//
//  MobileAcebookApp.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI

@main
struct MobileAcebookApp: App {
    @AppStorage("userId") var currentUserID: String = "" // Check if user is logged in
    
    var body: some Scene {
        WindowGroup {
            
            // Show the NavBar if user is logged in, otherwise show WelcomePageView
            if !currentUserID.isEmpty {
                
                NavBar() // This displays the TabView with Feed and Profile tabs
                
            } else {
                WelcomePageView()
            }
        }
    }
}
