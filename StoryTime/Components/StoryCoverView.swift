//
//  StoryCoverView.swift
//  StoryTime
//
//  Couverture d'une histoire : SF Symbol sur fond coloré.
//  Réutilisée dans l'accueil et la bibliothèque.
//

import SwiftUI

struct StoryCoverView: View {
    let story: Story
    var height: CGFloat = 120

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: height * 0.18, style: .continuous)
                .fill(story.theme.color.gradient)

            Image(systemName: story.coverSymbol)
                .font(.system(size: height * 0.4, weight: .bold))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .accessibilityHidden(true)
    }
}

#Preview {
    StoryCoverView(story: .sample)
        .padding()
}
