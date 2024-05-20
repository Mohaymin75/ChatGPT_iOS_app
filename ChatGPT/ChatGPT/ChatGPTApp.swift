//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-13.
//

import SwiftUI

@main
struct ChatGPTApp: App {
    @StateObject var appState: AppState = AppState()
    @State private var showingLaunchScreen = true  // State to control the display of the launch screen

    var body: some Scene {
        WindowGroup {
            Group {
                if showingLaunchScreen {
                    LaunchScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  // Display the launch screen for 2 seconds
                                showingLaunchScreen = false
                            }
                        }
                } else {
                    if appState.isLoggedIn {
                        ContentView()  // Your main content view when logged in
                            .environmentObject(appState)
                    } else {
                        AuthView()  // Your authentication view when not logged in
                            .environmentObject(appState)
                    }
                }
            }
        }
    }
}
