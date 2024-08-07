# SwipeableVideo Documentation

## Overview
SwipeableVideo is a SwiftUI application that allows users to swipe through a series of videos. It features a custom video player manager for handling video playback and a scrollable interface to navigate through the video list.

## Project Structure
- **SwipeableVideo.xcodeproj**: The Xcode project file.
- **SwipeableVideo**: Contains the main application source code.
- **SwipeableVideoTests**: Unit tests for the application.
- **SwipeableVideoUITests**: UI tests for the application.

## Key Components
### VideoPlayerManager
Manages the playback of videos, including loading, playing, and moving to the next or previous video.

### ContentView
The main view of the application. It uses a `ScrollView` to display a list of videos, each wrapped in a `VideoPlayerCard`.

#### Properties:
- `@StateObject private var videoManager = VideoPlayerManager()`: Manages the video playback state.
- `@State private var scrollID: Int?`: Tracks the current scroll position.
- `@State private var isScrolling = false`: Indicates whether the user is scrolling.
- `@GestureState private var isTapped = false`: Detects if the user's finger is on the screen.

#### Layout:
- **GeometryReader**: Provides access to the size and position of the container view.
- **ScrollViewReader**: Enables programmatic scrolling.
- **ScrollView**: Displays a vertically scrollable list of `VideoPlayerCard` views.
- **LazyVStack**: Efficiently lays out the video cards.

#### Gestures:
- **DragGesture**: Detects user interaction with the screen, enhancing the scrolling experience similar to TikTok, ensuring users can't skip more than one video per scroll. However, it has drawbacks due to SwiftUI's ScrollView potentially interfering with the drag gesture.

## Usage
1. **Preload Videos**: On appear, preload the first three videos and start playing the first video.
2. **Scroll Detection**: Use `scrollStatusMonitor` and `scrollPosition` to track scrolling.
3. **Gesture Handling**: Use `DragGesture` to detect user interaction and update scrolling state.


## Example Code
```swift
struct ContentView: View {
    @StateObject private var videoManager = VideoPlayerManager()
    @State private var scrollID: Int?
    @State private var isScrolling = false
    @GestureState private var isTapped = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    ZStack {
                        LazyVStack(spacing: 0) {
                            ForEach(0..<videoManager.videos.count, id: \.self) { index in
                                VideoPlayerCard(video: videoManager.videos[index], videoManager: videoManager)
                                    .id(index)
                                    .frame(height: 600)
                            }
                        }
                        Text("\(isScrolling)")
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
                    if !isScrolling {
                        if scrollID ?? 0 < videoManager.currentIndex {
                            videoManager.moveToPreviousVideo()
                            scrollProxy.scrollTo(scrollID, anchor: .top)
                        } else if scrollID ?? 0 > videoManager.currentIndex {
                            videoManager.moveToNextVideo()
                            scrollProxy.scrollTo(scrollID, anchor: .top)
                        }
                    }
                }
                .gesture(DragGesture()
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
            videoManager.preloadVideos(startIndex: 0, count: 3)
            videoManager.playCurrentVideo()
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UIScrollViewDidScrollNotification"), object: nil, queue: .main) { _ in
                self.isScrolling = true
            }
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
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

For more details, visit the [GitHub repository](https://github.com/rizkisiraj/swipeable-video).
