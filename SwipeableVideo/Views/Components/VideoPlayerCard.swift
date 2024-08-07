//
//  VideoPlayerCard.swift
//  SwipeableVideo
//
//  Created by Rizki Siraj on 06/08/24.
//

import SwiftUI
import AVKit

struct VideoPlayerCard: View {
    let index: Int
    @ObservedObject var videoManager: VideoPlayerManager
    
    var body: some View {
        ZStack(alignment: .leading) {
            VideoPlayer(player: videoManager.getPlayer(for: index))
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text("Title of this video")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("Description of this video")
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    EmptyView()
}

