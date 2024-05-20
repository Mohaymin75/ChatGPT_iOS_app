//
//  AuthService.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-13.
//

import FirebaseAuth

class AuthService {

    static let shared = AuthService()
    private init() {}

    // Updated signUp function to use async/await
    func signUp(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authResult.user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult.user
    }
    
    
    func checkUserExists(email: String) async throws -> Bool {
        // Placeholder implementation; implement proper check
        return true
    }
    
    func signOut() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch let signOutError as NSError {
            return .failure(signOutError)
        }
    }
}
