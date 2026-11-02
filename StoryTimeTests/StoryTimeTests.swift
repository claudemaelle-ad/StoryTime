//
//  StoryTimeTests.swift
//  StoryTimeTests
//
//  Tests unitaires (Swift Testing). Le faux repository montre l'intérêt
//  du protocole StoryRepository : le store est testé sans fichier ni réseau.
//

import Foundation
import Testing
@testable import StoryTime

/// Faux repository : renvoie des données ou une erreur, au choix.
struct MockStoryRepository: StoryRepository {
    var result: Result<[Story], Error>

    func fetchStories() async throws -> [Story] {
        try result.get()
    }
}

// MARK: - Store

@MainActor
struct StoryStoreTests {
    @Test("Un chargement réussi publie les histoires")
    func loadSuccess() async {
        let store = StoryStore(repository: MockStoryRepository(result: .success(Story.samples)))

        await store.load()

        #expect(store.state == .loaded)
        #expect(store.stories.count == Story.samples.count)
    }

    @Test("Une erreur de chargement passe le store en état d'échec")
    func loadFailure() async {
        struct LoadError: Error {}
        let store = StoryStore(repository: MockStoryRepository(result: .failure(LoadError())))

        await store.load()

        #expect(store.stories.isEmpty)
        guard case .failed = store.state else {
            Issue.record("État attendu : .failed, obtenu : \(store.state)")
            return
        }
    }

    @Test("Le filtre par catégorie ne renvoie que la catégorie demandée")
    func filterByCategory() {
        let store = StoryStore(preloadedStories: Story.samples)

        let magic = store.stories(in: .magie)

        #expect(!magic.isEmpty)
        #expect(magic.allSatisfy { $0.category == .magie })
        #expect(store.stories(in: nil).count == Story.samples.count)
    }
}

// MARK: - Décodage JSON

@MainActor
struct StoryDecodingTests {
    @Test("Le fichier stories.json embarqué est valide")
    func bundledJSONIsValid() async throws {
        let stories = try await BundleStoryRepository().fetchStories()

        #expect(!stories.isEmpty)
        #expect(stories.allSatisfy { !$0.pages.isEmpty })
        #expect(Set(stories.map(\.id)).count == stories.count, "Les identifiants doivent être uniques")
    }

    @Test("L'illustration d'une page est optionnelle")
    func pageSymbolIsOptional() throws {
        let stories = try JSONDecoder().decode([Story].self, from: Self.json(category: "nature"))

        #expect(stories.first?.pages.first?.symbol == nil)
    }

    @Test("Une catégorie inconnue est rejetée au décodage")
    func unknownCategoryIsRejected() {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode([Story].self, from: Self.json(category: "inconnue"))
        }
    }

    private static func json(category: String) -> Data {
        Data("""
        [{
          "id": "test", "title": "Titre", "summary": "Résumé", "ageRange": "3-5 ans",
          "category": "\(category)", "coverSymbol": "leaf.fill", "theme": "green",
          "pages": [{ "id": 1, "text": "Il était une fois…" }]
        }]
        """.utf8)
    }
}
