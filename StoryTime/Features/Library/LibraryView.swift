//
//  LibraryView.swift
//  StoryTime
//
//  Bibliothèque : grille d'histoires avec filtre par catégorie.
//

import SwiftUI

struct LibraryView: View {
    @Environment(StoryStore.self) private var store

    /// État local à l'écran : nil = toutes les catégories.
    @State private var selectedCategory: StoryCategory?

    /// Colonnes adaptatives : 2 sur iPhone, davantage sur iPad.
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]

    private var filteredStories: [Story] {
        store.stories(in: selectedCategory)
    }

    var body: some View {
        content
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Bibliothèque")
    }

    @ViewBuilder
    private var content: some View {
        switch store.state {
        case .idle, .loading:
            ProgressView("Chargement…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ContentUnavailableView {
                Label("Oups !", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Réessayer") {
                    Task { await store.load() }
                }
            }

        case .loaded:
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredStories) { story in
                        NavigationLink(value: Route.reader(story)) {
                            StoryCardView(story: story)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .animation(.snappy, value: selectedCategory)
            }
            // La barre de filtres est épinglée en haut, hors du défilement vertical :
            // le geste horizontal n'entre plus en conflit avec le scroll de la grille.
            .safeAreaInset(edge: .top, spacing: 0) {
                CategoryFilterBar(selection: $selectedCategory)
                    .padding(.vertical, 8)
                    .background(Color(.systemGroupedBackground))
            }
            .overlay {
                if filteredStories.isEmpty {
                    ContentUnavailableView(
                        "Aucune histoire",
                        systemImage: "book.closed",
                        description: Text("Il n'y a pas encore d'histoire dans cette catégorie.")
                    )
                }
            }
        }
    }
}

/// Barre horizontale de filtres (« Toutes » + une puce par catégorie).
private struct CategoryFilterBar: View {
    @Binding var selection: StoryCategory?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    chip(title: "Toutes", symbol: "square.grid.2x2.fill", isSelected: selection == nil) {
                        selection = nil
                    }
                    .id("all")
                    ForEach(StoryCategory.allCases) { category in
                        chip(title: category.label, symbol: category.symbol, isSelected: selection == category) {
                            selection = category
                        }
                        .id(category.id)
                    }
                }
            }
            // Marges intégrées au contenu défilant : la dernière puce reste atteignable.
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .scrollIndicators(.hidden)
            .onChange(of: selection) { _, newValue in
                // La puce sélectionnée est ramenée dans la zone visible.
                withAnimation { proxy.scrollTo(newValue?.id ?? "all", anchor: .center) }
            }
        }
    }

    private func chip(title: String, symbol: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbol)
                .font(.subheadline.weight(.semibold))
                .fixedSize()
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .background(
                    isSelected ? AnyShapeStyle(.tint) : AnyShapeStyle(Color(.secondarySystemGroupedBackground)),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
    .environment(StoryStore.preview)
}
