//
//  AppState.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-13.
//

//import Foundation
//import FirebaseAuth
//import Firebase
//
//class AppState: ObservableObject {
//    @Published var currentUser: User?
//
//    var isLoggedIn: Bool {
//        return currentUser != nil
//    }
//    
//    init() {
//        FirebaseApp.configure()
//        
//        if let currentUser = Auth.auth().currentUser {
//            self.currentUser = currentUser
//        }
//    }
//}


import Foundation
import FirebaseAuth
import Firebase

class AppState: ObservableObject {
    @Published var currentUser: User?

    var isLoggedIn: Bool {
        currentUser != nil
    }

    init() {
        FirebaseApp.configure()
        // Do not automatically set the currentUser from Firebase Auth
        // to force login every time the app starts.

        // Optionally, you can log out the current user during initialization
        // for development purposes. Uncomment the following line to enable this.
        // signOutUser()
    }

    // Helper method to sign out the user
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch let signOutError {
            print("Error signing out: \(signOutError)")
        }
    }
}

