//
//  TutorialVideoView.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-08-03.
//

// TutorialVideoView.swift
import SwiftUI
import AVKit

struct TutorialVideoView: View {
    @StateObject private var viewModel = TutorialVideoViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Loading video...")
            }
        }
        .navigationBarTitle("Tutorial", displayMode: .inline)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
        .onDisappear {
            viewModel.stopVideo()
        }
    }
}
