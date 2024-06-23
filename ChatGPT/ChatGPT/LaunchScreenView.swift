//
//  LaunchScreenView.swift
//  ConvoTrack
//
//  Created by Mohaymin Islam on 2024-06-19.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var scale = 1.0  // Initial scale of the image

    var body: some View {
        GeometryReader { geometry in
            Image("ChatGPTIconImg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(scale)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .onAppear {
                    withAnimation(.easeIn(duration: 2)) {  // Animation duration of 2 seconds
                        scale = 1.5  // Zoom the image to 1.5 times its original size
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
