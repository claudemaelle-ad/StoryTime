//
//  StoryCardView.swift
//  StoryTime
//
//  Carte d'une histoire dans la grille de la bibliothèque.
//

import SwiftUI

struct StoryCardView: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            StoryCoverView(story: story, height: 110)

            Text(story.title)
                .font(.headline)
                .fontDesign(.rounded)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)

            HStack(spacing: 6) {
                Label(story.category.label, systemImage: story.category.symbol)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Text(story.ageRange)
                    .lineLimit(1)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    StoryCardView(story: .sample)
        .frame(width: 180)
        .padding()
        .background(Color(.systemGroupedBackground))
}
