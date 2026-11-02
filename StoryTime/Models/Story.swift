//
//  Story.swift
//  StoryTime
//
//  Modèles immuables, décodés depuis stories.json.
//  - Codable : décodage JSON sans code supplémentaire
//  - Identifiable : requis par ForEach
//  - Hashable : navigation par valeur (Route.reader(Story))
//

import Foundation

nonisolated struct Story: Identifiable, Hashable, Codable, Sendable {
    /// Identifiant lisible et stable (ex. "le-petit-renard"), utile pour de futurs favoris.
    let id: String
    let title: String
    let summary: String
    let ageRange: String
    let category: StoryCategory
    /// Nom d'un SF Symbol. Deviendra `coverImageURL` avec de vraies illustrations.
    let coverSymbol: String
    let theme: StoryTheme
    let pages: [StoryPage]
}

nonisolated struct StoryPage: Identifiable, Hashable, Codable, Sendable {
    /// Numéro de page.
    let id: Int
    let text: String
    /// Illustration optionnelle (SF Symbol).
    let symbol: String?
}
