//
//  TutorialVideoViewModel.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-08-03.
//

// TutorialVideoViewModel.swift
import AVKit

class TutorialVideoViewModel: ObservableObject {
    @Published var player: AVPlayer?
    
    init() {
        setupVideo()
    }
    
    private func setupVideo() {
        guard let videoURL = Bundle.main.url(forResource: "TutorialVideo", withExtension: "mov") else {
            print("Video file not found")
            return
        }
        
        player = AVPlayer(url: videoURL)
    }
    
    func stopVideo() {
        player?.pause()
        player?.seek(to: .zero)
    }
}
