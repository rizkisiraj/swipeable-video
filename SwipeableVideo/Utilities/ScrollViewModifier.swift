//
//  ScrollViewModifier.swift
//  SwipeableVideo
//
//  Created by Rizki Siraj on 07/08/24.
//

import Foundation
import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = 0

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGFloat

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named(coordinateSpace)).minY)
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                offset = value
            }
    }
}

extension View {
    func trackScroll(_ offset: Binding<CGFloat>, in coordinateSpace: String) -> some View {
        self.modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: offset))
    }
}
