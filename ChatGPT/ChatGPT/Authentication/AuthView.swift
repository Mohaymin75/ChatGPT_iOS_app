//
//  AuthView.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-13.
//



import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("ChatGPT iOS App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 260)
            
            TextField("Email", text: $viewModel.emailText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.top, 70) // Adjusted padding to lower the text field

            if viewModel.isPasswordVisible {
                SecureField("Password", text: $viewModel.passwordText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.top, 10) // Reduced vertical gap between fields
            }
            
            if viewModel.showLoginButton {
                Button("Login") {
                    viewModel.authenticate(appState: appState)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            if viewModel.showCreateAccountButton {
                Button("Create Account") {
                    viewModel.createAccount(appState: appState)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            Spacer()
            
            if !viewModel.showCreateAccountButton {
                Button(action: {
                    viewModel.prepareForAccountCreation()
                }) {
                    Text("Don't have an account? Create one")
                        .underline()
                        .foregroundColor(.blue)
                }
            } else {
                Button(action: {
                    viewModel.prepareForLogin()
                }) {
                    Text("Already have an account? Go back to login")
                        .underline()
                        .foregroundColor(.blue)
                }
            }
            
            Spacer(minLength: 10) // Added some spacing from the bottom
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                if viewModel.showCreateAccountButton {
                    viewModel.prepareForLogin()
                }
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(AppState())
    }
}
