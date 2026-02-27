//
//  GlassButtonStyle.swift
//  DiceyDice
//
//  Created by シン・ジャスティン on 2026/02/28.
//

import SwiftUI

struct ConditionalGlassButtonModifier: ViewModifier {
    var isProminent: Bool

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            if isProminent {
                content
                    .buttonStyle(.glassProminent)
            } else {
                content
                    .buttonStyle(.glass)
            }
        } else {
            if isProminent {
                content
                    .buttonStyle(.borderedProminent)
            } else {
                content
                    .buttonStyle(.bordered)
            }
        }
    }
}

extension View {
    func conditionalGlassButtonStyle(prominent: Bool = false) -> some View {
        modifier(ConditionalGlassButtonModifier(isProminent: prominent))
    }
}
