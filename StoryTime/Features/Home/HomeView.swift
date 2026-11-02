//
//  HomeView.swift
//  StoryTime
//
//  Écran d'accueil : mise en avant de l'« histoire du jour »
//  et accès à la bibliothèque.
//

import SwiftUI

struct HomeView: View {
    @Environment(StoryStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header

                if let story = store.storyOfTheDay {
                    storyOfTheDayCard(story)
                } else if store.state == .loading {
                    ProgressView()
                }

                NavigationLink(value: Route.library) {
                    Label("Découvrir les histoires", systemImage: "books.vertical.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(24)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .background(
            LinearGradient(
                colors: [Color.indigo.opacity(0.18), Color.purple.opacity(0.06)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Accueil")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 72))
                .foregroundStyle(.indigo.gradient)
                .padding(.top, 40)
                .accessibilityHidden(true)

            Text("StoryTime")
                .font(.largeTitle.bold())
                .fontDesign(.rounded)

            Text("Des histoires douces pour rêver, rire et grandir.")
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private func storyOfTheDayCard(_ story: Story) -> some View {
        NavigationLink(value: Route.reader(story)) {
            HStack(spacing: 16) {
                StoryCoverView(story: story, height: 90)
                    .frame(width: 90)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Histoire du jour")
                        .font(.caption.bold())
                        .textCase(.uppercase)
                        .foregroundStyle(story.theme.color)
                    Text(story.title)
                        .font(.headline)
                        .fontDesign(.rounded)
                    Text(story.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(
                Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
            .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Ouvre l'histoire du jour")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(StoryStore.preview)
}
