//
//  ContentView.swift
//  SwipeableVideo
//
//  Created by Rizki Siraj on 06/08/24.
//

import SwiftUI
import IsScrolling

struct ContentView: View {
    @StateObject private var videoManager = VideoPlayerManager()
    @State private var scrollID: Int?
    @State private var isScrolling = false
    @State private var isTapped = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    ZStack(alignment: .top) {
                        LazyVStack(spacing: 0) {
                            ForEach(0...videoManager.videos.count-1, id: \.self) { index in
                                VideoPlayerCard(index: index, videoManager: videoManager)
                                    .id(index)
                                    .frame(height: geometry.frame(in: .global).height)
                            }
                        }
                        Text("\(isTapped)")
                    }
                    .scrollTargetLayout()
                }
                .scrollStatusMonitor($isScrolling, monitorMode: .exclusion)
                .scrollPosition(id: $scrollID)
                .onChange(of: scrollID ?? 0) { oldValue, newValue in
                    print(newValue)
                    print(isScrolling)
                }
                .onChange(of: isScrolling) {
                    if(isScrolling == false) {
                        if scrollID ?? 0 < videoManager.currentIndex {
                            videoManager.moveToPreviousVideo()
                            scrollProxy.scrollTo(scrollID, anchor: .top)
                        } else if(scrollID ?? 0 > videoManager.currentIndex) {
                            videoManager.moveToNextVideo()
                            scrollProxy.scrollTo(scrollID, anchor: .top)
                        } else {
                            scrollProxy.scrollTo(scrollID, anchor: .top)
                        }
                    }
                }
                .onTapGesture {
                    
                }
                .gesture(DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                isTapped = true
                            }
                            .onEnded { _ in
                                isTapped = false
                            }
                            
                )
                
            }
            
        }
        .ignoresSafeArea(.container)
        .onAppear {
            videoManager.playVideo(at: 0)
        }
        .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "UIScrollViewDidScrollNotification"))) { _ in
                                let yOffset = geometry.frame(in: .global).minY
                                self.isScrolling = yOffset < 0 || yOffset > 0
                                print(self.isScrolling)
                            }
                    }
        )
}
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension CGFloat {
    func isBetween(_ min: CGFloat, and max: CGFloat) -> Bool {
        return self >= min && self <= max
    }
}

#Preview {
    ContentView()
}
