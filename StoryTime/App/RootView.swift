//
//  RootView.swift
//  StoryTime
//
//  Racine de la navigation : un seul NavigationStack, des destinations
//  déclarées à un seul endroit. Les écrans ne se connaissent pas entre eux.
//

import SwiftUI

struct RootView: View {
    @Environment(StoryStore.self) private var store

    /// Pile de navigation explicite : permet plus tard les deep links
    /// ou un retour à l'accueil en une ligne (`path.removeAll()`).
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .library:
                        LibraryView()
                    case .reader(let story):
                        ReaderView(story: story)
                    }
                }
        }
        .task {
            await store.load()
        }
    }
}

#Preview {
    RootView()
        .environment(StoryStore.preview)
}
