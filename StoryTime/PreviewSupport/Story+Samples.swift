//
//  Story+Samples.swift
//  StoryTime
//
//  Données statiques pour les Previews : affichage instantané,
//  sans dépendre du chargement du JSON.
//

import Foundation

extension Story {
    static let sample = Story(
        id: "sample-renard",
        title: "Le petit renard curieux",
        summary: "Filou le renardeau part explorer la forêt.",
        ageRange: "3-5 ans",
        category: .animaux,
        coverSymbol: "pawprint.fill",
        theme: .orange,
        pages: [
            StoryPage(id: 1, text: "Au fond de la forêt vivait un petit renard au pelage roux.", symbol: "tree.fill"),
            StoryPage(id: 2, text: "Un matin, Filou entendit un drôle de bruit : « Ploc ! »", symbol: "ear.fill"),
            StoryPage(id: 3, text: "Il se fit une nouvelle amie, la grenouille. Fin.", symbol: nil)
        ]
    )

    static let samples: [Story] = [
        sample,
        Story(
            id: "sample-tortue",
            title: "Lila la tortue et les étoiles",
            summary: "Une petite tortue rêve de toucher les étoiles.",
            ageRange: "4-6 ans",
            category: .magie,
            coverSymbol: "moon.stars.fill",
            theme: .purple,
            pages: [
                StoryPage(id: 1, text: "Chaque soir, Lila levait la tête vers le ciel.", symbol: "tortoise.fill"),
                StoryPage(id: 2, text: "Elle toucha enfin une étoile. Fin.", symbol: "star.fill")
            ]
        ),
        Story(
            id: "sample-bateau",
            title: "Le voyage du bateau de papier",
            summary: "Un bateau de papier part à l'aventure.",
            ageRange: "5-7 ans",
            category: .aventure,
            coverSymbol: "sailboat.fill",
            theme: .blue,
            pages: [
                StoryPage(id: 1, text: "Il pleuvait depuis le matin.", symbol: "cloud.rain.fill")
            ]
        )
    ]
}

extension StoryStore {
    /// Store déjà rempli, pour les Previews.
    static var preview: StoryStore {
        StoryStore(preloadedStories: Story.samples)
    }
}
