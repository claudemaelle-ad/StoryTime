//
//  StoryStore.swift
//  StoryTime
//
//  État partagé de l'app (pattern « MV » : pas de ViewModel par écran).
//  @Observable (iOS 17) : SwiftUI ne redessine que les vues qui lisent
//  les propriétés modifiées.
//

import Foundation
import Observation

@Observable
final class StoryStore {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var stories: [Story]
    private(set) var state: LoadState

    private let repository: any StoryRepository

    init(repository: any StoryRepository = BundleStoryRepository(), preloadedStories: [Story] = []) {
        self.repository = repository
        self.stories = preloadedStories
        self.state = preloadedStories.isEmpty ? .idle : .loaded
    }

    /// Une histoire différente chaque jour, de façon déterministe.
    var storyOfTheDay: Story? {
        guard !stories.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 0
        return stories[day % stories.count]
    }

    func stories(in category: StoryCategory?) -> [Story] {
        guard let category else { return stories }
        return stories.filter { $0.category == category }
    }

    func load() async {
        guard state != .loading, state != .loaded else { return }
        state = .loading
        do {
            stories = try await repository.fetchStories()
            state = .loaded
        } catch {
            #if DEBUG
            print("❌ Chargement des histoires impossible :", error)
            #endif
            state = .failed(error.localizedDescription)
        }
    }
}
