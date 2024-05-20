//
//  AuthViewModel.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-13.
//



import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isLoading = false
    @Published var isPasswordVisible = true
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var showLoginButton = true
    @Published var showCreateAccountButton = false

    let authService = AuthService.shared

    func authenticate(appState: AppState) {
        isLoading = true
        Task {
            do {
                let user = try await authService.signIn(email: emailText, password: passwordText)
                await MainActor.run {
                    appState.currentUser = user
                    resetFields()
                }
                isLoading = false
            } catch {
                showAlert = true
                alertMessage = "Failed to log in! Check credentials."
                isLoading = false
            }
        }
    }
    
    func createAccount(appState: AppState) {
        isLoading = true
        Task {
            do {
                let user = try await authService.signUp(email: emailText, password: passwordText)
                await MainActor.run {
                    showAlert = true
                    alertMessage = "Account created successfully. Please log in."
                }
                isLoading = false
            } catch {
                showAlert = true
                alertMessage = "Error creating account: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    func prepareForAccountCreation() {
        showCreateAccountButton = true
        showLoginButton = false
    }

    func prepareForLogin() {
        showCreateAccountButton = false
        showLoginButton = true
    }

    private func resetFields() {
        emailText = ""
        passwordText = ""
    }
}
